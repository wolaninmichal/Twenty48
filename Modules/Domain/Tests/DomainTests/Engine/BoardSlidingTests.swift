//
//  BoardSlidingTests.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Testing
@testable import Domain

@Suite("Sliding a board")
struct BoardSlidingTests {

    private let empty = [0, 0, 0, 0]

    @Test func tilesSlideToTheEdge() throws {
        var ids = TileIDGenerator()
        let board = Board.fixture([
            [0, 2, 0, 4],
            [0, 0, 0, 0],
            [0, 0, 8, 0],
            [0, 0, 0, 2],
        ], ids: &ids)

        let result = try #require(board.sliding(towards: .left, ids: &ids))

        #expect(result.board.values == [
            [2, 4, 0, 0],
            [0, 0, 0, 0],
            [8, 0, 0, 0],
            [2, 0, 0, 0],
        ])
        #expect(result.merges.isEmpty)
        #expect(result.points == 0)
    }

    @Test(arguments: [
        ([2, 2, 2, 2], [4, 4, 0, 0]),
        ([2, 2, 4, 0], [4, 4, 0, 0]),
        ([4, 4, 8, 0], [8, 8, 0, 0]),
        ([2, 0, 2, 2], [4, 2, 0, 0]),
        ([2, 4, 2, 4], [2, 4, 2, 4]),
    ])
    func eachTileMergesAtMostOnce(row: [Int], expected: [Int]) {
        var ids = TileIDGenerator()
        let board = Board.fixture([row, empty, empty, empty], ids: &ids)

        let result = board.sliding(towards: .left, ids: &ids)

        #expect((result?.board ?? board).values[0] == expected)
    }

    @Test func thePairNearerTheEdgeMergesFirst() throws {
        var ids = TileIDGenerator()
        let board = Board.fixture([[2, 2, 2, 0], empty, empty, empty], ids: &ids)

        let result = try #require(board.sliding(towards: .right, ids: &ids))

        #expect(result.board.values[0] == [0, 0, 2, 4])
    }

    @Test func columnsSlideVertically() throws {
        var ids = TileIDGenerator()
        let board = Board.fixture([
            [2, 0, 0, 0],
            [2, 0, 0, 0],
            [0, 0, 0, 0],
            [4, 0, 0, 0],
        ], ids: &ids)

        let result = try #require(board.sliding(towards: .down, ids: &ids))

        #expect(result.board.values.map(\.[0]) == [0, 0, 4, 4])
    }

    @Test func aMergeReportsItsSourcesAndScore() throws {
        var ids = TileIDGenerator()
        let board = Board.fixture([[0, 2, 0, 2], empty, empty, empty], ids: &ids)
        let near = try #require(board[Position(row: 0, column: 3)])
        let far = try #require(board[Position(row: 0, column: 1)])

        let result = try #require(board.sliding(towards: .right, ids: &ids))
        let merge = try #require(result.merges.first)

        #expect(merge.position == Position(row: 0, column: 3))
        #expect(merge.sources == [near, far])
        #expect(merge.result.value == 4)
        #expect(merge.result.id != near.id && merge.result.id != far.id)
        #expect(result.points == 4)
    }

    @Test func nothingHappensWhenNoTileCanMove() {
        var ids = TileIDGenerator()
        let board = Board.fixture([[2, 4, 0, 0], [8, 0, 0, 0], empty, empty], ids: &ids)

        #expect(board.sliding(towards: .left, ids: &ids) == nil)
        #expect(board.sliding(towards: .up, ids: &ids) == nil)
    }

    @Test func aFullBoardWithoutPairsCannotMove() {
        var ids = TileIDGenerator()
        let board = Board.fixture([
            [2, 4, 2, 4],
            [4, 2, 4, 2],
            [2, 4, 2, 4],
            [4, 2, 4, 2],
        ], ids: &ids)

        #expect(!board.canMove)
    }
}
