//
//  File.swift
//  Presentation
//
//  Created by Michał Wolanin on 26/09/2026.
//

import DesignSystem
import RxSwift
import RxCocoa
import SwiftUI
import UIKit

open class ScreenViewController<ViewModelType: ViewModel, Content: View>: UIHostingController<Content> {
    public let viewModel: ViewModelType
    public let disposeBag: DisposeBag = .init()

    public let isActive: BehaviorRelay<Bool> = .init(value: false)

    public init(
        viewModel: ViewModelType,
        title: String?,
        rootView: Content
    ) {
        self.viewModel = viewModel
        super.init(rootView: rootView)
        self.title = title
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func bindViewModel() {}

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(Theme.Colors.surface)
        overrideUserInterfaceStyle = .dark
        bindViewModel()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isActive.accept(true)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isActive.accept(false)
    }
}
