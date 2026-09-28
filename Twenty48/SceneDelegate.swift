//
//  SceneDelegate.swift
//  Twenty48
//
//  Created by Michał Wolanin on 25/09/2026.
//

import Navigation
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private var navigator: AppNavigator?
    private var compositionRoot: CompositionRoot?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let navigationController: UINavigationController = .init()
        navigationController.setNavigationBarHidden(true, animated: false)

        let compositionRoot: CompositionRoot = .init()
        let navigator: AppNavigator = .init(
            navigationController: navigationController,
            screenFactory: compositionRoot
        )
        compositionRoot.navigator = navigator

        self.compositionRoot = compositionRoot
        self.navigator = navigator

        let window: UIWindow = .init(windowScene: windowScene)
        window.rootViewController = navigationController
        window.overrideUserInterfaceStyle = .dark
        self.window = window

        navigator.setRoot(.game)
        window.makeKeyAndVisible()
    }
}
