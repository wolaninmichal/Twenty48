//
//  GameRules.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Foundation

/// The parameters a game is played by.
public struct GameRules: Equatable, Sendable {

    /// The number of cells along each edge of the board.
    public let boardSize: Int

    /// The value whose first appearance wins the game.
    public let winningValue: Int

    /// The number of tiles on the board when a game starts.
    public let startingTileCount: Int

    /// The chance, from 0 to 1, that a new tile is a 4 rather than a 2.
    public let fourProbability: Double

    public init(
        boardSize: Int = 4,
        winningValue: Int = 2048,
        startingTileCount: Int = 2,
        fourProbability: Double = 0.1
    ) {
        precondition(boardSize >= 2, "A board needs at least two cells along each edge")
        precondition(winningValue > 4, "The winning value must exceed the values tiles start with")
        precondition((1...boardSize * boardSize).contains(startingTileCount), "The starting tiles must fit the board")
        precondition((0...1).contains(fourProbability), "A probability lies between 0 and 1")

        self.boardSize = boardSize
        self.winningValue = winningValue
        self.startingTileCount = startingTileCount
        self.fourProbability = fourProbability
    }

    /// The rules of the original game.
    public static let classic = GameRules()
}
