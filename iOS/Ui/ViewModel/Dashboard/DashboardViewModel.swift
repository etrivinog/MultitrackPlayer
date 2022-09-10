//
//  SequenceControlsViewModel.swift
//  Play Secuence (iOS)
//
//  Created by Esteban Rafael Trivino Guerra on 8/09/22.
//

import Foundation

final class DashboardViewModel: ObservableObject {
    @Published var multitracks: [Multitrack] = []
    @Published var trackControllers: [TrackControlViewModel] = []
    private(set) var selectedMultitrack: Int?
    
    func onAppear() {
        // TODO: Get the selectedMultitrack value from userdefaults
        if let firstMultitrackId = multitracks.first?.id {
            self.selectedMultitrack = firstMultitrackId
        }
    }
    
    func selectMultitrack(_ multitrackId: Int) {
        if self.selectedMultitrack != multitrackId {
            self.selectedMultitrack = multitrackId
            self.stopTracks()
            trackControllers.removeAll()
            if let selectedMultitrack = self.selectedMultitrack {
                for track in multitracks[selectedMultitrack].tracks {
                    self.appendTrackController(with: track)
                }
                self.objectWillChange.send()
            }
        }
    }
    
    func getSelectedMultitrack() -> Multitrack? {
        if let selectedMultitrack = self.selectedMultitrack {
            return self.multitracks[selectedMultitrack]
        } else {
            return nil
        }
    }
    
    func appendTrackController(with track: Track) {
        self.trackControllers.append(TrackControlViewModel(track: track))
    }
    
    func playTracks() {
        if let firstController = trackControllers.first {
            let timeToPlay = firstController.deviceCurrentTime + 1
            for controller in trackControllers {
                controller.play(at: timeToPlay)
            }
        }
    }
    
    func pauseTracks() {
        if let firstController = trackControllers.first {
            let currentPosition = firstController.currentTime
            for controller in trackControllers {
                controller.pauseTrack()
                controller.currentTime = currentPosition
            }
        }
    }
    
    func stopTracks() {
        for controller in trackControllers {
            controller.stopTrack()
        }
    }
}
