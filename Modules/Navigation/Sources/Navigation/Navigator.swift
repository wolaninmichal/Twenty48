//
//  Navigator.swift
//  Navigation
//
//  Created by Michał Wolanin on 26/09/2026.
//

import Foundation

/// The navigation contract as seen by the presentation layer.
///
/// A view model receives a `Navigator`, never a `UINavigationController`, so
/// features stay unaware of the concrete container and remain testable.
@MainActor
public protocol Navigator: AnyObject {
    func setRoot(_ route: Route)
}
