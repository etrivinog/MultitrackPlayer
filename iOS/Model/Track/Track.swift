//
//  AudioUrl.swift
//  Play Secuence (iOS)
//
//  Created by Esteban Rafael Trivino Guerra on 9/09/22.
//

import Foundation
import CoreData

struct Track: Identifiable {
    var id: UUID
    var name: String
    var relativePath: String
    var config: Track.Config
    
    struct Config {
        var pan: Float
        var volume: Float
        var isMuted: Bool
        
        var volumeWithMute: Float {
            isMuted ? 0 : volume
        }
    }
}

extension Track {
    func mapToTrackDao(context: NSManagedObjectContext, with multitrack: MultitrackDao) -> TrackDao {
        let trackDao = TrackDao(context: context)
        trackDao.multitrack = multitrack
        trackDao.id = self.id
        trackDao.name = self.name
        trackDao.relativePath = self.relativePath
        trackDao.pan = self.config.pan
        trackDao.volume = self.config.volume
        return trackDao
    }
}

extension TrackDao {
    func mapToTrack() -> Track {
        Track(id: self.id ?? UUID(), name: self.name ?? "", relativePath: self.relativePath ?? "", config: .init(pan: self.pan, volume: self.volume, isMuted: self.mute))
    }
}
