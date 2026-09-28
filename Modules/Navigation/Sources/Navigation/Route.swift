//
//  Route.swift
//  Navigation
//
//  Created by Michał Wolanin on 26/09/2026.
//

import Foundation

/// Navigation destinations.
///
/// The enum lives here rather than in the screens, so this module depends on no
/// feature and no cycle can appear in the package graph.
public enum Route: Equatable, Hashable {
    case game
}
