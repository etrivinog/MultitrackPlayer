//
//  PanSelector.swift
//  Play Secuence (iOS)
//
//  Created by Esteban Rafael Trivino Guerra on 9/09/22.
//

import SwiftUI

struct PanSelector: View {
    @Binding var selectedPan: TrackControlViewModel.PanOptions
    var onChange: ((TrackControlViewModel.PanOptions) -> Void)?
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedPan) {
                Text("Left").tag(TrackControlViewModel.PanOptions.left)
                Text("Center").tag(TrackControlViewModel.PanOptions.center)
                Text("Right").tag(TrackControlViewModel.PanOptions.right)
            }
            .pickerStyle(.palette)
            .onChange(of: selectedPan) {
                // Solo aquí mandamos al engine (en background)
                onChange?(selectedPan)
            }
        }
    }
}

struct PanSelector_Previews: PreviewProvider {
    struct MyPreview: View {
        @State var panOption: TrackControlViewModel.PanOptions = .center
        var body: some View {
            PanSelector(selectedPan: $panOption)
        }
    }
    
    static var previews: some View {
        MyPreview()
    }
}
