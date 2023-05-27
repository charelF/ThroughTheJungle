//
//  CheckView.swift
//  ThroughTheJungle
//
//  Created by Charel Felten on 18/05/2023.
//

import SwiftUI

enum CheckState {
  case solved
  case enabled
  case disabledBecauseInput
  case disabledBecauseTimer
}

struct CheckView: View {
  
  var condition: () -> Bool
  @State var isTimerRunning = false
  @State var remainingTime = 10
  @State var remainingGuesses = 2
  let totalGuesses = 2
  
  @Binding var checkState: CheckState
//  @Environment(\.checkState) var checkState//: CheckState
  
  init(cond: @escaping () -> Bool, checkState: Binding<CheckState>) {
//  init(cond: @escaping () -> Bool, checkState: CheckState) {
    condition = cond
    self._checkState = checkState
  }
  
  var buttonText: String {
    switch $checkState.wrappedValue {
    case .disabledBecauseTimer:
      return "⏳"
    case .solved:
      return "✅"
    default:
      return "Check: (\(remainingGuesses)/\(totalGuesses)) \($checkState.wrappedValue)"
    }
  }
  
  func buttonAction() {
    print("clicked")
    print(condition())
    if remainingGuesses > 0 {
      if condition() {
        $checkState.wrappedValue = .solved
        print("solved")
      } else {
        remainingGuesses -= 1
        if remainingGuesses <= 0 {
          $checkState.wrappedValue = .disabledBecauseTimer
          startTimer()
        } else {
          $checkState.wrappedValue = .enabled
        }
      }
    } else {
      $checkState.wrappedValue = .disabledBecauseTimer
      startTimer()
    }
  }
  
  var body: some View {
    HStack {
      Button(action: buttonAction) {
        Text(buttonText)
          .bold()
          .font(.system(size: 30, design: .rounded))
          .padding()
          
      }
      .buttonStyle(.bordered)
      .disabled($checkState.wrappedValue != .enabled)
      
      .padding()
      .disabled($checkState.wrappedValue == .disabledBecauseTimer || $checkState.wrappedValue == .disabledBecauseInput)
      
      Text($checkState.wrappedValue == .disabledBecauseTimer ? formattedTime(remainingTime) : "")
        .bold()
        .font(.system(size: 30, design: .rounded))
        .padding()
    }
  }
  private func startTimer() {
    isTimerRunning = true
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
      if remainingTime > 0 {
        remainingTime -= 1
      } else {
        timer.invalidate()
        $checkState.wrappedValue = .enabled
        remainingGuesses = 1
        remainingTime = 10
      }
    }
  }
}
  
  private func formattedTime(_ seconds: Int) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad

    if let formattedString = formatter.string(from: TimeInterval(seconds)) {
        return formattedString
    }
    return ""
}

struct CheckViewPreviewContainer : View {
  @State var checkState = CheckState.enabled
    var body: some View {
        CheckView(
          cond: {false},
          checkState: $checkState
        )
    }
}

struct CheckView_Previews: PreviewProvider {
  @State var checkState = CheckState.enabled
    static var previews: some View {
      CheckViewPreviewContainer()
    }
}

