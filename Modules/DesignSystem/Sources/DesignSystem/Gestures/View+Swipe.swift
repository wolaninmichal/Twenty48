//
//  View+Swipe.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 26/09/2026.
//

import Domain
import SwiftUI

public extension View {

    /// Adds an action to perform when the user swipes across this view.
    ///
    /// The direction is the dominant axis of the gesture's total translation,
    /// measured when the gesture ends. One gesture reports at most one
    /// direction.
    ///
    /// - Parameters:
    ///   - minimumDistance: The distance the drag must cover before the
    ///     gesture begins. Shorter drags, including taps, reach the views
    ///     below unchanged.
    ///   - action: The action to perform, given the direction of the swipe.
    /// - Returns: A view that reports swipes.
    func onSwipe(
        minimumDistance: CGFloat = 24,
        perform action: @escaping (Direction) -> Void
    ) -> some View {
        gesture(
            DragGesture(minimumDistance: minimumDistance)
                .onEnded { value in
                    guard let direction = Direction(swipe: value.translation, threshold: minimumDistance) else {
                        return
                    }
                    action(direction)
                }
        )
    }
}

extension Direction {

    /// Creates the direction a swipe points in.
    ///
    /// - Parameters:
    ///   - translation: The distance from the start of a drag to its end.
    ///   - threshold: The shortest translation that counts as a swipe.
    /// - Returns: `nil` if the translation is shorter than the threshold, as
    ///   when a drag returns to where it began.
    init?(swipe translation: CGSize, threshold: CGFloat) {
        let horizontal = abs(translation.width)
        let vertical = abs(translation.height)
        guard max(horizontal, vertical) >= threshold else { return nil }

        if horizontal > vertical {
            self = translation.width > 0 ? .right : .left
        } else {
            self = translation.height > 0 ? .down : .up
        }
    }
}
