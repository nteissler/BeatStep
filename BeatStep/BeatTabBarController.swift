//
// Created by Nick Teissler on 12/29/18
// Copyright © 2018 Nick Teissler. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

class BeatTabBarController: UITabBarController {

    let viewModel = MetronomeViewModel()
    private lazy var playPauseButton: UIButton = PlayPauseButton(input: viewModel.playObservable)
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        addPlayButtonToView()
        playPauseButton.rx.tap.asObservable().bind(to: viewModel.playToggle).disposed(by: bag)
        installPlayPauseTapRecognizers()
    }

    // MARK: Subview Layout
    private func addPlayButtonToView() {
        view.addSubview(playPauseButton)

        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        playPauseButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        playPauseButton.widthAnchor.constraint(equalTo: playPauseButton.heightAnchor).isActive = true

        // The play button is as tall at most 20% of the width of the tab bar, but no more than 180%
        // the height of the tab bar. This makes it a reasonable size on all devices as far as I can tell.
        let optional = playPauseButton.heightAnchor.constraint(equalTo: tabBar.widthAnchor, multiplier: 0.2)
        optional.priority = .defaultHigh
        optional.isActive = true
        playPauseButton.heightAnchor.constraint(lessThanOrEqualTo: tabBar.heightAnchor, multiplier: 1.8).isActive = true
    }

    private func installPlayPauseTapRecognizers() {
        let tapRecognizers = [UITapGestureRecognizer(), UITapGestureRecognizer()]
        tapRecognizers.enumerated().forEach { (requiredTaps, tapRecognizer) in
            tapRecognizer.numberOfTapsRequired = requiredTaps + 1
            tapRecognizer.rx.event.map { _ in () }.bind(to: viewModel.playToggle).disposed(by: bag)
            tapRecognizer.cancelsTouchesInView = false
            tapRecognizer.delegate = self
            tapRecognizer.requiresExclusiveTouchType = true
            view.addGestureRecognizer(tapRecognizer)
        }
        tapRecognizers[0].require(toFail: tapRecognizers[1])
    }
}

extension BeatTabBarController: UIGestureRecognizerDelegate {

    // Treat any "negative space" on the screen as a play pause reqeust.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(view.gestureRecognizers?.contains(gestureRecognizer) ?? false && touch.view is UIControl)
    }
}
