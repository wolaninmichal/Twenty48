//
//  File.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Foundation

extension Board {

    /// Places a new tile, a 2 or a 4, in a random empty cell.
    ///
    /// - Parameters:
    ///   - rules: The rules deciding how often the tile is a 4.
    ///   - ids: The source of the tile's identity.
    ///   - generator: The source of randomness.
    /// - Returns: The tile placed, or `nil` if the board is full.
    @discardableResult
    mutating func spawnTile(
        rules: GameRules,
        ids: inout TileIDGenerator,
        using generator: inout some RandomNumberGenerator
    ) -> PlacedTile? {
        guard let position = emptyPositions.randomElement(using: &generator) else { return nil }

        let value = Double.random(in: 0..<1, using: &generator) < rules.fourProbability ? 4 : 2
        let tile = Tile(id: ids.next(), value: value)
        self[position] = tile
        return PlacedTile(tile: tile, position: position)
    }
}
