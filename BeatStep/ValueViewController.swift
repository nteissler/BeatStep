//
// Created by Nick Teissler on 2/2/19
// Copyright © 2019 Nick Teissler. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

class ValueViewController<T>: UIViewController {
    let output: Observable<T>

    init<C: ValueControlling>(control: C) where C.Value == T {
        output = control.output
        super.init(nibName: nil, bundle: nil)
        self.addChild(control)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = UIView()
        guard let controlView = children.first?.view else { return }
        controlView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controlView)
        NSLayoutConstraint.activate([
            controlView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controlView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            controlView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
        ])
    }
}
