//
// Created by Nick Teissler on 2/1/19
// Copyright © 2019 Nick Teissler. All rights reserved.

import Foundation
import RxSwift
import RxCocoa

class SliderViewModel {
    private let _value: BehaviorSubject<Float>

    init(initial: Float) {
        _value = BehaviorSubject<Float>(value: initial)
    }

    var output: Observable<Float> { return _value.asObservable() }

    var input: AnyObserver<Float> { return _value.asObserver() }
}
