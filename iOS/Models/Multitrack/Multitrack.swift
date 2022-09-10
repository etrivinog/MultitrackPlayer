//
//  Multitrack.swift
//  Play Secuence (iOS)
//
//  Created by Esteban Rafael Trivino Guerra on 9/09/22.
//

import Foundation

struct Multitrack: Identifiable {
    private(set) var id: Int
    private(set) var name: String
    var tracks: [Track] = []
}
