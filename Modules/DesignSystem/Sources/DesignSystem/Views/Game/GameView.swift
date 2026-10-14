//
//  File.swift
//  DesignSystem
//
//  Created by Michał Wolanin on 09/10/2026.
//

import Domain
import SwiftUI

/// The game view: the board, centred, with a message over it when the game
/// pauses.
public struct GameView: ScreenView {

    public typealias State = GameViewState
    public typealias Action = GameViewAction

    private let state: GameViewState
    private let send: (GameViewAction) -> Void

    public init(state: GameViewState, send: @escaping (GameViewAction) -> Void) {
        self.state = state
        self.send = send
    }

    public var body: some View {
        BoardView(size: state.boardSize, tiles: state.tiles)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(verbatim: "Plansza"))
            .accessibilityValue(Text(verbatim: Self.description(of: state)))
            .accessibilityAction(named: Self.actionName(.up)) { send(.move(.up)) }
            .accessibilityAction(named: Self.actionName(.down)) { send(.move(.down)) }
            .accessibilityAction(named: Self.actionName(.left)) { send(.move(.left)) }
            .accessibilityAction(named: Self.actionName(.right)) { send(.move(.right)) }
            .overlay {
                if let message = state.message {
                    button(for: message)
                        .buttonStyle(.plain)
                        .transition(Self.messageTransition)
                }
            }
            .padding(Theme.Spacing.medium)
            .frame(maxWidth: Theme.Size.contentMaxWidth, maxHeight: .infinity)
            .frame(maxWidth: .infinity)
            .background(Theme.Colors.surface.ignoresSafeArea())
            .contentShape(Rectangle())
            .onSwipe { send(.move($0)) }
    }

    // MARK: - Sections

    @ViewBuilder
    private func button(for message: GameViewState.Message) -> some View {
        switch message {
        case .won:
            Button { send(.keepPlaying) } label: {
                BoardMessage(title: "2048!", caption: "Dotknij, aby grać dalej")
            }
        case .over(let score):
            Button { send(.restart) } label: {
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
        let name = switch direction {
        case .up: "w górę"
        case .down: "w dół"
        case .left: "w lewo"
        case .right: "w prawo"
        }
        return Text(verbatim: "Przesuń \(name)")
    }
}

#Preview("Wygrana") {
    GameView(state: GameViewState(boardSize: 4, message: .won), send: { _ in })
}

#Preview("Koniec gry") {
    GameView(state: GameViewState(boardSize: 4, message: .over(score: 1234)), send: { _ in })
}
