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
      JungleView()
    }
  }
}
//  var body: some Scene {
//    WindowGroup {
//      TabView {
//        JungleView()
//          .tabItem {
//            Label("Game", systemImage: "list.dash")
//          }
//        NumberSequenceView(checkState: $checkState, ns: NumberSequence())
//          .tabItem {
//            Label("Game", systemImage: "list.dash")
//          }
//        MatrixEquationView(
//          checkState: $checkState,
//          matrixEquation: MatrixEquation(
//            numRows: 4,
//            numCols: 4,
//            maxM: 2,
//            maxB: 50, // if allowNegative and allowZero, b needs to be high enough
//            maxX: 10,
//            allowNegative: false,
//            allowZero: true
//          )
//        )
//          .tabItem {
//            Label("Game", systemImage: "list.dash")
//          }
//      }
//    }
