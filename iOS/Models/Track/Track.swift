//
//  AudioUrl.swift
//  Play Secuence (iOS)
//
//  Created by Esteban Rafael Trivino Guerra on 9/09/22.
//

import Foundation

struct Track: Identifiable {
    var id: Int
    var name: String
    var url: URL
    var config: Track.Config
    
    struct Config {
        var pan: Float
        var volume: Float
    }
}
