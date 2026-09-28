//
//  File.swift
//  Navigation
//
//  Created by Michał Wolanin on 26/09/2026.
//

import UIKit

/// A navigator backed by `UINavigationController` — the UIKit core of the app.
@MainActor
public final class AppNavigator: Navigator {

    /// Weak: the window owns the navigation controller.
    private weak var navigationController: UINavigationController?

    /// Strong: the composition root has no other owner.
    private let screenFactory: ScreenFactory

    public init(
        navigationController: UINavigationController,
        screenFactory: ScreenFactory
    ) {
        self.navigationController = navigationController
        self.screenFactory = screenFactory
    }

    public func setRoot(_ route: Route) {
        let viewController = screenFactory.makeViewController(for: route)
        navigationController?.setViewControllers([viewController], animated: false)
    }
}
