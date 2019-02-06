//
// Created by Nick Teissler on 1/3/19
// Copyright © 2019 Nick Teissler. All rights reserved.

import Foundation
import UIKit
import RxSwift
import RxCocoa

@objc class AppCoordiantor: NSObject {
    @IBOutlet weak var rootTabBarController: BeatTabBarController!
    let bag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        let metronome = rootTabBarController.viewModel
        rootTabBarController.viewControllers = makeTabChildren(metronome)
    }

    private func makeTabChildren(_ metronome: MetronomeViewModel) -> [UIViewController] {
        return [
        makePitchViewController(metronome),
        makeTempoViewController(metronome)
        ]
    }

    private func makePitchViewController(_ metronome: MetronomeViewModel) -> ValueViewController<Float> {
        let downbeatSlider = SliderViewController(min: 300, max: 1200, initial: 600)
        let upbeatSlider = SliderViewController(min: 300, max: 1200, initial: 450)
        let pitchViewController = ValueViewController<Float>(controls: [downbeatSlider, upbeatSlider])
        pitchViewController.output.map { (Double($0[0]), Double($0[1])) }.bind(to: metronome.frequency).disposed(by: bag)
        pitchViewController.view.backgroundColor = .green
        pitchViewController.title = NSLocalizedString("Pitch", comment: "Title for Pitch View Controller")
        pitchViewController.tabBarItem.image = #imageLiteral(resourceName: "Sound Wave.pdf")
        return pitchViewController
    }

    private func makeTempoViewController(_ metronome: MetronomeViewModel) -> ValueViewController<Float> {
        let slider = SliderViewController(min: 45, max: 150, initial: 75)
        let tempoViewController = ValueViewController<Float>(controls: [slider])
        tempoViewController.output.map{ $0.first }.filterNil().map(Double.init).bind(to: metronome.cadence).disposed(by: bag)
        tempoViewController.view.backgroundColor = .blue
        tempoViewController.title = NSLocalizedString("Tempo", comment: "Title for Tempo View Controller")
        tempoViewController.tabBarItem.image = #imageLiteral(resourceName: "Footsteps.pdf")
        return tempoViewController
    }
}
