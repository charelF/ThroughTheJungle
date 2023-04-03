//
//  ShapeCalculationView.swift
//  ThroughTheJungle
//
//  Created by Charel Felten on 26/03/2023.
//


import SwiftUI
import Combine


class MatrixEquationGameState: ObservableObject {
  @Published var rowHasBeenClicked: [Bool]
  @Published var buttonColor: [[Color]]
  
  init(rowCount: Int, buttonCount: Int) {
    rowHasBeenClicked = Array(repeating: false, count: rowCount)
    buttonColor = Array(repeating: Array(repeating: Color.clear, count: buttonCount), count: rowCount)
  }
}
  
  struct MatrixEquationView: View {
    
    var M: [[Int]]
    var b: [Int]
    var x: [Int]
    var e: [String]
    var C: [[Int]]
    var W: [[Int]]
    var correctIndices: [Int]
    @ObservedObject var gameState: MatrixEquationGameState
    
    init() {
      let matrixEquation = MatrixEquation()
      (M,x,b,C) = matrixEquation.generateMatrixAndVectors(n: 2, m: 2, maxval_M: 2, maxval_b: 20, maxval_x: 5)
      e = matrixEquation.getRandomEmojis(x: x.count)
      (W, correctIndices) = matrixEquation.mixGuesses(correct: x, wrong: C)
//      print(x)
//      print(correctIndices)
//      print(W)
      gameState = MatrixEquationGameState(rowCount: x.count, buttonCount: 4)
    }
    
    
    func formattedEquation(row: Int) -> String {
      var equation = ""
      for (j, coeff) in M[row].enumerated() {
        print(j,coeff)
        if coeff == 0 { continue }
        
        let emoji = e[j]
        let sign = coeff > 0 ? (equation.isEmpty ? "" : " + ") : " - "
        let absCoeff = abs(coeff)
        
        if absCoeff == 1 {
          equation += sign + emoji
        } else {
          equation += sign + "\(absCoeff)" + emoji
        }
      }
      equation += " = \(b[row])"
      return equation
    }
    
    func formattedButtonTitle(value: Int, emoji: String) -> String {
      return "\(emoji) = \(value)"
    }
    
    func handleGuess(rowIndex: Int, colIndex: Int) {
      let correctColIndex = correctIndices[rowIndex]
      if colIndex == correctColIndex {
        gameState.buttonColor[rowIndex][colIndex] = Color.green.opacity(0.5)
      } else {
        gameState.buttonColor[rowIndex][colIndex] = Color.red
        gameState.buttonColor[rowIndex][correctColIndex] = Color.green.opacity(0.5)
      }
      for i in 0..<gameState.buttonColor[rowIndex].count {
        if (i == colIndex) || (i == correctColIndex) { continue }
        gameState.buttonColor[rowIndex][i] = Color.secondary.opacity(0.5)
      }
      gameState.rowHasBeenClicked[rowIndex].toggle()
    }
    
    
    var body: some View {
      VStack(alignment: .center) {
        VStack {
          ForEach(0..<M.count, id: \.self) { row in
            Text(formattedEquation(row: row))
              .font(.system(.title, design: .rounded))
              .bold()
              .frame(alignment: .trailing)
          }
        }
        
        VStack(alignment: .center) {
          ForEach(Array(W.enumerated()), id: \.offset) { rowIndex, row in
            HStack {
              ForEach(Array(row.enumerated()), id: \.offset) { colIndex, item in
                Button(action: {handleGuess(rowIndex: rowIndex, colIndex: colIndex)}, label: {
                  Text(formattedButtonTitle(value: item, emoji: e[rowIndex]))
                    .font(.system(.callout, design: .rounded))
                    .bold() 
                    .foregroundColor(Color.black)
                })
                .buttonStyle(.bordered)
                .disabled(gameState.rowHasBeenClicked[rowIndex])
                .background(gameState.buttonColor[rowIndex][colIndex])
                .cornerRadius(5)
              }
            }
          }
        }
      }
    }
  }




struct MatrixEquationView_Previews: PreviewProvider {
    static var previews: some View {
        MatrixEquationView()
    }
}

