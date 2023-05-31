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
  
  @State var updater: Bool = false

  var original: [Int]
  var masked: [Int?]
  @State var guesses: [Int?]
  @Binding var checkState: CheckState
  var ns: NumberSequence
  let seed: Int?
  
  init(checkState: Binding<CheckState>, seed: Int?) {
//    var generator = RandomNumberGeneratorWithSeed(seed: 941)
    ns = NumberSequence(seed: seed)
    self.seed = seed
    print("initialised ns with seed: \(seed)")
    let sequence = ns.generateSequence()
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
        ForEach(0..<ns.listLength, id: \.self) { index in
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
      Text(String(describing: checkState != .solved))
      Text(String(describing: self.seed))
      
      Button(action: {updater.toggle()}, label: {Text("Update")})
      
      CheckView(cond: {original == guesses}, checkState: $checkState)
//        .navigationBarBackButtonHidden(checkState != .solved)
    }
  }
}


struct xxx1 : View {
  @State var checkState = CheckState.enabled
    var body: some View {
      NumberSequenceView(
          checkState: $checkState,
          seed: 1
        )
    }
}

struct NumberSequenceView_Previews: PreviewProvider {
  static var previews: some View {
    xxx1()
  }
}

struct RandomNumberGeneratorWithSeed: RandomNumberGenerator {
    init(seed: Int) {
        // Set the random seed
        srand48(seed)
    }
    
    func next() -> UInt64 {
        // drand48() returns a Double, transform to UInt64
        return withUnsafeBytes(of: drand48()) { bytes in
            bytes.load(as: UInt64.self)
        }
    }
}
