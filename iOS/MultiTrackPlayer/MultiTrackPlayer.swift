//
//  MultiTrackPlayer.swift
//  Play Secuence
//
//  Created by Esteban Triviño on 21/08/25.
//


import AVFoundation

class MultiTrackPlayer: ObservableObject {
    private let engine = AVAudioEngine()
    private var players: [UUID: AVAudioPlayerNode] = [:] // trackID → node
    private var audioFiles: [UUID: AVAudioFile] = [:]   // trackID → file
    private let audioQueue = DispatchQueue(label: "AudioControlQueue",
                                           qos: .userInitiated,
                                           attributes: .concurrent)
    
    var multitrack: Multitrack
    var isPlaying = false
    
    init(multitrack: Multitrack) {
        self.multitrack = multitrack
        setupEngine()
    }
    
    private func setupEngine() {
        for track in multitrack.tracks {
            let trackPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(track.relativePath)
            let trackUrl = URL(fileURLWithPath: trackPath)
            
            do {
                let file = try AVAudioFile(forReading: trackUrl)
                let player = AVAudioPlayerNode()
                
                engine.attach(player)
                engine.connect(player, to: engine.mainMixerNode, format: file.processingFormat)
                
                player.volume = track.config.volumeWithMute
                player.pan = track.config.pan
                
                players[track.id] = player
                audioFiles[track.id] = file
            } catch {
                print("❌ Error cargando \(track.relativePath): \(error)")
            }
        }
        
        // 🔹 Conectar mixer → salida (importante!)
        let format = engine.mainMixerNode.outputFormat(forBus: 0)
        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: format)
    }
    
    func play() {
        audioQueue.async { [weak self] in
            guard let self else { return }
            guard !isPlaying else { return }
            do {
                try engine.start()
                let startTime = AVAudioTime(hostTime: mach_absolute_time())
                
                for track in multitrack.tracks {
                    if let player = players[track.id], let file = audioFiles[track.id] {
                        audioQueue.async {
                            player.scheduleFile(file, at: startTime, completionHandler: nil)
                            player.play(at: startTime)
                        }
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    isPlaying = true
                }
            } catch {
                print("❌ Error al iniciar engine: \(error)")
            }
        }
    }
    
    func pause() {
        guard isPlaying else { return }
        engine.pause()
        isPlaying = false
    }
    
    func stop() {
        players.values.forEach { $0.stop() }
        engine.stop()
        isPlaying = false
    }
    
    func getPlayerNode(forTrackID trackID: UUID) -> AVAudioPlayerNode? {
        players[trackID]
    }
}
