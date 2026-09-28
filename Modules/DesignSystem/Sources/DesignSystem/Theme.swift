//
//  Theme.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 26/09/2026.
//

import SwiftUI

/// The visual constants the app is drawn with.
public enum Theme {

    /// Colors, named for the role they play rather than the shade they are.
    ///
    /// A color named `onSomething` is legible against `something`.
    public enum Colors {
        /// The background of a screen.
        public static let surface = Color(white: 0.07)
        /// The background of a panel or control resting on the surface.
        public static let surfaceRaised = Color(white: 0.13)
        /// The background of the board.
        public static let board = Color(white: 0.11)
        /// The fill of a cell with no tile in it.
        public static let emptyCell = Color.white.opacity(0.05)

        /// Primary content on the surface.
        public static let onSurface = Color.white
        /// Secondary content, such as a caption.
        public static let onSurfaceMuted = Color.white.opacity(0.6)
        /// Content of a disabled control.
        public static let onSurfaceDisabled = Color.white.opacity(0.3)

        /// The tint of interactive elements.
        public static let accent = Color(red: 0.35, green: 0.72, blue: 1.0)
        /// Content on top of `accent`.
        public static let onAccent = Color(white: 0.07)

        /// The wash that dims content behind a modal.
        public static let scrim = Color.black.opacity(Theme.Opacity.scrim)
        /// The wash over the board while it shows a message.
        public static let boardOverlay = Color.black.opacity(Theme.Opacity.boardOverlay)

        /// The fill of a tile holding a value.
        ///
        /// Values past the palette share the accent, so a tile never goes
        /// without a color however long the game runs.
        public static func tile(_ value: Int) -> Color {
            tilePalette[value] ?? accent
        }

        /// Content on top of `tile(_:)`.
        public static func onTile(_ value: Int) -> Color {
            guard tilePalette[value] != nil else { return onAccent }
            return value <= 4 ? rgb(0x776E65) : .white
        }

        private static let tilePalette: [Int: Color] = [
            2: rgb(0xEEE4DA),
            4: rgb(0xEDE0C8),
            8: rgb(0xF2B179),
            16: rgb(0xF59563),
            32: rgb(0xF67C5F),
            64: rgb(0xF65E3B),
            128: rgb(0xEDCF72),
            256: rgb(0xEDCC61),
            512: rgb(0xEDC850),
            1024: rgb(0xEDC53F),
            2048: rgb(0xEDC22E),
        ]

        private static func rgb(_ hex: UInt32) -> Color {
            Color(
                red: Double((hex >> 16) & 0xFF) / 255,
                green: Double((hex >> 8) & 0xFF) / 255,
                blue: Double(hex & 0xFF) / 255
            )
        }
    }

    /// Text styles.
    public enum Typography {
        /// The name of the screen.
        public static let title = Font.system(size: 44, weight: .heavy, design: .rounded)
        /// The heading of a panel.
        public static let headline = Font.system(.title2, design: .rounded).weight(.bold)
        /// A number that changes, such as the score.
        public static let score = Font.system(.title3, design: .rounded).weight(.bold).monospacedDigit()
        /// The value of a tile. Shrinks to fit its cell.
        public static let tile = Font.system(size: 34, weight: .heavy, design: .rounded)
        /// The title of a button.
        public static let button = Font.system(.body, design: .rounded).weight(.semibold)
        /// Supporting text.
        public static let label = Font.system(.footnote, design: .rounded)
        /// The smallest text, such as the label of a badge.
        public static let caption = Font.system(.caption, design: .rounded)
    }

    /// Distances between elements, in points.
    public enum Spacing {
        /// 4 points.
        public static let xSmall: CGFloat = 4
        /// 8 points.
        public static let small: CGFloat = 8
        /// 16 points.
        public static let medium: CGFloat = 16
        /// 24 points.
        public static let large: CGFloat = 24
        /// 32 points.
        public static let xLarge: CGFloat = 32
        /// 64 points.
        public static let xxLarge: CGFloat = 64
    }

    /// Corner radii, in points.
    public enum Radius {
        /// 8 points.
        public static let small: CGFloat = 8
        /// 12 points. The default for panels and controls.
        public static let control: CGFloat = 12
        /// 20 points.
        public static let large: CGFloat = 20
    }

    /// Element sizes, in points.
    public enum Size {
        /// 44 points. The smallest edge a control may have.
        public static let control: CGFloat = 44
        /// 520 points. The widest the content grows on a large screen.
        public static let contentMaxWidth: CGFloat = 520
    }

    /// Measurements of the board, in points.
    public enum Board {
        /// 8 points. The gutter between cells, and between a cell and the edge.
        public static let spacing: CGFloat = 8
        /// 8 points.
        public static let tileRadius: CGFloat = 8
    }

    /// Animations.
    public enum Motion {
        /// The duration of a tile's slide, in seconds.
        ///
        /// Tiles that appear during a move are delayed by this much, so the
        /// duration is a token of its own rather than a number inside
        /// `tileSlide`.
        public static let tileSlideDuration: Double = 0.12
        /// A tile moving to another cell.
        public static let tileSlide = Animation.easeOut(duration: tileSlideDuration)
        /// A new tile growing into its cell, once the others have slid.
        public static let tileAppear = Animation.easeOut(duration: 0.15)
        /// A merged tile popping into its cell, overshooting slightly.
        public static let tileMerge = Animation.spring(response: 0.2, dampingFraction: 0.6)
        /// A tile that merged away leaving the board.
        public static let tileVanish = Animation.linear(duration: 0.06)
        /// The time a move takes to play out, from the start of the slide to
        /// the end of the merge, in seconds.
        public static let tileSettleDuration: Double = tileSlideDuration + 0.3

        /// A control appearing or disappearing.
        public static let controls = Animation.easeInOut(duration: 0.2)
        /// A control responding to a touch.
        public static let press = Animation.easeOut(duration: 0.12)
        /// A number counting to a new value.
        public static let score = Animation.easeOut(duration: 0.25)
    }

    /// Opacities.
    public enum Opacity {
        /// The scrim behind a modal.
        public static let scrim: Double = 0.45
        /// The wash over the board while it shows a message.
        public static let boardOverlay: Double = 0.6
    }
}
