//
//  BoardMessage.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 28/09/2026.
//

import SwiftUI

/// A message covering the board, such as the end of a game.
///
/// The view fills the frame it is given; lay it over the board with
/// `overlay`.
public struct BoardMessage: View {

    private let title: String
    private let caption: String

    /// Creates a board message.
    ///
    /// - Parameters:
    ///   - title: The message itself.
    ///   - caption: What the player can do next.
    public init(title: String, caption: String) {
        self.title = title
        self.caption = caption
    }

    public var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            Text(verbatim: title)
                .font(Theme.Typography.title)
                .foregroundStyle(Theme.Colors.onSurface)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Text(verbatim: caption)
                .font(Theme.Typography.label)
                .foregroundStyle(Theme.Colors.onSurfaceMuted)
        }
        .multilineTextAlignment(.center)
        .padding(Theme.Spacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Theme.Colors.boardOverlay,
            in: RoundedRectangle(cornerRadius: Theme.Radius.control, style: .continuous)
        )
        .contentShape(RoundedRectangle(cornerRadius: Theme.Radius.control, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    BoardView(size: 4)
        .overlay { BoardMessage(title: "Koniec gry", caption: "Dotknij, aby zagrać ponownie") }
        .padding(Theme.Spacing.medium)
        .background(Theme.Colors.surface)
}
