//
//  ContentView.swift
//  Shared
//
//  Created by Esteban Rafael Trivino Guerra on 8/09/22.
//

import SwiftUI

struct DashboardScreen: View {
    @State private var showPicker: Bool = false
    @StateObject var viewModel = DashboardViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Header()
            Spacer()
            VStack(spacing: 0) {
                HStack {
                    Text("Selected multitrack: ")
                    Text(self.viewModel.getSelectedMultitrack()?.name ?? "Ninguno")
                        .foregroundColor(Color.blue)
                    Spacer()
                }
                controlButtons
                Divider().padding(.top, 8)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(self.viewModel.multitracks.map() { $0.value }) { multitrack in
                            Button(action: {
                                self.viewModel.selectMultitrack(multitrack.id)
                            }){
                                Text(multitrack.name)
                                    .foregroundColor(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                            }
                            Divider()
                        }
                        Button(action: { self.showPicker.toggle() }) {
                            Image(systemName: "folder.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30, alignment: .center)
                        }
                        Spacer()
                    }
                }
                .frame(minHeight:30, maxHeight: 40)
                Divider().padding(.bottom, 8)
                Spacer()
                SequenceControlsScreen(viewModel: viewModel)
            }
            .padding(.horizontal, 30)
        }
        .onAppear(){
            self.viewModel.onAppear()
        }
        .sheet(isPresented: $showPicker) {
            DocumentPicker() { urls in
                self.viewModel.createMultitrack(with: urls)
            }
        }
    }
    
    @ViewBuilder
    var controlButtons: some View {
        HStack {
            Button(action: { self.viewModel.playTracks() }) {
                Image(systemName: "play.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30, alignment: .center)
            }
            Spacer()
            Button(action: { self.viewModel.pauseTracks() }) {
                Image(systemName: "pause.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30, alignment: .center)
            }
            Spacer()
            Button(action: { self.viewModel.stopTracks() }) {
                Image(systemName: "stop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30, alignment: .center)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = DashboardViewModel()
        let id1 = UUID()
        viewModel.multitracks[id1] = (.init(id: id1, name: "Rey de reyes", tracks: [.init(id: UUID(), name: "Click", relativePath: "", config: .init(pan: 0, volume: 0.5, isMuted: false))]))
        viewModel.appendTrackController(using: Track(id: UUID(), name: "Click", relativePath: "", config: .init(pan: -1, volume: 0.5, isMuted: false)) )
        return DashboardScreen(viewModel: viewModel)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
