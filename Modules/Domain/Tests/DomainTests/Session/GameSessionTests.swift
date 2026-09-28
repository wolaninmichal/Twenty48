//
//  File.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Testing
@testable import Domain

@Suite("A game session")
struct GameSessionTests {

    @Test func startsWithTheStartingTiles() {
        let session = GameSession(seed: 1)

        #expect(session.game.board.tiles.count == GameRules.classic.startingTileCount)
        #expect(session.game.score == 0)
        #expect(session.game.status == .playing)
    }

    @Test func theSameSeedPlaysTheSameGame() {
        var first = GameSession(seed: 42)
        var second = GameSession(seed: 42)

        for direction in [Direction.left, .up, .right, .down, .left, .up, .right, .down] {
            first.apply(.move(direction))
            second.apply(.move(direction))
        }

        #expect(first == second)
    }

    @Test func aMoveSpawnsExactlyOneTile() throws {
        var session = GameSession(seed: 7)
        let before = session.game.board.tiles.count

        var turn: Turn?
        for direction in Direction.allCases where turn == nil {
            turn = session.apply(.move(direction))
        }
        let played = try #require(turn)

        #expect(played.spawned.count == 1)
        #expect(session.game.board.tiles.count == before - played.merges.count + 1)
    }

    @Test func aRestartNeverReusesTileIdentities() {
        var session = GameSession(seed: 3)
        let before = Set(session.game.board.tiles.map(\.tile.id))

        session.apply(.restart)
        let after = Set(session.game.board.tiles.map(\.tile.id))

        #expect(before.isDisjoint(with: after))
        #expect(session.game.score == 0)
    }

    @Test func winningPausesTheGameUntilThePlayerGoesOn() throws {
        // Only fours on a 2×2 board: the board can't jam before an 8 appears.
        let rules = GameRules(boardSize: 2, winningValue: 8, startingTileCount: 2, fourProbability: 1)
        var session = GameSession(rules: rules, seed: 11)

        for direction in Array(repeating: Direction.allCases, count: 10).joined()
        where session.game.status == .playing {
            session.apply(.move(direction))
        }

        try #require(session.game.status == .won)
        #expect(session.apply(.move(.left)) == nil)
        #expect(session.apply(.keepPlaying) != nil)
        #expect(session.game.status != .won)
        #expect(session.game.isEndless)
    }
}
