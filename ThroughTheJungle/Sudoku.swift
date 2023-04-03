//
//  Sudoku.swift
//  Sudoku
//
//  Created by Charel Felten on 02/04/2023.
//  Copyright © 2023 Self. All rights reserved.
//

import Foundation


class Sudoku {
  
  func getRandomNonZeroInteger(maxval: Int, minval: Int) -> Int {
      let maxvalsafe = max(maxval, minval)
      let minvalsafe = min(maxval, minval)
      if (minvalsafe > 0) || (maxvalsafe < 0) {
          return Int.random(in: minvalsafe...maxvalsafe)
      } else {
          let pos = Int.random(in: 1...maxvalsafe)
          let neg = Int.random(in: minvalsafe...(-1))
          return [pos, neg].randomElement()!
      }
  }
  
}
