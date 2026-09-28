//
//  GameIntent.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Foundation

/// Something the player asks the game to do.
public enum GameIntent: Hashable, Sendable {
    /// Slide the tiles in a direction.
    case move(Direction)
    /// Go on after winning.
    case keepPlaying
    /// Throw the game away and start a new one.
    case restart
}
