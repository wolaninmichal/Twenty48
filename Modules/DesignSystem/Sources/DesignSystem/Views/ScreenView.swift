//
//  File.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 09/10/2026.
//

import SwiftUI

/// A screen drawn entirely from one state, reporting what the user does as
/// actions.
///
/// The screen holds no state of its own and knows nothing about where its
/// state comes from or where its actions go.
public protocol ScreenView: View {
    associatedtype State
    associatedtype Action

    init(state: State, send: @escaping (Action) -> Void)
}
