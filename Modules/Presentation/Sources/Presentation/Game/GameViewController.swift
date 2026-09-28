//
//  File.swift
//  Presentation
//
//  Created by Michał Wolanin on 26/09/2026.
//

import RxCocoa
import RxSwift
import UIKit

public final class GameViewController:
    ScreenViewController<GameViewModel, GameView> {

    private let contract: GameView.Contract

    public init(viewModel: GameViewModel) {
        let contract = GameView.Contract()
        self.contract = contract
        super.init(
            viewModel: viewModel,
            title: "2048",
            rootView: GameView(contract: contract)
        )
    }

    public override func bindViewModel() {
        let input = GameViewModel.Input(
            moves: contract.moves,
            keepPlayingRequests: contract.keepPlayingRequests,
            restartRequests: contract.restartRequests,
            isActive: isActive.asObservable()
        )

        viewModel.transform(input).state
            .drive(with: contract) { contract, state in
                contract.apply(state: state)
            }
            .disposed(by: disposeBag)
    }
}
