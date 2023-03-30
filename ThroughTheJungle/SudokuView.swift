//
//  SudokuView.swift
//  ThroughTheJungle
//
//  Created by Charel Felten on 29/03/2023.
//

import SwiftUI

struct SudokuView: View {
  
  var sudoku: [[[Int]]] = []
  
  func getSudoku() -> [[[Int]]] {
    var array: [[[Int]]] = []
    for rowIdx in 0..<9 {
      var row: [[Int]] = []
      for colIdx in 0..<9 {
        let randomNumber = Int.random(in: 0...9)
        let a = floor(Float16(rowIdx) / 3)
        let b = floor(Float16(colIdx) / 3)
        let blockIdx = Int(a * 3 + b)
        row.append([
          randomNumber,
          rowIdx,
          colIdx,
          blockIdx
        ])
      }
      array.append(row)
    }
    return array
  }
  
  init() {
    sudoku = getSudoku()
  }

  var body: some View {
    VStack {
      Button(action: {/* TODO */}) {
          Text("New game")
              .font(.system(.headline, design: .rounded))
      }
      .buttonStyle(.bordered)
      SudokuGridView(sudoku: sudoku)
      
    }
  }
}

struct SudokuGridView: View {
  
  var sudoku: [[[Int]]]

  @ObservedObject var selection: Selection = Selection()
  
  func getWidth(idx: Int) -> CGFloat {
    if (idx != 0) && (idx % 3 == 0) {
      return 4
    } else {
      return 1
    }
  }
  
  func getCorrection(idx: Int) -> CGFloat {
    if (idx != 0) && (idx % 3 == 0) {
      return 0
    } else {
      return 0
    }
  }
  
  var body: some View {
    Grid(horizontalSpacing: 0, verticalSpacing: 0) {
      ForEach(Array(sudoku.enumerated()), id: \.offset) { rowIdx, row in
        GridRow {
          ForEach(Array(row.enumerated()), id: \.offset) { colIdx, tuple in
            CellView(tuple: tuple, selection: selection)
            .padding(.leading, getWidth(idx: colIdx))
            .border(
              width: getWidth(idx: colIdx),
              edges: [.leading],
              color: Color.black
            )
          }
        }
        .padding(.top, getWidth(idx: rowIdx))
        .border(
          width: getWidth(idx: rowIdx),
          edges: [.top],
          color: Color.black
        )
      }
    }
    
    .padding(5)
    .border(Color.black, width: 5)
    .padding(5)
    
  }
}

class Selection: ObservableObject {
    @Published var rowIdx: Int?
    @Published var colIdx: Int?
    @Published var blockIdx: Int?
}

struct CellView: View {
  @State var tuple: [Int]
  @ObservedObject var selection: Selection
  @Environment(\.colorScheme) var colorScheme
//  @State var note: String = "12348"
  
  var fontColor: Color {
    if colorScheme == .light {
      return Color.black
    } else {
      return Color.white
    }
  }
  
  var isRelevant: Bool {
      selection.rowIdx == tuple[1] ||
      selection.colIdx == tuple[2] ||
      selection.blockIdx == tuple[3]
  }
  
  var isSelected: Bool {
    selection.rowIdx == tuple[1] &&
    selection.colIdx == tuple[2] &&
    selection.blockIdx == tuple[3]
  }
  
  var cellColor: Color {
    if isSelected {
      return Color.red
    } else if isRelevant {
      return Color.green
    } else {
      return Color.yellow
    }
  }
  
  func onTap() {
    if isSelected {
      selection.rowIdx = nil
      selection.colIdx = nil
      selection.blockIdx = nil
    } else {
      selection.rowIdx = tuple[1]
      selection.colIdx = tuple[2]
      selection.blockIdx = tuple[3]
    }
  }
  
  var cellContent: String {
    // using None would be cleaner but then we would
    // need to nil-check all other tuple entries aswell
    if tuple[0] == 0 {
      return ""
    } else {
      return String(tuple[0])
    }
  }
  
  // to store in the array:
  // - solution (should be 1 per square --> we need to ensure unique solution)
  // - possible guesses (multiple per square)
  // - idexes etc
  
  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(cellColor)
        .frame(width: 40, height: 40)
//        .overlay {
//          Text(cellContent == "" ? note : "")
//            .font(.system(.footnote, design: .rounded))
//            .lineSpacing(-10)
//            .foregroundColor(fontColor.opacity(0.5))
//        }
      
      
      Text(cellContent)
        .foregroundColor(fontColor)
        .font(.system(.title, design: .rounded))
        .bold()
        .backgroundStyle(cellColor)
    }
    .onTapGesture(perform: onTap)
    .contextMenu {
      VStack {
        Button(
          role: .destructive,
          action: {tuple[0] = 0},
          label: { Label("Delete", systemImage: "trash") }
        )
        Button(
          action: {tuple[0] = 0},
          label: { Label("Edit note", systemImage: "pencil") }
        )
      }
    }
  }
}

struct SudokuView_Previews: PreviewProvider {
    static var previews: some View {
        SudokuView()
    }
}























extension View {
  // from: https://stackoverflow.com/a/58632759/9439097
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return width
                case .leading, .trailing: return rect.height
                }
            }
            path.addRect(CGRect(x: x, y: y, width: w, height: h))
        }
        return path
    }
}
