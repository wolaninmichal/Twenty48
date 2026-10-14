//
//  File.swift
//  Presentation
//
//  Created by Michał Wolanin on 26/09/2026.
//

import DesignSystem
import Domain
import RxCocoa
import RxSwift

/// The game screen: binds `GameViewModel` to `GameView`.
public final class GameViewController: SwiftUIViewController<GameView> {

    private let vm: GameViewModel

    public init(vm: GameViewModel) {
        self.vm = vm
        super.init()
    }

    public override func bindVM() {
        let output = vm.transform(.init(
            moves: actions.compactMap(\.move),
            flowActions: actions.compactMap(\.flowAction),
            isActive: isActive
        ))

        output.state
            .drive(state)
            .disposed(by: disposeBag)
    }
}

private extension GameViewAction {

    var move: Direction? {
        if case .move(let direction) = self { direction } else { nil }
    }

    var flowAction: GameFlowAction? {
        switch self {
        case .move: nil
        case .keepPlaying: .keepPlaying
        case .restart: .restart
        }
    }
}
