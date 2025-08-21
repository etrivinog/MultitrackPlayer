//
//  AudioPlayer.swift
//  Play Secuence (iOS)
//
//  Created by Esteban Rafael Trivino Guerra on 9/09/22.
//

import AVFoundation

class TrackControlViewModel: ObservableObject, Identifiable {
    
    @Published var uiPan: PanOptions
    
    private let dataManager = CoreDataMultitrackManager()
    
    private(set) var id: UUID
    private var player: AVAudioPlayerNode
    private var track: Track
    private let audioQueue = DispatchQueue(label: "AudioControlQueue",
                                           qos: .userInitiated,
                                           attributes: .concurrent)
    
    init(track: Track,
         player: AVAudioPlayerNode) {
        self.track = track
        self.id = track.id
        self.player = player
        self.uiPan = PanOptions(from: track.config.pan)
    }
    
// MARK: Track methods
    var trackName: String {
        self.track.name
    }
    
    var mute: Bool {
        self.track.config.isMuted
    }
    
// MARK: Player methods
//    func play(at interval: TimeInterval) {
//        self.player.play()
//    }
    
    private func muteTrack() {
//        self.player.setVolume(0, fadeDuration: .zero)
        player.volume = 0
        self.track.config.isMuted = true
    }
    
    private func unmuteTrack() {
//        self.player.setVolume(self.track.config.volume, fadeDuration: .zero)
        player.volume = self.track.config.volume
        self.track.config.isMuted = false
    }
    
    func toogleMute() {
        audioQueue.async {
            if self.player.volume == 0 {
                self.unmuteTrack()
            } else {
                self.muteTrack()
            }
            self.updateTrack()
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    func pauseTrack() {
        player.pause()
    }
    
//    func stopTrack() {
//        player.stop()
//        player.currentTime = 0
//    }
    
    var trackVolume: Float {
        get {
            self.track.config.isMuted ?
            self.track.config.volume * 100 :
            self.player.volume * 100
        }
        set {
            audioQueue.async {
                if !self.track.config.isMuted {
                    self.player.volume = newValue/100
                }
                self.track.config.volume = newValue/100
                self.updateTrack()
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    }
    
    func setPan(_ option: PanOptions) {
        uiPan = option // solo para refrescar la UI
        audioQueue.async { [weak self] in
            guard let self = self else { return }
            self.track.config.pan = option.rawValue
            self.player.pan = option.rawValue
            self.updateTrack()
        }
    }

    private func updateTrack() {
        self.dataManager.updateTrack(self.track)
    }
    
//    var currentTime: TimeInterval {
//        get {
//            self.player.currentTime
//        }
//        set {
//            self.player.currentTime = newValue
//        }
//    }
//    
//    var deviceCurrentTime: TimeInterval {
//        self.player.deviceCurrentTime
//    }
    
// MARK: Pan Options
    enum PanOptions: Float {
        case left = -1
        case center = 0
        case right = 1
        
        init(from float: Float) {
            if float == 0.0 {
                self = .center
            } else if float > 0 {
                self = .right
            } else {
                self = .left
            }
        }
    }
}
