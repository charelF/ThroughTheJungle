//
//  JungleView.swift
//  ThroughTheJungle
//
//  Created by Charel Felten on 01/04/2023.
//

import SwiftUI

struct JungleView: View {
    var body: some View {
      ZStack {
        Image("Jungle")
          .resizable()
          .scaledToFit()
          .frame(height: 800)
          .border(.black)
        RoundButton()
          .position(x: 350, y: 505)
      }
    }
}

struct RoundButton: View {
  var body: some View {
    Button(action: {
        // action to perform when button is tapped
    }) {
      Circle()
        .scale(0.075)
        .foregroundColor(.green)
        .shadow(radius: 5)
    }
  }
}

struct JungleView_Previews: PreviewProvider {
    static var previews: some View {
        JungleView()
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
