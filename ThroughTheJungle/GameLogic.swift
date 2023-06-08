//
//  GameLogic.swift
//  ThroughTheJungle
//
//  Created by Charel Felten on 07/06/2023.
//

import Foundation


class Logic {
  var numberSequenceList: [NumberSequence] = []
  var matrixEquationList: [MatrixEquation] = []
  let levels = 30
  
  init() {
    for _ in 0...30 {
      let ns = NumberSequence()
      self.numberSequenceList.append(ns)
      
      let me = MatrixEquation(
        numRows: 4,
        numCols: 4,
        maxM: 2,
        maxB: 50, // if allowNegative and allowZero, b needs to be high enough
        maxX: 10,
        allowNegative: false,
        allowZero: true
      )
      self.matrixEquationList.append(me)
    }
  }
}




