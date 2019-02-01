//
// Created by Nick Teissler on 1/3/19
// Copyright © 2019 Nick Teissler. All rights reserved.

import Foundation
import AudioKit

class RootViewModel {
    let metronome = AKMetronome()

    init() {
//        AKSettings.enableRouteChangeHandling = false
//        AKSettings.enableCategoryChangeHandling = false
//        AKSettings.disableAVAudioSessionCategoryManagement = true
//        AKSettings.disableAudioSessionDeactivationOnStop = false
        AKSettings.playbackWhileMuted = true
        do {
            try AKSettings.setSession(category: .playback, with: [.mixWithOthers, .allowBluetooth])
        } catch {
            print(error)
        }
        AudioKit.output = metronome

//         FIXME: Error handling
        try! AudioKit.start()

    }

    func play() {
        metronome.reset()
        metronome.restart()
    }

    func pause() {
        metronome.stop()
        metronome.reset()
    }
}
