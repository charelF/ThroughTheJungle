//
//  NumberSequence.swift
//  ThroughTheJungle
//
//  Created by Charel Felten on 28/05/2023.
//

import Foundation

class NumberSequence {
  let hiddenNumbers = 4
  let listLength: Int = 10
//  var generator: RandomNumberGeneratorWithSeed
  
  init(seed: Int?) {
//    let safeseed: Int
//    if seed == nil {
//      safeseed = Int.random(in: 1..<1000)
//    } else {
//      safeseed = seed!
//    }
//    generator = RandomNumberGeneratorWithSeed(seed: safeseed)
    
  }
  
  func generateSequence() -> (original: [Int], masked: [Int?]) {
    
    var original: [Int] = []
    
    while true {
      print("original.count != listLength", original.count != listLength)
      print("original.max() ?? 0 < 150", original.max() ?? 0 < 150)
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
  
}
