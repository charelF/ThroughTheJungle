//
//  NumberSequenceView.swift
//  ThroughTheJungle
//
//  Created by Charel Felten on 16/05/2023.
//

import SwiftUI

enum Sign: CaseIterable {
  case plus, minus, times
  func op() -> (Int, Int) -> Int {
    switch self {
    case .plus: return {a, b in return a + b}
    case .minus: return {a, b in return a - b}
    case .times: return {a, b in return a * b}
    }
  }
}

struct NumberSequenceView: View {
  static let hiddenNumbers = 1
  static let listLength: Int = 10
  
  static func generateSequence() -> (original: [Int], masked: [Int?]) {
    var original: [Int] = []
    
    while true {
      print("original.count != listLength", original.count != listLength)
      print("original.max() ?? 0 < 150", original.max() ?? 0 < 150)
      original = []
      let sign1 = Sign.allCases.randomElement()!
      let val1 = Int.random(in: 1..<2)
      //    let sign2 = Sign.allCases.randomElement()
      //    let val2 = Int.random(in: 1..<10)
      let startValue = Int.random(in: 1..<50)
      
      var newValue = startValue
      for _ in 0..<listLength {
        original.append(newValue)
        newValue = sign1.op()(newValue, val1)
      }
      if (original.max()! < 150) && (original.min()! > 0) {
        break
      }
    }
    
    var randomIndexes = Set<Int>()
    while randomIndexes.count < hiddenNumbers {
      randomIndexes.insert(Int.random(in: 0..<listLength))
    }
    var masked = [Int?]()
    for i in 0..<listLength {
      if randomIndexes.contains(i) {
        masked.append(nil)
      } else {
        masked.append(original[i])
      }
    }
    return (original: original, masked: masked)
  }
  
  var original: [Int]
  var masked: [Int?]
  @State var guesses: [Int?]
  
//  @Environment(\.checkState) var checkState//: CheckState
  
  @Binding var checkState: CheckState
  
  init(checkState: Binding<CheckState>) {
    let sequence = NumberSequenceView.generateSequence()
    original = sequence.original
    masked = sequence.masked
    guesses = sequence.masked
    self._checkState = checkState
  }
  
  @State private var myValue: Int = 0
  
  func getGuess(_ guess: Int?) -> String {
    if let guess {
      return String(guess)
    } else {
      return ""
    }
  }
  
  func getColor(_ val: Int?) -> Color {
    if val == nil {
      return Color.green.opacity(0.3)
    } else {
      return Color.gray.opacity(0.3)
    }
  }
  
  var body: some View {
    VStack {
      HStack {
        ForEach(0..<NumberSequenceView.listLength, id: \.self) { index in
          let m = masked[index]
          Rectangle()
            .foregroundColor(getColor(m))
            .cornerRadius(10)
            .frame(width: 60, height: 60)
            .overlay(
              Group {
                if let m {
                  Text(String(m))
                    .bold()
                    .font(.system(size: 30, design: .rounded))
                } else {
                  TextField("", text: Binding(
                    get: { getGuess(guesses[index]) },
                    set: {
                      guesses[index] = Int($0) ?? nil
                      if !guesses.contains(where: { $0 == nil }) && !(checkState == .disabledBecauseTimer) {
                        checkState = .enabled
                        print("enabled")
                      }
                    }
                  ))
                  .keyboardType(.numberPad)
                  .multilineTextAlignment(.center)
                  .bold()
                  .font(.system(size: 30, design: .rounded))
                }
              }
            )
        }
      }
      
      Text(String(describing: original))
      Text(String(describing: guesses))
      Text(String(describing: $checkState.wrappedValue != .solved))
      
      CheckView(cond: {original == guesses}, checkState: $checkState)
//      Text(original.compactMap {String($0)}
//        .joined(separator: " "))
//      Text(masked.compactMap { $0 != nil ? String($0!) : "-" }
//        .joined(separator: " "))
//      Text(guesses.compactMap { $0 != nil ? String($0!) : "-" }
//        .joined(separator: " "))
    }
    .navigationBarBackButtonHidden(checkState != CheckState.solved)
  }
}

//struct NumberSequenceView_Previews: PreviewProvider {
//  static var previews: some View {
//    NumberSequenceView()
//      .previewInterfaceOrientation(.landscapeLeft)
//  }
//}
