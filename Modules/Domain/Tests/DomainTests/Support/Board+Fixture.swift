//
//  Board+Fixture.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Foundation
@testable import Domain

extension Board {

    /// A board laid out from rows of values, where 0 is an empty cell.
    static func fixture(_ rows: [[Int]], ids: inout TileIDGenerator) -> Board {
        precondition(rows.allSatisfy { $0.count == rows.count }, "A board is square")

        var board = Board(size: rows.count)
        for (row, values) in rows.enumerated() {
            for (column, value) in values.enumerated() where value != 0 {
                board[Position(row: row, column: column)] = Tile(id: ids.next(), value: value)
            }
        }
        return board
    }

    /// The values of the board, row by row, with 0 for an empty cell.
    var values: [[Int]] {
        (0..<size).map { row in
            (0..<size).map { column in self[Position(row: row, column: column)]?.value ?? 0 }
        }
    }
}
