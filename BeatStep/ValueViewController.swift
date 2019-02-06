//
// Created by Nick Teissler on 2/2/19
// Copyright © 2019 Nick Teissler. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

class ValueViewController<T>: UIViewController {
    let output: Observable<[T]>

    init<C: ValueControlling>(controls: [C]) where C.Value == T {
        output = Observable.combineLatest(controls.map { $0.output })
        super.init(nibName: nil, bundle: nil)
        controls.forEach { addChild($0) }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = UIView()
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
        ])
        children.forEach { viewController in
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(viewController.view)
        }
    }
}
