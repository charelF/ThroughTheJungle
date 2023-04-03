//
//  ShapeCalculation.swift
//  ThroughTheJungle
//
//  Created by Charel Felten on 26/03/2023.
//

import Foundation


class MatrixEquation {
  let numRows: Int
  let numCols: Int
  let maxM: Int
  let maxB: Int
  let maxX: Int
  let allowZero: Bool
  let allowNegative: Bool
  let M: [[Int]]
  let b: [Int]
  let x: [Int]
  let WrongAnswers: [[Int]]
  let Choices: [[Int]]
  let emojis: [String]
  let correctIndices: [Int]
  
  init(numRows: Int, numCols: Int, maxM: Int, maxB: Int, maxX: Int, allowNegative: Bool, allowZero: Bool) {
    assert(numRows >= numCols)
    self.numRows = numRows
    self.numCols = numCols
    self.maxM = maxM
    self.maxB = maxB
    self.maxX = maxX
    self.allowNegative = allowNegative
    self.allowZero = allowZero
    self.emojis = MatrixEquation.getRandomEmojis(number: numCols)

    (self.M, self.x, self.b, self.WrongAnswers) = MatrixEquation.generateMatrixAndVectors(
      numRows: numRows, numCols: numCols, maxM: maxM, maxB: maxB, maxX: maxX, allowNegative: allowNegative, allowZero: allowZero
    )
    (self.Choices, self.correctIndices) = MatrixEquation.mixGuesses(correct: self.x, wrong: self.WrongAnswers)
  }
  
  
  static let emojiGroups: [[String]] = [
      ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍈"],
      ["🥑", "🍆", "🥔", "🥕", "🌽", "🌶", "🥒", "🥬", "🥦", "🍄"],
      ["🍕", "🍔", "🍟", "🌭", "🥪", "🌮", "🌯", "🥗", "🥘", "🍝"],
      ["🍦", "🍧", "🍨", "🍩", "🍪", "🎂", "🍰", "🧁", "🥧", "🍫"],
      ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🦁", "🐯"],
      ["🦄", "🐴", "🦓", "🦌", "🦒", "🦏", "🐘", "🦍", "🦔", "🦇"],
      ["🌸", "🌼", "🌻", "🌺", "🌹", "🌷", "🌱", "🌿", "🍁", "🍂"],
      ["🌞", "🌙", "🌟", "☀️", "⛅️", "☁️", "⛈", "🌧", "🌨", "❄️"],
      ["🚗", "🚕", "🚙", "🚌", "🚎", "🚐", "🚚", "🚛", "🚜", "🚓"],
      ["🍎", "🍌", "🍇", "🍉", "🍊", "🍓", "🍑", "🍒", "🍍", "🥝"],
      ["🍆", "🍅", "🌽", "🍠", "🥔", "🥕", "🍄", "🥦", "🥒", "🥬"],
      ["🍔", "🍟", "🍕", "🌭", "🥪", "🥓", "🥩", "🍖", "🍗", "🥚"],
      ["🍤", "🍣", "🍱", "🍛", "🍜", "🍝", "🍠", "🍢", "🍘", "🍡"],
      ["🍩", "🍪", "🍰", "🧁", "🥧", "🍫", "🍬", "🍭", "🍮", "🎂"],
      ["🎃", "🎄", "🎅", "🎁", "🎀", "🎉", "🎊", "🎈", "🛍️", "🧸"],
      ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯"],
      ["🐘", "🦏", "🦛", "🦒", "🐪", "🐫", "🦘", "🐃", "🐂", "🐄"],
      ["🐟", "🐠", "🐡", "🦈", "🐬", "🐳", "🐋", "🦐", "🦑", "🐙"],
      ["🌺", "🌻", "🌼", "🌸", "💐", "🍁", "🍂", "🍃", "🍀", "🌷"],
  ]
  
  static func getRandomEmojis(number: Int) -> [String] {
      // Pick a random row
    let row = Int.random(in: 0..<MatrixEquation.emojiGroups.count)
      let emojisInRow = self.emojiGroups[row]
      let rowSize = emojisInRow.count
      // If x is greater than the row size, return the whole row
      if number >= rowSize {
          return emojisInRow.shuffled()
      }
      // Otherwise, randomly pick x emojis from the row without replacement
      var selectedEmojis: [String] = []
      var indices = Array(0..<rowSize)
      for _ in 0..<number {
          let randomIndex = indices.randomElement()!
          selectedEmojis.append(emojisInRow[randomIndex])
          indices.remove(at: indices.firstIndex(of: randomIndex)!)
      }
      return selectedEmojis
  }


  static func getRandomInteger(
    maxVal: Int,
    minVal: Int,
    allowNegative: Bool,
    allowZero: Bool
  ) -> Int {
    let maxValSafe = max(maxVal, minVal)
    let minValSafe = min(maxVal, minVal)
    if allowNegative && allowZero {
      return Int.random(in: minValSafe...maxValSafe)
    } else if allowNegative && !allowZero {
      if (minValSafe > 0) || (maxValSafe < 0) {
        return Int.random(in: minValSafe...maxValSafe)
      } else {
        let pos = Int.random(in: 1...maxValSafe)
        let neg = Int.random(in: minValSafe...(-1))
        return [pos, neg].randomElement()!
      }
    } else if !allowNegative && allowZero {
      return Int.random(in: 0...maxValSafe)
    } else {
      return Int.random(in: 1...maxValSafe)
    }
  }
  
  static func det(matrix: [[Int]]) -> Double {
    let numRows = matrix.count
    guard numRows > 0 else { return 0.0 }
    if numRows == 1 {
      return Double(matrix.first!.first!)
    }
    var result = 0.0
    for (j, col) in matrix.first!.enumerated() {
      let submatrix = matrix.dropFirst().map { row in row.enumerated().filter { $0.offset != j }.map { $0.element } }
      result += (j % 2 == 0 ? 1.0 : -1.0) * Double(col) * det(matrix: Array(submatrix))
    }
    return result
  }
  
  static func hasZeroSumRows(matrix: [[Int]]) -> Bool {
    // Checks if any of the row sums of a matrix is 0.
      for row in matrix {
          if row.reduce(0, +) == 0 {
              return true
          }
      }
      return false
  }
  
  static func hasSimilarRows(matrix: [[Int]]) -> Bool {
      var rowSet = Set<[Int]>()
      for row in matrix {
          let negatedRow = row.map { -$0 }
          if rowSet.contains(row) || rowSet.contains(negatedRow) {
              return true
          }
          rowSet.insert(row)
      }
      return false
  }
  
  static func mixGuesses(correct: [Int], wrong: [[Int]]) -> (Choices: [[Int]], correctIndices: [Int]) {
      var Choices: [[Int]] = []
      var correctIndices: [Int] = []
      for (index, correctValue) in correct.enumerated() {
          var combinedRow = wrong[index] + [correctValue]
          combinedRow.shuffle()
          Choices.append(combinedRow)
          if let correctIndex = combinedRow.firstIndex(of: correctValue) {
              correctIndices.append(correctIndex)
          }
      }

      return (Choices, correctIndices)
  }
  
  static func generateMatrixAndVectors(numRows: Int, numCols: Int, maxM: Int, maxB: Int, maxX: Int, allowNegative: Bool, allowZero: Bool) -> (M: [[Int]], x: [Int], b: [Int], WrongAnswers: [[Int]]) {
    var M = Array(repeating: Array(repeating: 0, count: numCols), count: numRows)
    var x = Array(repeating: 0, count: numCols)
    var b = Array(repeating: 0, count: numRows)
    
    for i in 0..<numCols {
      x[i] = getRandomInteger(maxVal: maxX, minVal: -maxX, allowNegative: allowNegative, allowZero: allowZero)
    }
    
    for i in 0..<numCols {
      for j in 0..<numCols {
        M[i][j] = getRandomInteger(maxVal: maxM, minVal: -maxM, allowNegative: allowNegative, allowZero: allowZero)
      }
      while true {
        b[i] = zip(M[i], x).map(*).reduce(0, +)
        if abs(b[i]) <= maxB {
          break
        } else {
          for j in 0..<numCols {
            M[i][j] = getRandomInteger(maxVal: maxM, minVal: -maxM, allowNegative: allowNegative, allowZero: allowZero)
          }
        }
      }
    }
    
    for i in numCols..<numRows {
      for j in 0..<numCols {
        let mult = [-1, 0, 1].randomElement()!
        M[i] = M[i].enumerated().map { $0.element + M[j][$0.offset] * mult }
        b[i] += b[j] * mult
      }
    }
    
    var M2: [[Int]] = Array(repeating: Array(repeating: 0, count: numCols), count: numCols)
    
    for i in 0..<numCols {
      for j in 0..<numCols {
        M2[i][j] = M[i][j]
      }
    }
    
    for i in 0..<numCols {
      M2[i][numCols-1] -= b[i]
    }
    
    let M2_det = det(matrix: Array(M2))
    
    let guesses = 3
    var WrongAnswers = Array(repeating: Array(repeating: 0, count: guesses), count: numCols)
    for i in 0..<numCols {
      for j in 0..<guesses {
        var randomInt: Int = 0
        while true {
          randomInt = getRandomInteger(maxVal: maxX + 4, minVal: -maxX, allowNegative: allowNegative, allowZero: allowZero)
          if randomInt != x[i] {
            break
          }
        }
        WrongAnswers[i][j] = randomInt
        }
      }
    
    let cond1 = abs(M2_det) < 1e-10
    let cond2 = hasZeroSumRows(matrix: M)
    let cond3 = hasSimilarRows(matrix: M)
    print("cond1", cond1)
    print("cond2", cond2)
    print("cond3", cond3)
    print("--------------")
    if cond1 || cond2 || cond3 {
      return generateMatrixAndVectors(numRows: numRows, numCols: numCols, maxM: maxM, maxB: maxB, maxX: maxX, allowNegative: allowNegative, allowZero: allowZero)
    } else {
      return (M, x, b, WrongAnswers)
    }
  }
}
