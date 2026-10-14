//
//  File.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Foundation

/// A game together with everything needed to go on playing it.
///
/// The session is the reducer of the game: a value that intents are applied
/// to, one at a time. It owns its randomness and its tile identities, so two
/// sessions with the same seed, given the same intents, stay equal.
public struct GameSession: Equatable, Sendable {

    public let rules: GameRules
    public private(set) var game: Game

    private var random: SplitMix64
    private var ids: TileIDGenerator

    /// Creates a session and starts its first game.
    ///
    /// - Parameters:
    ///   - rules: The rules every game of the session is played by.
    ///   - seed: The seed of the session's randomness.
    public init(rules: GameRules = .classic, seed: UInt64) {
        self.rules = rules
        self.game = Game(boardSize: rules.boardSize)
        self.random = SplitMix64(seed: seed)
        self.ids = TileIDGenerator()
        restart()
    }

    /// Applies an intent to the game.
    ///
    /// - Parameter intent: What the player asks for.
    /// - Returns: What the intent did, or `nil` if it had no effect, as when
    ///   the tiles can't move that way or the game isn't being played.
    @discardableResult
    public mutating func apply(_ intent: GameIntent) -> Turn? {
        switch intent {
        case .move(let direction):
            return move(direction)
        case .keepPlaying:
            return keepPlaying()
        case .restart:
            return restart()
        }
    }

    // MARK: - Private

    private mutating func move(_ direction: Direction) -> Turn? {
        guard game.status == .playing,
              let result = game.board.sliding(towards: direction, ids: &ids)
        else { return nil }

        // A move that changed the board always leaves a cell free.
        var board = result.board
        let spawned = board.spawnTile(rules: rules, ids: &ids, using: &random)

        game.board = board
        game.score += result.points
        game.resolveStatus(against: rules)

        return Turn(merges: result.merges, spawned: spawned.map { [$0] } ?? [])
    }

    private mutating func keepPlaying() -> Turn? {
        guard game.status == .won else { return nil }

        game.isEndless = true
        game.resolveStatus(against: rules)
        return Turn.none
    }

    /// Identities and randomness carry on across games, so a tile of the old
    /// board and a tile of the new one never share an identity. A view
    /// fading one out while the other fades in can tell them apart.
    @discardableResult
    private mutating func restart() -> Turn {
        game = Game(boardSize: rules.boardSize)

        var spawned: [PlacedTile] = []
        for _ in 0..<rules.startingTileCount {
            if let tile = game.board.spawnTile(rules: rules, ids: &ids, using: &random) {
                spawned.append(tile)
            }
        }
        return Turn(merges: [], spawned: spawned)
    }
}
