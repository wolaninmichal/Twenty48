//
//  BoardCell.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Domain
import SwiftUI

/// A layout value that names the cell a subview of `BoardGridLayout` occupies.
///
/// Attach it with `layoutValue(key:value:)`. A subview that omits the value
/// occupies the top-left cell.
struct BoardCell: LayoutValueKey {
    static let defaultValue = Position(row: 0, column: 0)
}
