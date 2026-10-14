//
//  File.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 09/10/2026.
//

/// Everything the game view draws.
///
/// A single `Equatable` value: the view can never be caught between two
/// updates, and the whole screen is reproducible from one value in a preview
/// or a test.
public struct GameViewState: Equatable, Sendable {

    /// A message covering the board.
    public enum Message: Equatable, Sendable {
        case won
        case over(score: Int)
    }

    public var boardSize: Int
    public var tiles: [BoardTile]
    public var message: Message?

    public init(boardSize: Int, tiles: [BoardTile] = [], message: Message? = nil) {
        self.boardSize = boardSize
        self.tiles = tiles
        self.message = message
    }
}
