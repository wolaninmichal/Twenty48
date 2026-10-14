//
//  Tile.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Foundation

/// A numbered tile.
public struct Tile: Hashable, Sendable {
    public let id: TileID
    /// A power of two, at least 2.
    public let value: Int

    init(id: TileID, value: Int) {
        self.id = id
        self.value = value
    }
}

/// A tile together with the cell it occupies.
public struct PlacedTile: Hashable, Sendable {
    public let tile: Tile
    public let position: Position
}
