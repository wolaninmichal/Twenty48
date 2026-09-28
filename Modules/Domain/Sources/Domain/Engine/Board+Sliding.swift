//
//  Board+Sliding.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Foundation

extension Board {

    /// Slides every tile as far as it goes in a direction, merging equal
    /// neighbours on the way.
    ///
    /// A tile merges at most once per move, and the pair nearer the edge
    /// merges first: `2 2 2 ·` slid right becomes `· · 2 4`.
    ///
    /// - Parameters:
    ///   - direction: The direction the tiles move in.
    ///   - ids: The source of identities for merged tiles. Left untouched when
    ///     nothing moves.
    /// - Returns: The outcome, or `nil` if no tile can move that way.
    func sliding(towards direction: Direction, ids: inout TileIDGenerator) -> MoveResult? {
        var board = Board(size: size)
        var merges: [Merge] = []

        for lane in direction.lanes(size: size) {
            var settled: [Tile] = []
            // Only the last settled tile can take a merge, and only if it
            // hasn't merged already.
            var lastCanMerge = false

            for position in lane {
                guard let tile = self[position] else { continue }

                if lastCanMerge, let last = settled.last, last.value == tile.value {
                    let result = Tile(id: ids.next(), value: tile.value * 2)
                    settled[settled.count - 1] = result
                    merges.append(Merge(position: lane[settled.count - 1], sources: [last, tile], result: result))
                    lastCanMerge = false
                } else {
                    settled.append(tile)
                    lastCanMerge = true
                }
            }

            for (tile, position) in zip(settled, lane) {
                board[position] = tile
            }
        }

        // A merge always changes the board, so identities are only spent on
        // moves that happen.
        return board == self ? nil : MoveResult(board: board, merges: merges)
    }
}
