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
                .frame(height: 35, alignment: .center)
            Text("Play Secuence").bold().font(.system(size: 18))
            Text("by Esteban Triviño").italic().font(.system(size: 14))
            Spacer()
        }
        .padding(25)
        .frame(height: 40)
        .background(Color("PSNavy"))
        .foregroundColor(Color("PSWhite"))
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
    }
}
