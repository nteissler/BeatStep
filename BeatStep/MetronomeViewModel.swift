//
// Created by Nick Teissler on 1/3/19
// Copyright © 2019 Nick Teissler. All rights reserved.

import Foundation
import AudioKit
import RxSwift
import RxCocoa

class MetronomeViewModel {
    private let metronome = AKMetronome()
    let bag = DisposeBag()

    // MARK: - Inputs
    let cadence = PublishRelay<Double>()
    let frequency = PublishRelay<Double>()
    let playToggle = PublishRelay<Void>()

    // MARK: - Outputs
    let playObservable: Observable<Bool>

    init() {
        // TODO: Configure route change handling
//        AKSettings.enableRouteChangeHandling = false
//        AKSettings.enableCategoryChangeHandling = false
//        AKSettings.disableAVAudioSessionCategoryManagement = true
//        AKSettings.disableAudioSessionDeactivationOnStop = false
        AKSettings.playbackWhileMuted = true
        do {
            try AKSettings.setSession(category: .playback, with: [.mixWithOthers])
        } catch {
            print(error)
        }
        AudioKit.output = metronome

        playObservable = playToggle.scan(false, accumulator: { (prev, _) in
            return !prev
        }).debug("Play State").share()
        
        playObservable.subscribe(onNext: { playing in
            if playing {
                self.play()
            } else {
                self.pause()
            }
        }).disposed(by: bag)

        // TODO: Error handling
        try! AudioKit.start()
        cadence.debug("Cadence BehaviorSubject").subscribe(onNext: { [unowned self] (cadence) in
            self.metronome.tempo = cadence
        }).disposed(by: bag)

        frequency.debug("Frequency BehaviorSubject").subscribe(onNext: { (newFrequency) in
            self.metronome.frequency1 = newFrequency
        } ).disposed(by: bag)
    }

    private func play() {
        metronome.reset()
        metronome.restart()
    }

    private func pause() {
        metronome.stop()
        metronome.reset()
    }
}
