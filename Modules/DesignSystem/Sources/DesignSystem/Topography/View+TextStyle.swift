//
//  File.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 14/10/2026.
//

import SwiftUI

public extension View {

    /// Styles the text in this view for a role.
    ///
    /// Applied to a container, the style reaches every text inside it, as
    /// `font` does.
    ///
    /// - Parameters:
    ///   - style: The role the text plays.
    ///   - color: A color to use instead of the role's, such as the content
    ///     color of the surface the text sits on.
    /// - Returns: A view whose text is styled for the role.
    func textStyle(_ style: Theme.TextStyle, color: Color? = nil) -> some View {
        font(style.font)
            .foregroundStyle(color ?? style.color)
            .lineLimit(style.lineLimit)
            .minimumScaleFactor(style.minimumScaleFactor)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Theme.Spacing.small) {
        ForEach(Theme.TextStyle.allCases, id: \.self) { style in
            Text(verbatim: "\(style)").textStyle(style)
        }
    }
    .padding(Theme.Spacing.large)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Theme.Colors.surface)
}
