//
//  MoveResult.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Foundation

/// Two tiles that met during a move, and the tile they became.
public struct Merge: Hashable, Sendable {

    /// The cell the merge happened in. Both sources end their slide here.
    public let position: Position

    /// The two tiles that met, the one nearer the edge first.
    public let sources: [Tile]

    /// The tile the sources became, with a new identity.
    public let result: Tile
}

/// The outcome of sliding the tiles of a board.
public struct MoveResult: Equatable, Sendable {

    /// The board after the slide, before a new tile appears.
    public let board: Board

    /// The merges of the move, lane by lane.
    public let merges: [Merge]

    /// The points the move scores: the sum of the tiles it made.
    public var points: Int {
        merges.reduce(0) { $0 + $1.result.value }
    }
}
