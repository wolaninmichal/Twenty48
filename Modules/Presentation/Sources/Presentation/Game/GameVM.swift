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
/// Intents from the view merge into one stream, a `scan` folds them into the
/// domain's `GameSession`, and the state leaves as a `Driver`.
///
/// A move that merges tiles is drawn twice: first with the merged-away tiles
/// sliding beneath the tile they became, then, once the move has played out,
/// without them. A new intent cancels a pending second drawing.
public final class GameViewModel: ViewModel {

    public struct Input {
        public let moves: Observable<Direction>
        public let keepPlayingRequests: Observable<Void>
        public let restartRequests: Observable<Void>
        /// Intents that arrive while the screen is inactive are dropped.
        public let isActive: Observable<Bool>

        public init(
            moves: Observable<Direction>,
            keepPlayingRequests: Observable<Void>,
            restartRequests: Observable<Void>,
            isActive: Observable<Bool>
        ) {
            self.moves = moves
            self.keepPlayingRequests = keepPlayingRequests
            self.restartRequests = restartRequests
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

    /// Creates the view model.
    ///
    /// - Parameters:
    ///   - navigator: The navigator of the app.
    ///   - session: The session to start from.
    ///   - settleDelay: How long a move takes to play out on screen.
    ///   - scheduler: The scheduler that waits out `settleDelay`.
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
                input.moves.map(GameIntent.move),
                input.keepPlayingRequests.map { _ in .keepPlaying },
                input.restartRequests.map { _ in .restart }
            )
            .withLatestFrom(input.isActive) { intent, isActive in isActive ? intent : nil }
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
