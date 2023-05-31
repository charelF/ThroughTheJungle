//
//  ThroughTheJungleApp.swift
//  ThroughTheJungle
//
//  Created by Charel Felten on 26/03/2023.
//

import SwiftUI

@main
struct ThroughTheJungleApp: App {
  @State var checkState: CheckState = .enabled
  var body: some Scene {
    WindowGroup {
      TabView {
        JungleView()
          .tabItem {
            Label("Game", systemImage: "list.dash")
          }
        NumberSequenceView(checkState: $checkState, seed: nil)
          .tabItem {
            Label("Game", systemImage: "list.dash")
          }
        MatrixEquationView(checkState: $checkState)
          .tabItem {
            Label("Game", systemImage: "list.dash")
          }
      }
    }
  }
}
