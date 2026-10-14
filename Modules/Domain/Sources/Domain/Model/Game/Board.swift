//
//  Board.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Foundation

/// The square board a game is played on, each cell empty or holding a tile.
public struct Board: Equatable, Sendable {

    private var cells: Grid<Tile?>

    /// The number of cells along each edge.
    public var size: Int { cells.size }

    /// Creates an empty board.
    init(size: Int) {
        cells = Grid(size: size, repeating: nil)
    }

    /// The tile at a position, or `nil` if the cell is empty.
    public internal(set) subscript(position: Position) -> Tile? {
        get { cells[position] }
        set { cells[position] = newValue }
    }

    /// Every cell of the board, row by row.
    public var positions: [Position] { cells.positions }

    /// Every tile on the board, row by row.
    public var tiles: [PlacedTile] {
        positions.compactMap { position in
            self[position].map { PlacedTile(tile: $0, position: position) }
        }
    }

    /// The cells with no tile, row by row.
    public var emptyPositions: [Position] {
        positions.filter { self[$0] == nil }
    }

    /// The largest value on the board, or 0 if the board is empty.
    public var highestValue: Int {
        tiles.map(\.tile.value).max() ?? 0
    }

    /// Whether any move would change the board: a cell is empty, or two
    /// neighbouring tiles hold the same value.
    public var canMove: Bool {
        positions.contains { position in
            guard let tile = self[position] else { return true }
            // Right and down are enough: every neighbouring pair is visited once.
            let neighbours = [
                Position(row: position.row, column: position.column + 1),
                Position(row: position.row + 1, column: position.column),
            ]
            return neighbours.contains { neighbour in
                cells.contains(neighbour) && self[neighbour]?.value == tile.value
            }
        }
    }
}
