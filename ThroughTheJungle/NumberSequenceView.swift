//
//  NumberSequenceView.swift
//  ThroughTheJungle
//
//  Created by Charel Felten on 16/05/2023.
//

import SwiftUI

struct NumberSequenceView: View {
  
  static func generateSequence() -> (original: [Int], masked: [Int?]) {
    return (original: [0,1,2,3,4,5,6,7,8,9], masked: [nil, 1, 2, nil, nil, 5, 6, 7, 8, 9])
  }
  
  var original: [Int]
  var masked: [Int?]
  @State var guesses: [Int?]
  
  init() {
    let sequence = NumberSequenceView.generateSequence()
    original = sequence.original
    masked = sequence.masked
    guesses = sequence.masked
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
        ForEach(0..<10) { index in
          //        let o = sequence.original[index]
          let m = masked[index]
          Rectangle()
            .foregroundColor(getColor(m))
            .cornerRadius(10)
            .frame(width: 50, height: 50)
            .overlay(
              Group {
                if let m {
                  Text(String(m))
                } else {
                  TextField("", text: Binding(
                    get: { getGuess(guesses[index]) },
                    set: { guesses[index] = Int($0) ?? nil }
                  ))
                  .keyboardType(.numberPad)
                  .multilineTextAlignment(.center)
                }
              }
            )
        }
      }
      Button(action: {
        if original == guesses {}
      }) {
        Text("Check Arrays:")
      }
      .padding()
      
      Text(original.compactMap { $0 != nil ? String($0) : "-" }
                       .joined(separator: " "))
      Text(masked.compactMap { $0 != nil ? String($0!) : "-" }
                       .joined(separator: " "))
      Text(guesses.compactMap { $0 != nil ? String($0!) : "-" }
                       .joined(separator: " "))
    }
  }
}



struct NumberSequenceView_Previews: PreviewProvider {
    static var previews: some View {
        NumberSequenceView()
    }
}
