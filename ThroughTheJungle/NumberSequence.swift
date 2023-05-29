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
  var generator: RandomNumberGeneratorWithSeed
  
  init(seed: Int) {
    generator = RandomNumberGeneratorWithSeed(seed: seed)
  }
  
  func generateSequence() -> (original: [Int], masked: [Int?]) {
    
    var original: [Int] = []
    
    while true {
      print("original.count != listLength", original.count != listLength)
      print("original.max() ?? 0 < 150", original.max() ?? 0 < 150)
      original = []
      let sign1 = Sign.allCases.randomElement(using: &generator)!
      let val1 = Int.random(in: 1..<2)
      //    let sign2 = Sign.allCases.randomElement()
      //    let val2 = Int.random(in: 1..<10)
      let startValue = Int.random(in: 1..<50, using: &generator)
      
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
      randomIndexes.insert(Int.random(in: 0..<listLength, using: &generator))
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
