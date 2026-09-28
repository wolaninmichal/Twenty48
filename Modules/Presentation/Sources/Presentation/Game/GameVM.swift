//
//  GameVM.swift
//  Presentation
//
//  Created by Michał Wolanin on 26/09/2026.
//

import Domain
import Foundation
import Navigation
import RxCocoa
import RxSwift

/// The game screen's view model.
///
/// The shape is the finished one: inputs merge into a stream of intents, a
/// `scan` folds them into state, the state leaves as a `Driver`. Only the
/// accumulator is a stand-in — it gives way to the domain's session reducer,
/// and nothing around it has to move when it does.
public final class GameViewModel: ViewModel {

    public struct Input {
        public let moves: Observable<Direction>
        public let isActive: Observable<Bool>

        public init(moves: Observable<Direction>, isActive: Observable<Bool>) {
            self.moves = moves
            self.isActive = isActive
        }
    }

    public struct Output {
        public let state: Driver<GameViewState>
    }

    /// Held for routes beyond this screen; the game itself never navigates.
    private let navigator: any Navigator
    private let boardSize: Int

    public init(navigator: any Navigator, boardSize: Int = 4) {
        self.navigator = navigator
        self.boardSize = boardSize
    }

    public func transform(_ input: Input) -> Output {
        let initial = GameViewState.empty(boardSize: boardSize)

        let state = input.moves
            .scan(into: initial) { state, direction in
                state.moveCount += 1
                state.lastMove = direction
            }
            .startWith(initial)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())

        return Output(state: state)
    }
}
