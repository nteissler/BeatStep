//
// Created by Nick Teissler on 2/1/19
// Copyright © 2019 Nick Teissler. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol ValueControlling where Self: UIViewController {
    associatedtype Value: Strideable
    var output: Observable<Value> { get }
}

class SliderViewController: UIViewController, ValueControlling {
    private let slider = UISlider()
    private let viewModel: SliderViewModel
    let output: Observable<Float>
    let bag = DisposeBag()

    init(min: Float, max: Float, initial: Float) {
        viewModel = SliderViewModel(initial: initial)
        output = viewModel.output
        super.init(nibName: nil, bundle: nil)
        slider.minimumValue = min
        slider.maximumValue = max
        slider.value = initial
        slider.rx.value.subscribe(viewModel.input).disposed(by: bag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = slider
    }
}
