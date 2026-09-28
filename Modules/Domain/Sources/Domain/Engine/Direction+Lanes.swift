//
//  Direction+Lanes.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Foundation

extension Direction {

    /// The lines of cells tiles slide along, for a board of a given size.
    ///
    /// Each lane is ordered from the edge the tiles move towards, so the first
    /// position is where the first tile of the lane comes to rest.
    func lanes(size: Int) -> [[Position]] {
        let forward = Array(0..<size)
        let backward = Array(forward.reversed())

        return switch self {
        case .left:
            forward.map { row in forward.map { Position(row: row, column: $0) } }
        case .right:
            forward.map { row in backward.map { Position(row: row, column: $0) } }
        case .up:
            forward.map { column in forward.map { Position(row: $0, column: column) } }
        case .down:
            forward.map { column in backward.map { Position(row: $0, column: column) } }
        }
    }
}
