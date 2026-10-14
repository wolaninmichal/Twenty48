//
//  GameVM.swift
//  Presentation
//
//  Created by Michał Wolanin on 26/09/2026.
//

import DesignSystem
import Domain
import Foundation
import Navigation
import RxCocoa
import RxSwift

/// The game screen's view model.
///
/// Intents fold into a `GameSession`; each result leaves as a
/// `GameViewState`. A move that merges tiles is drawn twice: first with the
/// merged-away tiles beneath the tile they became, then, once the move has
/// played out, without them.
public final class GameViewModel: ViewModel {

    public struct Input {
        /// A swipe, in the direction it points.
        public let moves: Signal<Direction>
        /// A decision taken while the game is paused.
        public let flowActions: Signal<GameFlowAction>
        /// Intents that arrive while the screen is inactive are dropped.
        public let isActive: Driver<Bool>

        public init(
            moves: Signal<Direction>,
            flowActions: Signal<GameFlowAction>,
            isActive: Driver<Bool>
        ) {
            self.moves = moves
            self.flowActions = flowActions
            self.isActive = isActive
        }
    }

    public struct Output {
        public let state: Driver<GameViewState>
    }

    /// Held for routes beyond this screen; the game itself never navigates.
    private let navigator: any Navigator
    private let session: GameSession
    private let settleDelay: RxTimeInterval
    private let scheduler: any SchedulerType

    public init(
        navigator: any Navigator,
        session: GameSession = GameSession(seed: .random(in: .min ... .max)),
        settleDelay: RxTimeInterval = .milliseconds(Int(Theme.Motion.tileSettleDuration * 1_000)),
        scheduler: any SchedulerType = MainScheduler.instance
    ) {
        self.navigator = navigator
        self.session = session
        self.settleDelay = settleDelay
        self.scheduler = scheduler
    }

    public func transform(_ input: Input) -> Output {
        let initial = Frame(session: session, turn: nil)
        let settleDelay = settleDelay
        let scheduler = scheduler

        let intents = Observable<GameIntent>
            .merge(
                input.moves.asObservable().map(GameIntent.move),
                input.flowActions.asObservable().map { GameIntent($0) }
            )
            .withLatestFrom(input.isActive.asObservable()) { intent, isActive in isActive ? intent : nil }
            .compactMap { $0 }

        let state = intents
            .scan(into: initial) { frame, intent in
                frame.turn = frame.session.apply(intent)
            }
            .startWith(initial)
            .flatMapLatest { frame -> Observable<Frame> in
                guard frame.needsSettling else { return .just(frame) }
                return Observable.just(frame.settled)
                    .delay(settleDelay, scheduler: scheduler)
                    .startWith(frame)
            }
            .map { GameViewState(game: $0.session.game, turn: $0.turn) }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())

        return Output(state: state)
    }
}

private extension GameViewModel {

    /// The session together with what its last intent did.
    struct Frame {
        var session: GameSession
        var turn: Turn?

        /// Whether the frame draws tiles that must go once the move has
        /// played out.
        var needsSettling: Bool {
            turn.map { !$0.merges.isEmpty } ?? false
        }

        /// The same frame, drawn as if the move had played out.
        var settled: Frame {
            Frame(session: session, turn: nil)
        }
    }
}

private extension GameIntent {

    init(_ action: GameFlowAction) {
        switch action {
        case .keepPlaying: self = .keepPlaying
        case .restart: self = .restart
        }
    }
}
