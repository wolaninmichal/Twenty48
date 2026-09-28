//
//  Position.swift
//  Domain
//
//  Created by Michał Wolanin on 25/09/2026.
//

import Foundation

/// A cell on the board, counted from the top-left corner.
public struct Position: Hashable, Sendable, Codable {
    public let row: Int
    public let column: Int
    
    public init(
        row: Int,
        column: Int
    ) {
        self.row = row
        self.column = column
    }
}
