//
// Created by Nick Teissler on 12/29/18
// Copyright © 2018 Nick Teissler. All rights reserved.

import UIKit

class RootTabBarController: UITabBarController {

    lazy var playPauseButton: UIButton = PlayPauseButton(play: { [weak self] in self?.viewModel.play() },
                                                         pause: { [weak self] in self?.viewModel.pause() } )
    var viewModel: RootViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        addPlayButtonToView()
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
}

