//
//  BoardMetrics.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 28/09/2026.
//

import CoreGraphics
import Domain

/// The geometry of a square board of equally sized cells.
///
/// A board of `size` cells has `size + 1` gutters: one between each pair of
/// cells, and one along each edge.
struct BoardMetrics {

    /// The number of cells along each edge.
    let size: Int

    /// The length of the board's edge, in points.
    let side: CGFloat

    /// The width of a gutter, in points.
    let spacing: CGFloat

    /// The length of a cell's edge, in points.
    ///
    /// The value is never negative, however small `side` is.
    var cell: CGFloat {
        max(0, (side - spacing * CGFloat(size + 1)) / CGFloat(size))
    }

    /// Returns the frame of the cell at a position.
    ///
    /// - Parameter position: A cell of the board.
    /// - Returns: The cell's frame, in the board's coordinate space, measured
    ///   from its top-left corner.
    func frame(of position: Position) -> CGRect {
        CGRect(
            x: spacing + CGFloat(position.column) * (cell + spacing),
            y: spacing + CGFloat(position.row) * (cell + spacing),
            width: cell,
            height: cell
        )
    }
}
