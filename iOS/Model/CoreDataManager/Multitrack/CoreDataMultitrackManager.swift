//
//  CoreDataMultitrackManager.swift
//  Play Secuence (iOS)
//
//  Created by Esteban Rafael Trivino Guerra on 27/02/23.
//

import Foundation
import CoreData



class CoreDataMultitrackManager {// Get Core Data managed object context
    
    let container = NSPersistentContainer(name: "Sequences")
    
    var context: NSManagedObjectContext {
        self.container.viewContext
    }
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func commit() {
        do {
            try self.container.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Multitracks
    func saveMultitrack(_ multitrack: Multitrack) {
        let multitrackDao = multitrack.mapToMultitrackDao(context: self.context)
        self.saveTracks(multitrack.tracks, for: multitrackDao)
    }
    
    func loadMultitracks() -> [MultitrackDao] {
        var multitracks: [MultitrackDao] = []
        let fetchRequest: NSFetchRequest<MultitrackDao> = MultitrackDao.fetchRequest()
        
        do {
            multitracks = try self.context.fetch(fetchRequest)
            print(multitracks)
        } catch {
            print("Unable to Fetch MultitrackDaos, (\(error))")
        }
        return multitracks
    }
    
    // MARK: Tracks
    
    func updateTrack(_ track: Track) {
        let fetchRequest: NSFetchRequest<TrackDao> = TrackDao.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", track.id as CVarArg)
        do {
            if let trackDao = try self.context.fetch(fetchRequest).first {
                print(trackDao.multitrack?.name ?? "")
                trackDao.name = track.name
                trackDao.relativePath = track.relativePath
                trackDao.volume = track.config.volume
                trackDao.pan = track.config.pan
                self.commit()
            }
        } catch {
            print("Unable to Update TrackDao in updateTrack, (\(error))")
        }
    }
    
    func saveTracks(_ tracks: [Track], for multitrack: MultitrackDao) {
        tracks.forEach() { track in
            _ = track.mapToTrackDao(context: self.context, with: multitrack)
        }
    }
    
    func loadTracks(for multitrack: MultitrackDao) -> [TrackDao] {
        var tracks: [TrackDao] = []
        let fetchRequest: NSFetchRequest<TrackDao> = TrackDao.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "multitrack == %@", multitrack)
        do {
            tracks = try self.context.fetch(fetchRequest)
            tracks.forEach() { print($0.multitrack?.name ?? "") }
        } catch {
            print("Unable to Fetch TrackDaos in loadTracks, (\(error))")
        }
        return tracks
    }
    
    func deleteMultitracks() {
        self.loadMultitracks().forEach() { multitrackDao in
            self.loadTracks(for: multitrackDao).forEach() { trackDao in
                self.context.delete(trackDao)
            }
            self.context.delete(multitrackDao)
        }
        self.commit()
    }
}
