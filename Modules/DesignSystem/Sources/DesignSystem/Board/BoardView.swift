//
//  BoardView.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 26/09/2026.
//

import Domain
import SwiftUI

/// A view that displays the grid a game is played on.
///
/// The view sizes itself to the largest square its parent allows.
public struct BoardView: View {

    private let size: Int

    /// Creates a board.
    ///
    /// - Parameter size: The number of cells along each edge. Must be greater
    ///   than zero.
    public init(size: Int) {
        precondition(size > 0)
        self.size = size
    }

    public var body: some View {
        BoardGridLayout(size: size, spacing: Theme.Board.spacing) {
            ForEach(cells, id: \.self) { position in
                RoundedRectangle(cornerRadius: Theme.Board.tileRadius, style: .continuous)
                    .fill(Theme.Colors.emptyCell)
                    .layoutValue(key: BoardCell.self, value: position)
            }
        }
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
    BoardView(size: 4)
        .padding(Theme.Spacing.medium)
        .background(Theme.Colors.surface)
}
