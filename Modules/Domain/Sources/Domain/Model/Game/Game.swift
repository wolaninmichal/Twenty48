//
//  Game.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

/// The state of one game.
public struct Game: Equatable, Sendable {

    public enum Status: Equatable, Sendable {
        /// Moves are accepted.
        case playing
        /// The winning value appeared. Moves wait until the player goes on.
        case won
        /// No move can change the board.
        case over
    }

    public internal(set) var board: Board
    public internal(set) var score = 0
    public internal(set) var status = Status.playing

    /// Whether the player went on after winning, so a later win isn't
    /// announced again.
    public internal(set) var isEndless = false

    /// Creates a game on an empty board.
    init(boardSize: Int) {
        board = Board(size: boardSize)
    }

    /// Derives the status from the board.
    ///
    /// A win takes precedence over the end of the game, so a winning move that
    /// also fills the board is still celebrated.
    mutating func resolveStatus(against rules: GameRules) {
        if !isEndless, board.highestValue >= rules.winningValue {
            status = .won
        } else if !board.canMove {
            status = .over
        } else {
            status = .playing
        }
    }
}
