//
//  ScreenFactory.swift
//  Navigation
//
//  Created by Michał Wolanin on 26/09/2026.
//

import UIKit

/// Builds view controllers for routes.
///
/// This is the dependency inversion the navigation layer rests on: Navigation
/// declares the protocol but has no idea how a screen is made. The composition
/// root in the app target implements it, because it is the only place that sees
/// every module.
@MainActor
public protocol ScreenFactory: AnyObject {
    func makeViewController(for route: Route) -> UIViewController
}
