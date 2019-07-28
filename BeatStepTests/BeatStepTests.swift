//
// Created by Nick Teissler on 12/29/18
// Copyright © 2018 Nick Teissler. All rights reserved.

import XCTest
import SnapshotTesting
@testable import BeatStep


class BeatStepTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHomeScreen() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! BeatTabBarController

        let devices = [
                      "iPhoneSe",
                      "iPhoneX",
                      "iPhoneXr",
                      "iPhoneXsMax",
                      "iPadMini"
                    ]
        let names = zip((0..<devices.count).lazy.map { _ in "Vanilla Home Screen " }, devices).map { $0 + $1 }
        let snapshottings: [Snapshotting<UIViewController, UIImage>] = [
            .image(on: .iPhoneSe, precision: 0.95),
            .image(on: .iPhoneX, precision: 0.95),
            .image(on: .iPhoneXr, precision: 0.95),
            .image(on: .iPhoneXsMax, precision: 0.95),
            .image(on: .iPadMini(.portrait), precision: 0.95)
        ]
        let snapshots: [String: Snapshotting<UIViewController, UIImage>] = zip(names, snapshottings).reduce(into: [:]) { (dict, pair) in
            let (key, value) = pair
            dict[key] = value
        }

        assertSnapshots(matching: homeViewController,
                        as: snapshots)
        homeViewController.viewModel.playToggle.accept(()) // is there a different method than this?
        assertSnapshot(matching: homeViewController, as: .image(precision: 0.95), named: "Play to Pause toggle")


        // TODO
        // how to name snapshots ☑️
        // taking on multiple devices ☑️
        // name the folder they go to
        // allow a pixel tolerance ☑️
        // alias to cute camera function
        // use resolver to inject a different audio object
    }
}
