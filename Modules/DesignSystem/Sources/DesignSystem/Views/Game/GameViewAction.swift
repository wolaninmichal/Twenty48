//
//  File.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 09/10/2026.
//

import Domain

/// What the user does on the game view.
public enum GameViewAction: Equatable, Sendable {
    case move(Direction)
    case keepPlaying
    case restart
}
