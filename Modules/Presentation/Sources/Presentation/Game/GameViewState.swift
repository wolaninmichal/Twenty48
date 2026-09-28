//
//  File.swift
//  Presentation
//
//  Created by Michał Wolanin on 26/09/2026.
//

import Domain
import Foundation

/// One snapshot of everything the game screen draws.
///
/// A single `Equatable` value rather than a handful of `@Published`
/// properties: the view can never be caught between two publishes, and the
/// whole screen is reproducible from one value in a preview or a test.
public struct GameViewState: Equatable, Sendable {

    public var boardSize: Int
    public var score: Int
    public var bestScore: Int
    /// Placeholders until the engine lands: proof that a gesture reaches the
    /// view model and that state comes back.
    public var moveCount: Int
    public var lastMove: Direction?

    public static func empty(boardSize: Int) -> GameViewState {
        GameViewState(boardSize: boardSize, score: 0, bestScore: 0, moveCount: 0, lastMove: nil)
    }
}
