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
        private let keepPlayingRelay = PublishRelay<Void>()
        private let restartRelay = PublishRelay<Void>()

        public var moves: Observable<Direction> { moveRelay.asObservable() }
        public var keepPlayingRequests: Observable<Void> { keepPlayingRelay.asObservable() }
        public var restartRequests: Observable<Void> { restartRelay.asObservable() }

        public init(state: GameViewState = .empty(boardSize: 4)) {
            self.state = state
        }

        func apply(state: GameViewState) { self.state = state }

        func move(_ direction: Direction) { moveRelay.accept(direction) }

        func keepPlaying() { keepPlayingRelay.accept(()) }

        func restart() { restartRelay.accept(()) }
    }

    @ObservedObject private var contract: Contract

    public init(contract: Contract) {
        self.contract = contract
    }

    public var body: some View {
        let state = contract.state

        BoardView(size: state.boardSize, tiles: state.tiles)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(verbatim: "Plansza"))
            .accessibilityValue(Text(verbatim: Self.description(of: state)))
            .accessibilityAction(named: Self.actionName(.up)) { contract.move(.up) }
            .accessibilityAction(named: Self.actionName(.down)) { contract.move(.down) }
            .accessibilityAction(named: Self.actionName(.left)) { contract.move(.left) }
            .accessibilityAction(named: Self.actionName(.right)) { contract.move(.right) }
            .overlay {
                if let overlay = state.overlay {
                    message(for: overlay)
                        .buttonStyle(.plain)
                        .transition(Self.messageTransition)
                }
            }
            .padding(Theme.Spacing.medium)
            .frame(maxWidth: Theme.Size.contentMaxWidth, maxHeight: .infinity)
            .frame(maxWidth: .infinity)
            .background(Theme.Colors.surface.ignoresSafeArea())
            .contentShape(Rectangle())
            .onSwipe(perform: contract.move)
    }

    // MARK: - Sections

    @ViewBuilder
    private func message(for overlay: GameViewState.Overlay) -> some View {
        switch overlay {
        case .won:
            Button(action: contract.keepPlaying) {
                BoardMessage(title: "2048!", caption: "Dotknij, aby grać dalej")
            }
        case .over(let score):
            Button(action: contract.restart) {
                BoardMessage(title: "Koniec gry", caption: "Wynik: \(score). Dotknij, aby zagrać ponownie")
            }
        }
    }

    /// The message waits for the last move to play out, and leaves at once.
    private static var messageTransition: AnyTransition {
        .asymmetric(
            insertion: .opacity.animation(Theme.Motion.controls.delay(Theme.Motion.tileSettleDuration)),
            removal: .opacity.animation(Theme.Motion.controls)
        )
    }

    // MARK: - Accessibility

    /// The board read row by row, for VoiceOver.
    private static func description(of state: GameViewState) -> String {
        var values: [Position: Int] = [:]
        for tile in state.tiles where tile.kind != .absorbed {
            values[tile.position] = tile.value
        }

        return (0..<state.boardSize).map { row in
            (0..<state.boardSize).map { column in
                values[Position(row: row, column: column)].map { String($0) } ?? "puste"
            }
            .joined(separator: ", ")
        }
        .joined(separator: "; ")
    }

    private static func actionName(_ direction: Direction) -> Text {
        Text(verbatim: "Przesuń \(name(of: direction))")
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
    GameView(contract: .init(state: GameViewState(game: GameSession(seed: 1).game, turn: nil)))
}
