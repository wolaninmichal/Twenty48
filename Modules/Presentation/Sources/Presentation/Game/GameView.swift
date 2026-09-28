//
//  GameView.swift
//  Presentation
//
//  Created by Michał Wolanin on 26/09/2026.
//

import DesignSystem
import Domain
import RxRelay
import RxSwift
import SwiftUI

public struct GameView: View {

    /// The seam between SwiftUI and Rx.
    ///
    /// State goes in through `apply`, called by the view controller; intents
    /// come out through relays, observed by the view model. The view never
    /// sees an observable and the view model never sees a view.
    public final class Contract: ObservableObject {

        // MARK: - Output

        @Published public private(set) var state: GameViewState

        // MARK: - Input

        private let moveRelay = PublishRelay<Direction>()

        public var moves: Observable<Direction> { moveRelay.asObservable() }

        public init(state: GameViewState = .empty(boardSize: 4)) {
            self.state = state
        }

        func apply(state: GameViewState) { self.state = state }

        func move(_ direction: Direction) { moveRelay.accept(direction) }
    }

    @ObservedObject private var contract: Contract

    public init(contract: Contract) {
        self.contract = contract
    }

    public var body: some View {
        let state = contract.state

        VStack(spacing: Theme.Spacing.large) {
            header(state)
            hint(state)
            BoardView(size: state.boardSize)
                .layoutPriority(1)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, Theme.Spacing.medium)
        .padding(.top, Theme.Spacing.large)
        .frame(maxWidth: Theme.Size.contentMaxWidth, maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .background(Theme.Colors.surface.ignoresSafeArea())
        .contentShape(Rectangle())
        .onSwipe(perform: contract.move)
    }

    // MARK: - Sections

    private func header(_ state: GameViewState) -> some View {
        HStack(alignment: .center, spacing: Theme.Spacing.small) {
            Text(verbatim: "2048")
                .font(Theme.Typography.title)
                .foregroundStyle(Theme.Colors.onSurface)
                .accessibilityAddTraits(.isHeader)

            Spacer(minLength: Theme.Spacing.small)

            ScoreBadge(title: "Wynik", value: state.score)
            ScoreBadge(title: "Rekord", value: state.bestScore)
        }
    }

    private func hint(_ state: GameViewState) -> some View {
        Text(verbatim: Self.description(of: state))
            .font(Theme.Typography.label)
            .foregroundStyle(Theme.Colors.onSurfaceMuted)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private static func description(of state: GameViewState) -> String {
        guard let lastMove = state.lastMove else {
            return "Przesuń palcem w dowolną stronę."
        }
        return "Ruch \(state.moveCount): \(name(of: lastMove))."
    }

    private static func name(of direction: Direction) -> String {
        switch direction {
        case .up: "w górę"
        case .down: "w dół"
        case .left: "w lewo"
        case .right: "w prawo"
        }
    }
}

#Preview {
    GameView(contract: .init())
}
