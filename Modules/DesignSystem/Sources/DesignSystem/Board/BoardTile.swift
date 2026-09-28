//
//  BoardTile.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Domain

/// A tile as the board draws it.
public struct BoardTile: Identifiable, Equatable, Sendable {

    /// The part a tile plays in the move being drawn, which decides how it
    /// enters, leaves and stacks.
    public enum Kind: Equatable, Sendable {
        /// On the board before the move, and still there.
        case resting
        /// New after the move. Grows in once the others have slid.
        case spawned
        /// Made by the move. Pops in once its sources have slid together.
        case merged
        /// Merged away. Slides to the merge and stays beneath the new tile
        /// until the move has played out.
        case absorbed
    }

    public let id: TileID
    public let value: Int
    public let position: Position
    public let kind: Kind

    public init(id: TileID, value: Int, position: Position, kind: Kind = .resting) {
        self.id = id
        self.value = value
        self.position = position
        self.kind = kind
    }
}
