//
// Created by Nick Teissler on 12/29/18
// Copyright © 2018 Nick Teissler. All rights reserved.

import UIKit

class RootTabBarController: UITabBarController {

    let playPauseButton = PlayPauseButton(type: .custom)


    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(playPauseButton)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        playPauseButton.widthAnchor.constraint(equalTo: playPauseButton.heightAnchor).isActive = true
        playPauseButton.heightAnchor.constraint(equalTo: tabBar.heightAnchor, multiplier: 0.9).isActive = true
        playPauseButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        playPauseButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        print("button tapped")
    }


}

