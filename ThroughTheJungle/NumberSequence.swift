//
//  NumberSequence.swift
//  ThroughTheJungle
//
//  Created by Charel Felten on 28/05/2023.
//

import Foundation

class NumberSequence {
  let hiddenNumbers = 1
  let listLength: Int = 10
  var original: [Int]
  var masked: [Int?]
  
  init() {
    
    original = []
    masked = []
    
    while true {
      original = []
      let sign1 = Sign.allCases.randomElement()!
      let val1 = Int.random(in: 1..<11)
      let sign2 = Sign.allCases.randomElement()!
      let val2 = Int.random(in: 1..<11)
      let startValue = Int.random(in: 1..<50)
      
      var newValue = startValue
      for i in 0..<listLength {
        original.append(newValue)
        if i%2 == 0 {
          newValue = sign1.op()(newValue, val1)
        } else {
          newValue = sign2.op()(newValue, val2)
        }
      }
      if (original.max()! < 150) && (original.min()! > 0) {
        break
      }
    }
    
    var randomIndexes = Set<Int>()
    while randomIndexes.count < hiddenNumbers {
      randomIndexes.insert(Int.random(in: 0..<listLength))
    }
    
    for i in 0..<listLength {
      if randomIndexes.contains(i) {
        masked.append(nil)
      } else {
        masked.append(original[i])
      }
    }
  }
}
