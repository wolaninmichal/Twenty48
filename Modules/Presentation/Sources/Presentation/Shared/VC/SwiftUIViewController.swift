//
//  SwiftUIViewController.swift
//  Presentation
//
//  Created by Michał Wolanin on 10/10/2026.
//

import DesignSystem
import RxCocoa
import RxRelay
import RxSwift
import SwiftUI
import UIKit

/// A view controller that hosts a `ScreenView`.
///
/// The hosting controller and the bridge between SwiftUI and Rx stay inside.
/// A subclass reads `actions` and `isActive`, and drives `state`.
open class SwiftUIViewController<Content: ScreenView>: UIViewController {

    public let disposeBag = DisposeBag()

    /// What the user does on the screen.
    public var actions: Signal<Content.Action> {
        store.actions.asSignal()
    }

    /// What the screen draws. Drive it from the view model's output.
    public var state: Binder<Content.State> {
        Binder(store) { store, state in store.state = state }
    }

    /// Whether the screen is visible.
    public var isActive: Driver<Bool> {
        activeRelay.asDriver()
    }

    private let store = ScreenStore<Content.State, Content.Action>()
    private let activeRelay = BehaviorRelay(value: false)

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Connects the view model. Called once, after the view loads.
    open func bindVM() {}

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(Theme.Colors.surface)
        overrideUserInterfaceStyle = .dark
        embedScreen()
        bindVM()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activeRelay.accept(true)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activeRelay.accept(false)
    }

    private func embedScreen() {
        let host = UIHostingController(rootView: ScreenHostView<Content>(store: store))
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(host)
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        host.didMove(toParent: self)
    }
}

/// The state and actions a controller shares with the screen it hosts.
private final class ScreenStore<State, Action>: ObservableObject {
    @Published var state: State?
    let actions = PublishRelay<Action>()
}

/// Draws the screen once there is a state to draw.
///
/// The first state arrives synchronously in `viewDidLoad`, so the empty
/// branch is never on screen.
private struct ScreenHostView<Content: ScreenView>: View {
    @ObservedObject var store: ScreenStore<Content.State, Content.Action>

    var body: some View {
        if let state = store.state {
            Content(state: state) { store.actions.accept($0) }
        }
    }
}
