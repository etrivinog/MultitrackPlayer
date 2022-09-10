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
            VStack {
                HStack {
                    Text("Selected multitrack: ")
                    Text(self.viewModel.getSelectedMultitrack()?.name ?? "Ninguno")
                        .foregroundColor(Color.blue)
                    Spacer()
                }
                controlButtons
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(self.viewModel.multitracks) { multitrack in
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
                .frame(minHeight:30, maxHeight: 70)
                Spacer()
                SequenceControlsScreen(viewModel: viewModel)
            }
            .padding(.horizontal, 30)
        }
        .sheet(isPresented: $showPicker) {
            DocumentPicker() { urls in
                var multitrack = Multitrack(id: self.viewModel.multitracks.count, name: "Multitrack \(self.viewModel.multitracks.count)")
                for url in urls {
                    let savedUrl = saveTrack(multitrackId: multitrack.id, in: url)
                    let track = Track(
                        id: multitrack.tracks.count,
                        name: url.standardizedFileURL.deletingPathExtension().lastPathComponent,
                        url: savedUrl,
                        config: .init(pan: 0, volume: 0.5)
                    )
                    multitrack.tracks.append(track)
                }
                self.viewModel.multitracks.append(multitrack)
                self.viewModel.selectMultitrack(multitrack.id)
            }
        }
    }
    func saveTrack(multitrackId: Int, in url: URL) -> URL {
        
//        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let urlToSave = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(url.lastPathComponent)
        print(paths)
        
        let encryptedData = NSData(contentsOf: url)
        if(encryptedData != nil){
            
            let fileManager = FileManager.default
            fileManager.createFile(atPath: paths as String, contents: encryptedData as Data?, attributes: nil)
            
        }
        return URL(fileURLWithPath: paths)
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
        viewModel.multitracks.append(.init(id: 1, name: "Rey de reyes", tracks: [.init(id: 1, name: "Click", url: URL(fileURLWithPath: ""), config: .init(pan: 0, volume: 0.5))]))
        viewModel.appendTrackController(with: Track(id: 1, name: "Click", url: URL(fileURLWithPath: ""), config: .init(pan: -1, volume: 0.5)) )
        return DashboardScreen(viewModel: viewModel)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
