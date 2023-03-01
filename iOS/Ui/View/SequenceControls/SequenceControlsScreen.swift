//
//  SequenceControlsScreen.swift
//  Play Secuence (iOS)
//
//  Created by Esteban Rafael Trivino Guerra on 8/09/22.
//

import SwiftUI

struct SequenceControlsScreen: View {
    @ObservedObject var viewModel: DashboardViewModel
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                Spacer()
                ForEach(self.viewModel.trackControllers.map({ $0.value })) { controller in
                    if let trackController = viewModel.trackControllers[controller.id] {
                        TrackControl(viewModel: trackController)
                        Spacer()
                    }
                }
            }
            .frame(minHeight: 50, maxHeight: 200)
        }
    }
}

struct Faders_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = DashboardViewModel()
        viewModel.appendTrackController(using: Track(id: UUID(), name: "Click", relativePath: "", config: .init(pan: 0, volume: 0.5)))
        viewModel.appendTrackController(using: Track(id: UUID(), name: "Sequence", relativePath: "", config: .init(pan: 0, volume: 0.5)))
        viewModel.appendTrackController(using: Track(id: UUID(), name: "Keys", relativePath: "", config: .init(pan: 0, volume: 0.5)))
        return SequenceControlsScreen(viewModel: viewModel)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
