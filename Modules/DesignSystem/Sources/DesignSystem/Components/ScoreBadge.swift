//
//  ScoreBadge.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 26/09/2026.
//

import SwiftUI

/// A view that displays a labeled number, such as the current score.
///
/// A change of value animates digit by digit.
public struct ScoreBadge: View {

    private let title: String
    private let value: Int

    /// Creates a score badge.
    ///
    /// - Parameters:
    ///   - title: The label shown above the number.
    ///   - value: The number to display.
    public init(title: String, value: Int) {
        self.title = title
        self.value = value
    }

    public var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.Colors.onSurfaceMuted)

            // Verbatim, so the digits carry no grouping separator.
            Text(verbatim: String(value))
                .font(Theme.Typography.score)
                .foregroundStyle(Theme.Colors.onSurface)
                .contentTransition(.numericText())
                .animation(Theme.Motion.score, value: value)
        }
        .frame(minWidth: 76)
        .padding(.horizontal, Theme.Spacing.medium)
        .padding(.vertical, Theme.Spacing.small)
        .background(
            Theme.Colors.surfaceRaised,
            in: RoundedRectangle(cornerRadius: Theme.Radius.control, style: .continuous)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue(String(value))
    }
}

#Preview {
    HStack {
        ScoreBadge(title: "Wynik", value: 1_024)
        ScoreBadge(title: "Rekord", value: 20_480)
    }
    .padding(Theme.Spacing.large)
    .background(Theme.Colors.surface)
}
