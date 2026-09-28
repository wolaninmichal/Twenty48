//
//  CompositionRoot.swift
//  Twenty48
//
//  Created by Michał Wolanin on 26/09/2026.
//

import Navigation
import Presentation
import UIKit

@MainActor
final class CompositionRoot: ScreenFactory {
    weak var navigator: Navigator?

    func makeViewController(for route: Route) -> UIViewController {
        switch route {
        case .game:
            return makeGame()
        }
    }

    private func makeGame() -> UIViewController {
        guard let navigator else {
            preconditionFailure("CompositionRoot used before its navigator was set")
        }
        
        let vm: GameViewModel = .init(navigator: navigator)
        let vc: GameViewController = .init(viewModel: vm)
        
        return vc
    }
}
