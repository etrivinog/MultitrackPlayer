//
//  SequenceControlsViewModel.swift
//  Play Secuence (iOS)
//
//  Created by Esteban Rafael Trivino Guerra on 8/09/22.
//

import Foundation

final class DashboardViewModel: ObservableObject {
    @Published var multitracks = Dictionary<UUID, Multitrack>()
    @Published var trackControllers = Dictionary<UUID, TrackControlViewModel>()
    private(set) var selectedMultitrackIndex: UUID?
    
    let multitrackRepository: MultitrackRepository = MultitrackLocalRepository()
    
    func onAppear() {
        // Loads local multiracks
        self.multitracks = multitrackRepository.loadMultitracks()
        
        // TODO: Get the selectedMultitrackIndex value from userdefaults and assign the value to selectedMultitrackIndex
        if let selectedMultitrackIndex = self.multitracks.first?.key {
            self.selectMultitrack(selectedMultitrackIndex)
        }
    }
    
    func selectMultitrack(_ multitrackId: UUID) {
        if self.selectedMultitrackIndex != multitrackId {
            self.selectedMultitrackIndex = multitrackId
            self.stopTracks()
            trackControllers.removeAll()
            if let selectedMultitrackIndex = self.selectedMultitrackIndex,
               let tracks = multitracks[selectedMultitrackIndex]?.tracks {
                for track in tracks {
                    self.appendTrackController(using: track)
                }
                self.objectWillChange.send()
            }
        }
    }
    
    func createMultitrack(with urls: [URL]) {
        var multitrack = Multitrack(id: UUID(),
                                    name: "Multitrack \(self.multitracks.count)")
        for url in urls {
            let savedUrl = self.saveTrack(multitrackId: multitrack.id, in: url)
            let track = Track(
                id: UUID(),
                name: url.standardizedFileURL.deletingPathExtension().lastPathComponent,
                relativePath: multitrack.id.uuidString.appending(url.lastPathComponent),
                config: .init(pan: 0, volume: 0.5)
            )
            multitrack.tracks.append(track)
        }
        self.multitracks[multitrack.id]  = multitrack
        self.multitrackRepository.saveMultitrack(multitrack)
        self.selectMultitrack(multitrack.id)
    }
    
    private func saveTrack(multitrackId: UUID, in url: URL) -> URL {
        
//        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let urlToSave = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(multitrackId.uuidString.appending(url.lastPathComponent))
        print(paths)
        
        let encryptedData = NSData(contentsOf: url)
        if(encryptedData != nil){
            
            let fileManager = FileManager.default
            fileManager.createFile(atPath: paths as String, contents: encryptedData as Data?, attributes: nil)
        }
        return URL(fileURLWithPath: paths)
    }

    func getSelectedMultitrack() -> Multitrack? {
        if let selectedMultitrack = self.selectedMultitrackIndex {
            return self.multitracks[selectedMultitrack]
        } else {
            return nil
        }
    }
    
    func appendTrackController(using track: Track) {
        self.trackControllers[track.id] = TrackControlViewModel(track: track)
    }
    
    func playTracks() {
        if let firstController = trackControllers.first?.value {
            let timeToPlay = firstController.deviceCurrentTime + 1
            for controller in trackControllers.values.map({$0}) {
                controller.play(at: timeToPlay)
            }
        }
    }
    
    func pauseTracks() {
        if let firstController = trackControllers.first?.value {
            let currentPosition = firstController.currentTime
            for controller in trackControllers.values.map({$0}) {
                controller.pauseTrack()
                controller.currentTime = currentPosition
            }
        }
    }
    
    func stopTracks() {
        for controller in trackControllers {
            controller.value.stopTrack()
        }
    }
}
