//
//  Header.swift
//  Play Secuence (iOS)
//
//  Created by Esteban Rafael Trivino Guerra on 8/09/22.
//

import SwiftUI

struct Header: View {
    var body: some View {
        HStack {
            Image(systemName: "iphone.badge.play")
                .resizable()
                .scaledToFit()
                .frame(height: 40, alignment: .center)
            Text("Play Secuence")
            Spacer()
        }
        .padding(25)
        .frame(height: 80)
        .background(Color("PSNavy"))
        .foregroundColor(Color("PSWhite"))
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
    }
}
