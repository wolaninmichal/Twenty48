//
//  BoardView.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 26/09/2026.
//

import Domain
import SwiftUI

/// A view that displays the grid a game is played on, and its tiles.
///
/// A tile that changes cell slides there. How a tile enters and leaves
/// depends on its `BoardTile.Kind`.
///
/// The view sizes itself to the largest square its parent allows.
public struct BoardView: View {

    private let size: Int
    private let tiles: [BoardTile]

    /// Creates a board.
    ///
    /// - Parameters:
    ///   - size: The number of cells along each edge. Must be greater than zero.
    ///   - tiles: The tiles on the board. Their identities must be unique.
    public init(size: Int, tiles: [BoardTile] = []) {
        precondition(size > 0)
        self.size = size
        self.tiles = tiles
    }

    public var body: some View {
        BoardGridLayout(size: size, spacing: Theme.Board.spacing) {
            ForEach(cells, id: \.self) { position in
                RoundedRectangle(cornerRadius: Theme.Board.tileRadius, style: .continuous)
                    .fill(Theme.Colors.emptyCell)
                    .layoutValue(key: BoardCell.self, value: position)
            }

            ForEach(tiles) { tile in
                TileView(value: tile.value)
                    .zIndex(tile.kind.zIndex)
                    .transition(tile.kind.transition)
                    .layoutValue(key: BoardCell.self, value: tile.position)
            }
        }
        .animation(Theme.Motion.tileSlide, value: tiles)
        .background(
            Theme.Colors.board,
            in: RoundedRectangle(cornerRadius: Theme.Radius.control, style: .continuous)
        )
        .aspectRatio(1, contentMode: .fit)
    }

    /// Every cell of the board, row by row.
    private var cells: [Position] {
        (0..<size).flatMap { row in
            (0..<size).map { column in Position(row: row, column: column) }
        }
    }
}

#Preview {
    let values = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096]
    let tiles = values.enumerated().map { index, value in
        BoardTile(
            id: TileID(rawValue: UInt64(index)),
            value: value,
            position: Position(row: index / 4, column: index % 4)
        )
    }

    return BoardView(size: 4, tiles: tiles)
        .padding(Theme.Spacing.medium)
        .background(Theme.Colors.surface)
}
