//
//  ShapeCalculation.swift
//  ThroughTheJungle
//
//  Created by Charel Felten on 26/03/2023.
//

import Foundation


class MatrixEquation {
  
  
  let emojiGroups: [[String]] = [
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
  
  func getRandomEmojis(x: Int) -> [String] {
      // Pick a random row
    let row = Int.random(in: 0..<self.emojiGroups.count)
      let emojisInRow = self.emojiGroups[row]
      let rowSize = emojisInRow.count
      
      // If x is greater than the row size, return the whole row
      if x >= rowSize {
          return emojisInRow.shuffled()
      }
      
      // Otherwise, randomly pick x emojis from the row without replacement
      var selectedEmojis: [String] = []
      var indices = Array(0..<rowSize)
      for _ in 0..<x {
          let randomIndex = indices.randomElement()!
          selectedEmojis.append(emojisInRow[randomIndex])
          indices.remove(at: indices.firstIndex(of: randomIndex)!)
      }
      return selectedEmojis
  }

  
  
  
  func getRandomNonZeroInteger(maxval: Int, minval: Int) -> Int {
    let maxvalSafe = max(maxval, minval)
    let minvalSafe = min(maxval, minval)
    if (minvalSafe > 0) || (maxvalSafe < 0) {
      return Int.random(in: minvalSafe...maxvalSafe)
    } else {
      let pos = Int.random(in: 1...maxvalSafe)
      let neg = Int.random(in: minvalSafe...(-1))
      return [pos, neg].randomElement()!
    }
  }
  
  func getRandomInteger(maxval: Int, minval: Int) -> Int {
    let maxvalSafe = max(maxval, minval)
    let minvalSafe = min(maxval, minval)
    return Int.random(in: minvalSafe...maxvalSafe)
  }
  
  func det(matrix: [[Int]]) -> Double {
    let n = matrix.count
    guard n > 0 else { return 0.0 }
    if n == 1 {
      return Double(matrix.first!.first!)
    }
    var result = 0.0
    for (j, col) in matrix.first!.enumerated() {
      let submatrix = matrix.dropFirst().map { row in row.enumerated().filter { $0.offset != j }.map { $0.element } }
      result += (j % 2 == 0 ? 1.0 : -1.0) * Double(col) * det(matrix: Array(submatrix))
    }
    return result
  }
  
  func hasZeroSumRows(matrix: [[Int]]) -> Bool {
    // Checks if any of the row sums of a matrix is 0.
      for row in matrix {
          if row.reduce(0, +) == 0 {
              return true
          }
      }
      return false
  }
  
  func checkDuplicateRowsOrOpposite(matrix: [[Int]]) -> Bool {
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
  
  func mixGuesses(correct: [Int], wrong: [[Int]]) -> (Choices: [[Int]], correctIndices: [Int]) {
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
  
  func generateMatrixAndVectors(n: Int, m: Int, maxval_M: Int, maxval_b: Int, maxval_x: Int) -> (M: [[Int]], x: [Int], b: [Int], c: [[Int]]) {
    var M = Array(repeating: Array(repeating: 0, count: m), count: n)
    var x = Array(repeating: 0, count: m)
    var b = Array(repeating: 0, count: n)
    
    for i in 0..<m {
      x[i] = getRandomNonZeroInteger(maxval: maxval_x, minval: -maxval_x)
    }
    
    for i in 0..<m {
      for j in 0..<m {
        M[i][j] = getRandomNonZeroInteger(maxval: maxval_M, minval: -maxval_M)
      }
      while true {
        b[i] = zip(M[i], x).map(*).reduce(0, +)
        if abs(b[i]) <= maxval_b {
          break
        } else {
          for j in 0..<m {
            M[i][j] = getRandomNonZeroInteger(maxval: maxval_M, minval: -maxval_M)
          }
        }
      }
    }
    
    for i in m..<n {
      for j in 0..<m {
        let mult = [-1, 0, 1].randomElement()!
        M[i] = M[i].enumerated().map { $0.element + M[j][$0.offset] * mult }
        b[i] += b[j] * mult
      }
    }
    
    var M2: [[Int]] = Array(repeating: Array(repeating: 0, count: m), count: m)
    
    for i in 0..<m {
      for j in 0..<m {
        M2[i][j] = M[i][j]
      }
    }
    
    for i in 0..<m {
      M2[i][m-1] -= b[i]
    }
    
    let M2_det = det(matrix: Array(M2))
    
    let guesses = 3
    var c = Array(repeating: Array(repeating: 0, count: guesses), count: m)
    for i in 0..<m {
      for j in 0..<guesses {
        var randomInt: Int = 0
        while true {
          randomInt = getRandomInteger(maxval: maxval_x + 2, minval: -maxval_x - 2)
          if randomInt != x[i] {
            break
          }
        }
        c[i][j] = randomInt
        }
      }
    
    if (abs(M2_det) < 1e-10) || hasZeroSumRows(matrix: M) || checkDuplicateRowsOrOpposite(matrix: M) {
      return generateMatrixAndVectors(n: n, m: m, maxval_M: maxval_M, maxval_b: maxval_b, maxval_x: maxval_x)
    } else {
      return (M, x, b, c)
    }
  }
}
