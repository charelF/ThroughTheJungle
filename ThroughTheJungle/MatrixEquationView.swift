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
  @Published var clickedIndices: [Int] = [-1,-1,-1,-1]
  
  let rowCount: Int
  let buttonCount: Int

  init(rowCount: Int, buttonCount: Int) {
    self.rowCount = rowCount
    self.buttonCount = buttonCount
    rowHasBeenClicked = Array(repeating: false, count: rowCount)
    buttonColor = Array(repeating: Array(repeating: Color.clear, count: buttonCount), count: rowCount)
  }
  
  func reset() {
    rowHasBeenClicked = Array(repeating: false, count: rowCount)
    buttonColor = Array(repeating: Array(repeating: Color.clear, count: buttonCount), count: rowCount)
    clickedIndices = [-1,-1,-1,-1]
  }
}

  struct MatrixEquationView: View {

    let matrixEquation: MatrixEquation
    @ObservedObject var gameState: MatrixEquationGameState
    @Binding var checkState: CheckState
    
    init(checkState: Binding<CheckState>, matrixEquation: MatrixEquation) {
      self._checkState = checkState
      self.matrixEquation = matrixEquation
      gameState = MatrixEquationGameState(rowCount: matrixEquation.numCols, buttonCount: 4)
    }


    func formattedEquation(row: Int) -> String {
      var equation = ""
      for (j, coeff) in matrixEquation.M[row].enumerated() {
        print(j,coeff)
        if coeff == 0 { continue }

        let emoji = matrixEquation.emojis[j]
        let sign = coeff > 0 ? (equation.isEmpty ? "" : " + ") : " - "
        let absCoeff = abs(coeff)

        if absCoeff == 1 {
          equation += sign + emoji
        } else {
          equation += sign + "\(absCoeff)" + emoji
        }
      }
      equation += " = \(matrixEquation.b[row])"
      return equation
    }

    func formattedButtonTitle(value: Int, emoji: String) -> String {
      return "\(emoji) = \(value)"
    }

    func handleGuess(rowIndex: Int, colIndex: Int) {
      gameState.clickedIndices[rowIndex] = colIndex


      let correctColIndex = matrixEquation.correctIndices[rowIndex]
//      if colIndex == correctColIndex {
//        gameState.buttonColor[rowIndex][colIndex] = Color.green.opacity(0.5)
//      } else {
//        gameState.buttonColor[rowIndex][colIndex] = Color.red
//        gameState.buttonColor[rowIndex][correctColIndex] = Color.green.opacity(0.5)
//      }
      for i in 0..<gameState.buttonColor[rowIndex].count {
        if (i == colIndex) { continue }
        gameState.buttonColor[rowIndex][i] = Color.secondary.opacity(0.5)
      }
      gameState.rowHasBeenClicked[rowIndex].toggle()
    }


    var body: some View {
      VStack(alignment: .center) {
        VStack(alignment: .trailing) {
          ForEach(0..<matrixEquation.M.count, id: \.self) { row in
            Text(formattedEquation(row: row))
              .font(.system(.title, design: .rounded))
              .bold()
          }
        }

        VStack(alignment: .center) {
          ForEach(Array(matrixEquation.Choices.enumerated()), id: \.offset) { rowIndex, row in
            HStack {
              ForEach(Array(row.enumerated()), id: \.offset) { colIndex, item in
                Button(action: {handleGuess(rowIndex: rowIndex, colIndex: colIndex)}, label: {
                  Text(formattedButtonTitle(value: item, emoji: matrixEquation.emojis[rowIndex]))
                    .font(.system(.title2, design: .rounded))
                    .bold()
                    .foregroundColor(Color.primary)
                })
                .buttonStyle(.bordered)
                .disabled(gameState.rowHasBeenClicked[rowIndex])
                .background(gameState.buttonColor[rowIndex][colIndex])
                .cornerRadius(5)
              }
            }
          }
        }

//        Text(String(describing: gameState.clickedIndices))
//        Text(String(describing: matrixEquation.correctIndices))


        CheckView(cond: {gameState.clickedIndices == matrixEquation.correctIndices}, checkState: $checkState)
          .onTapGesture(perform: gameState.reset)
      }
      .navigationBarBackButtonHidden(checkState != .solved)
    }
  }




//struct MatrixEquationView_Previews: PreviewProvider {
//    static var previews: some View {
//        MatrixEquationView()
//    }
//}

