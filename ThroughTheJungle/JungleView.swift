//
//  JungleView.swift
//  ThroughTheJungle
//
//  Created by Charel Felten on 01/04/2023.
//

import SwiftUI

struct JungleView_Previews: PreviewProvider {
  static var previews: some View {
    JungleView()
      .previewInterfaceOrientation(.landscapeLeft)
  }
}

enum LevelState {
    case done
    case current
    case locked
}

struct GameBoardView: View {
  let buttonCount = 30
  @State var currentLevel = 1
//  @State var checkState: CheckState
  
  func getPos(_ index: Int) -> (x: CGFloat, y: CGFloat, cx: CGFloat, cy: CGFloat) {
    let angle = -180 + (300 / Double(buttonCount - 1) * Double(index - 1))
    let radians = angle * .pi / 180
    let radius = 350.0
    let centerX = 150
    let centerY = 150
    let x = radius * cos(radians) + Double(centerX)
    let y = radius * sin(radians) + Double(centerY)
    return (x:x, y:y, cx: CGFloat(centerX), cy: CGFloat(centerY))
  }
  
  func getState(_ index: Int) -> LevelState {
    if index == currentLevel {
      return .current
    } else if index < currentLevel {
      return .done
    } else {
      return .locked
    }
  }
  
  func getColor(_ state: LevelState) -> Color {
    switch state {
    case .current: return .green
    case .done: return .yellow
    case .locked: return .green.opacity(0.3)
    }
  }
  
  @State var checkState = CheckState.enabled
  
  var body: some View {
    NavigationStack {
      
      
            ZStack() {
              ForEach(1...buttonCount, id: \.self) { index in
                let pos = getPos(index)
                let state = getState(index)
                let color = getColor(state)
                NavigationLink(value: state, label: {
                  Circle()
                    .foregroundColor(color)
                    .shadow(color: color, radius: 5, x: 0, y: 0)
                    .frame(width: 50, height: 50)
                    .overlay(
                      Text("\(index)")
                        .bold()
                        .font(.system(size: 25, design: .rounded))
                        .foregroundColor(Color.white)
                    )
                })
                .disabled(state != .current)
                .position(x: pos.x, y: pos.y)
      
                Text("Through the Jungle")
                  .bold()
                  .font(.system(size: 30, design: .rounded))
                  .foregroundColor(.green)
      
              }
            }
            .navigationDestination(for: LevelState.self) { state in
              if state == .current {
                switch currentLevel {
                case 1: NumberSequenceView(checkState: $checkState)
                default: EmptyView()
                }
              }
            }
            .frame(width: 300, height: 300)
          }
    }
  }



struct JungleView: View {
  var body: some View {
    GameBoardView()
  }
}
