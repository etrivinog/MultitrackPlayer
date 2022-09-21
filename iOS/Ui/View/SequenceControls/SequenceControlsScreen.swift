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
                ForEach(self.viewModel.trackControllers) { controller in
                    TrackControl(viewModel: viewModel.trackControllers[controller.id])
                    Spacer()
                }
            }
            .frame(minHeight: 50, maxHeight: 200)
        }
    }
}

struct Faders_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = DashboardViewModel()
        viewModel.appendTrackController(with: Track(id: 1, name: "Click", url: URL(fileURLWithPath: "/"), config: .init(pan: 0, volume: 0.5)))
        viewModel.appendTrackController(with: Track(id: 2, name: "Sequence", url: URL(fileURLWithPath: "/"), config: .init(pan: 0, volume: 0.5)))
        viewModel.appendTrackController(with: Track(id: 3, name: "Keys", url: URL(fileURLWithPath: "/"), config: .init(pan: 0, volume: 0.5)))
        return SequenceControlsScreen(viewModel: viewModel)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
