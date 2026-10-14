//
//  GameFlowAction.swift
//  Presentation
//
//  Created by Michał Wolanin on 10/10/2026.
//

import Foundation

/// What the player decides when the game pauses.
public enum GameFlowAction: Equatable, Sendable {
    /// Go on after winning.
    case keepPlaying
    /// Start a new game.
    case restart
}
