//
//  BoardLayout.swift
//  Domain
//
//  Created by Michał Wolanin on 26/09/2026.
//

import SwiftUI

/// A layout that arranges its subviews in the cells of a square grid.
///
/// Each subview names the cell it occupies with the `BoardCell` layout value:
///
///     BoardGridLayout(size: 4, spacing: 8) {
///         ForEach(positions, id: \.self) { position in
///             Cell().layoutValue(key: BoardCell.self, value: position)
///         }
///     }
///
/// A subview's frame is its cell, so a scale transition grows from the cell's
/// center, and a change of cell animates as an ordinary change of frame.
struct BoardGridLayout: Layout {

    /// The number of cells along each edge.
    let size: Int

    /// The distance between adjacent cells, and between a cell and the edge.
    let spacing: CGFloat

    // MARK: - Layout

    /// Returns the size of the grid, which is always square.
    /// The grid has a fixed structure, so it doesn't measure its subviews.
    ///
    /// - Parameters:
    ///   - proposal: The size proposed by the container view.
    ///   - subviews: The subviews of the grid.
    ///   - cache: Unused.
    /// - Returns: A square whose side is the largest the proposal allows.
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let side = Self.side(fitting: proposal)
        return CGSize(width: side, height: side)
    }

    /// Assigns a position and a proposed size to each subview.
    ///
    /// The grid is centered in `bounds`, which may be larger or non-square
    /// when a parent imposes a size.
    ///
    /// - Parameters:
    ///   - bounds: The region the grid occupies in its parent's coordinate space.
    ///   - proposal: The size proposed by the container view.
    ///   - subviews: The subviews of the grid.
    ///   - cache: Unused.
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        // Measured from what was granted rather than from what sizeThatFits
        // asked for, because a parent may impose a size.
        let side = min(bounds.width, bounds.height)
        let metrics = BoardMetrics(size: size, side: side, spacing: spacing)
        let origin = CGPoint(x: bounds.midX - side / 2, y: bounds.midY - side / 2)
        let cellProposal = ProposedViewSize(width: metrics.cell, height: metrics.cell)

        for subview in subviews {
            let frame = metrics.frame(of: subview[BoardCell.self])
            subview.place(
                at: CGPoint(x: origin.x + frame.minX, y: origin.y + frame.minY),
                anchor: .topLeading,
                proposal: cellProposal
            )
        }
    }

    // MARK: - Private

    /// Returns the side of the largest square that fits a proposal.
    ///
    /// A proposed dimension may be `nil`, asking the layout for its natural
    /// size, or infinite, as inside a scroll view. Both are ignored.
    ///
    /// - Parameter proposal: The size proposed by the container view.
    /// - Returns: The smaller finite dimension of the proposal, or 320 points
    ///   if neither dimension constrains the grid.
    private static func side(
        fitting proposal: ProposedViewSize
    ) -> CGFloat {
        let limits = [proposal.width, proposal.height]
            .compactMap { $0 }
            .filter(\.isFinite)
        return limits.min() ?? 320
    }
}
