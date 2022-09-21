//
//  AudioPlayer.swift
//  Play Secuence (iOS)
//
//  Created by Esteban Rafael Trivino Guerra on 9/09/22.
//

import AVFoundation

class TrackControlViewModel: ObservableObject, Identifiable {
    
    private(set) var id: Int
    private var player: AVAudioPlayer
    private var track: Track
    
    init(track: Track) {
        self.track = track
        self.id = track.id
        self.player = TrackControlViewModel.buildPlayer(track: track)
    }
    
    //TODO: Mover de lugar
    class func buildPlayer(track: Track) -> AVAudioPlayer {
        var player: AVAudioPlayer
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: track.url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            player.setVolume(track.config.volume, fadeDuration: .infinity)
            player.prepareToPlay()
            
        } catch let error {
            player = AVAudioPlayer()
            print(error.localizedDescription)
        }
        return player
    }
    
// MARK: Track methods
    var trackName: String {
        self.track.name
    }
    
// MARK: Player methods
    func play(at interval: TimeInterval) {
        self.player.play(atTime: interval)
    }
    
    func pauseTrack() {
        player.pause()
    }
    
    func stopTrack() {
        player.stop()
        player.currentTime = 0
    }
    
    var trackVolume: Float {
        get {
            self.player.volume * 100
        }
        set {
            self.track.config.volume = newValue/100
            self.player.volume = newValue/100
            objectWillChange.send()
        }
    }
    
    var trackPan: PanOptions {
        get {
            self.converToPanOptions(from: self.track.config.pan)
        }
        set {
            self.track.config.pan = newValue.rawValue
            self.player.pan = newValue.rawValue
            objectWillChange.send()
        }
    }
    
    var currentTime: TimeInterval {
        get {
            self.player.currentTime
        }
        set {
            self.player.currentTime = newValue
        }
    }
    
    var deviceCurrentTime: TimeInterval {
        self.player.deviceCurrentTime
    }
    
// MARK: Pan Options
    enum PanOptions: Float {
        case left = -1
        case center = 0
        case right = 1
    }
    
    private func converToPanOptions(from float: Float) -> PanOptions {
        if float == 0.0 {
            return .center
        } else if float > 0 {
            return .right
        } else {
            return .left
        }
    }
}
