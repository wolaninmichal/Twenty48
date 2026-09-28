//
//  File.swift
//  Presentation
//
//  Created by Michał Wolanin on 26/09/2026.
//

import DesignSystem
import Domain

/// One snapshot of everything the game screen draws.
///
/// A single `Equatable` value rather than a handful of `@Published`
/// properties: the view can never be caught between two publishes, and the
/// whole screen is reproducible from one value in a preview or a test.
public struct GameViewState: Equatable, Sendable {

    /// A message covering the board.
    public enum Overlay: Equatable, Sendable {
        case won
        case over(score: Int)
    }

    public var boardSize: Int
    public var tiles: [BoardTile]
    public var overlay: Overlay?

    public static func empty(boardSize: Int) -> GameViewState {
        GameViewState(boardSize: boardSize, tiles: [], overlay: nil)
    }
}

extension GameViewState {

    /// Draws a game.
    ///
    /// - Parameters:
    ///   - game: The game to draw.
    ///   - turn: What the last intent did, or `nil` once it has played out.
    ///     Tiles that merged away are drawn only while it is set.
    init(game: Game, turn: Turn?) {
        let merged = Set(turn?.merges.map(\.result.id) ?? [])
        let spawned = Set(turn?.spawned.map(\.tile.id) ?? [])

        let absorbed = (turn?.merges ?? []).flatMap { merge in
            merge.sources.map { source in
                BoardTile(id: source.id, value: source.value, position: merge.position, kind: .absorbed)
            }
        }

        let onBoard = game.board.tiles.map { placed in
            let id = placed.tile.id
            let kind: BoardTile.Kind =
                if merged.contains(id) { .merged }
                else if spawned.contains(id) { .spawned }
                else { .resting }
            return BoardTile(id: id, value: placed.tile.value, position: placed.position, kind: kind)
        }

        self.init(
            boardSize: game.board.size,
            tiles: absorbed + onBoard,
            overlay: Overlay(status: game.status, score: game.score)
        )
    }
}

private extension GameViewState.Overlay {

    init?(status: Game.Status, score: Int) {
        switch status {
        case .playing: return nil
        case .won: self = .won
        case .over: self = .over(score: score)
        }
    }
}
