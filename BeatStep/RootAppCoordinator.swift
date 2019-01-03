//
// Created by Nick Teissler on 1/3/19
// Copyright © 2019 Nick Teissler. All rights reserved.

import Foundation

@objc class RootAppCoordiantor: NSObject {
    @IBOutlet weak var rootTabBarController: RootTabBarController!

    override func awakeFromNib() {
        super.awakeFromNib()
        rootTabBarController.viewModel = RootViewModel()
    }
}
