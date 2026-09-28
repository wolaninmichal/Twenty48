//
//  TileView.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 28/09/2026.
//

import SwiftUI

/// A numbered tile filling the frame it is given.
struct TileView: View {

    let value: Int

    var body: some View {
        RoundedRectangle(cornerRadius: Theme.Board.tileRadius, style: .continuous)
            .fill(Theme.Colors.tile(value))
            .overlay {
                Text(verbatim: String(value))
                    .font(Theme.Typography.tile)
                    .foregroundStyle(Theme.Colors.onTile(value))
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .padding(Theme.Spacing.xSmall)
            }
    }
}

extension BoardTile.Kind {

    /// Tiles that merged away stay beneath everything else.
    var zIndex: Double {
        self == .absorbed ? 1 : 2
    }

    var transition: AnyTransition {
        switch self {
        case .resting:
            .opacity
        case .spawned:
            .asymmetric(insertion: .appear(Theme.Motion.tileAppear), removal: .opacity)
        case .merged:
            .asymmetric(insertion: .appear(Theme.Motion.tileMerge), removal: .opacity)
        case .absorbed:
            .asymmetric(insertion: .identity, removal: .opacity.animation(Theme.Motion.tileVanish))
        }
    }
}

private extension AnyTransition {

    /// A tile growing out of the middle of its cell once the tiles around it
    /// have finished sliding. Invisible while it waits.
    static func appear(_ animation: Animation) -> AnyTransition {
        AnyTransition.scale(scale: 0.1)
            .combined(with: .opacity)
            .animation(animation.delay(Theme.Motion.tileSlideDuration))
    }
}
