//
//  File.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 14/10/2026.
//

import SwiftUI

extension Theme {

    /// The role a piece of text plays, which sets its font, its color and how
    /// it fits the space it is given.
    ///
    /// Text is styled only through a role, so every view of the app draws its
    /// text from the same small set of fonts:
    ///
    ///     Text(verbatim: "Koniec gry").textStyle(.title)
    public enum TextStyle: CaseIterable, Sendable {
        /// The name of a screen, or the message over the board.
        case title
        /// The heading of a panel.
        case headline
        /// A number that changes, such as the score.
        case score
        /// The value of a tile. Shrinks to fit its cell.
        case tile
        /// The title of a button.
        case button
        /// Supporting text.
        case label
        /// The smallest text, such as the label of a badge.
        case caption

        /// The font of the role.
        var font: Font {
            switch self {
            case .title: .system(size: 44, weight: .heavy, design: .rounded)
            case .headline: .system(.title2, design: .rounded).weight(.bold)
            case .score: .system(.title3, design: .rounded).weight(.bold).monospacedDigit()
            case .tile: .system(size: 34, weight: .heavy, design: .rounded)
            case .button: .system(.body, design: .rounded).weight(.semibold)
            case .label: .system(.footnote, design: .rounded)
            case .caption: .system(.caption, design: .rounded)
            }
        }

        /// The color the role takes on the surface, unless a view says
        /// otherwise.
        var color: Color {
            switch self {
            case .title, .headline, .score, .tile, .button: Colors.onSurface
            case .label, .caption: Colors.onSurfaceMuted
            }
        }

        /// The most lines the text may take, or `nil` for no limit.
        var lineLimit: Int? {
            switch self {
            case .title, .score, .tile: 1
            case .headline, .button, .label, .caption: nil
            }
        }

        /// How far the text may shrink to fit, from 0 to 1.
        var minimumScaleFactor: CGFloat {
            switch self {
            case .title: 0.5
            case .tile: 0.3
            case .headline, .score, .button, .label, .caption: 1
            }
        }
    }
}
