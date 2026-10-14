//
//  Direction.swift
//  Domain
//
//  Created by Michał Wolanin on 25/09/2026.
//

import Foundation

/// The four ways a move can go.
///
/// Screen-oriented, like `Position`: `.down` is towards the last row. Nothing
/// else is needed to map a swipe or an arrow key onto the board.
public enum Direction: String, CaseIterable, Sendable, Codable {
    case up, right, down, left
}
