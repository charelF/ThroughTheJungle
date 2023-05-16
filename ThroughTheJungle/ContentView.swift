//import SwiftUI
//
//struct ContentView: View {
//    @State private var tiles: [Tile] = [
//        Tile(id: 1, number: 3),
//        Tile(id: 2, number: 1),
//        Tile(id: 3, number: 2),
//        Tile(id: 4, number: 4)
//    ]
//
//    var body: some View {
//        VStack {
//            Spacer()
//            TileAreaView(tiles: tiles)
//                .padding()
//            Spacer()
//            HStack(spacing: 20) {
//                ForEach(tiles) { tile in
//                    DraggableTileView(tile: tile, tiles: $tiles)
//                }
//            }
//            Spacer()
//        }
//    }
//}
//
//struct TileAreaView: View {
//    var tiles: [Tile]
//
//    var body: some View {
//        VStack(spacing: 20) {
//            ForEach(0..<2) { i in
//                HStack(spacing: 20) {
//                    ForEach(0..<2) { j in
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.gray, lineWidth: 2)
//                            .frame(width: 50, height: 50)
//                            .position(x: 25 + CGFloat(j * 70), y: 25 + CGFloat(i * 70))
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct DraggableTileView: View {
//    @State private var dragOffset: CGSize = .zero
//    @State private var position: CGSize = .zero
//    var tile: Tile
//    @Binding var tiles: [Tile]
//
//    private func areAllTilesInCorrectPosition() -> Bool {
//        return tiles.allSatisfy { tile in
//            tile.isTileInCorrectPosition(position: tile.position)
//        }
//    }
//
//    var body: some View {
//        Text("\(tile.number)")
//            .frame(width: 50, height: 50)
//            .background(areAllTilesInCorrectPosition() && tile.isTileInCorrectPosition(position: position) ? Color.green : Color.red)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//            .shadow(radius: 5)
//            .offset(position)
//            .gesture(
//                DragGesture()
//                    .onChanged { value in
//                        dragOffset = value.translation
//                    }
//                    .onEnded { value in
//                        position.height += value.translation.height
//                        position.width += value.translation.width
//                        dragOffset = .zero
//                        if let index = tiles.firstIndex(where: { $0.id == tile.id }) {
//                            tiles[index].position = position
//                        }
//                    }
//            )
//    }
//}
//
//struct Tile: Identifiable {
//    let id: Int
//    let number: Int
//    var position: CGSize = .zero
//
//    func isTileInCorrectPosition(position: CGSize) -> Bool {
//        let targetX = 25 + CGFloat((number - 1) % 2) * 70
//        let targetY = 25 + CGFloat((number - 1) / 2) * 70
//
//        let distance = sqrt(pow(position.width - targetX, 2) + pow(position.height - targetY, 2))
//        return distance < 25
//    }
//}

//import SwiftUI
//
//struct ContentView: View {
//    @State private var isShowingNewView = false
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                self.isShowingNewView = true
//            }) {
//                Text("Open New View")
//                    .font(.headline)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//
//            NavigationLink(destination: NewView(), isActive: $isShowingNewView) {
//                EmptyView()
//            }
//            .hidden()
//        }
//    }
//}
//
//struct NewView: View {
//    var body: some View {
//        Text("This is a new view!")
//            .font(.largeTitle)
//            .foregroundColor(.black)
//    }
//}

import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Main View")
//                    .font(.largeTitle)
//
//                NavigationLink(destination: DetailView()) {
//                    Text(" 1 ")
//                        .font(.title)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(100)
//                }
//                .padding()
//            }
//            .navigationTitle("Nested Views")
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
//}
//
//struct DetailView: View {
//    var body: some View {
//        VStack {
//            Text("Detail View")
//                .font(.largeTitle)
//
//            NavigationLink(destination: SubDetailView()) {
//                Text("Open Sub Detail View")
//                    .font(.title)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//        }
//        .navigationTitle("Detail View")
//    }
//}
//
//struct SubDetailView: View {
//    var body: some View {
//        Text("Sub Detail View")
//            .font(.largeTitle)
//            .navigationTitle("Sub Detail View")
//    }
//}

struct ContentView: View {
@State var fruits: [String] = ["🍎", "🍊", "🍌", "🥝"]
var body: some View {
    NavigationStack {
        VStack(spacing: 20) {
            NavigationLink("Navigate: String Value", value: "New Page")
            
            NavigationLink("Navigate: Int Value", value: 1)
            
            ForEach(fruits, id:\.self) { fruit in
                NavigationLink(fruit, value: fruit)
            }
        }
        .navigationDestination(for: String.self) { value in
            Text("New screen")
            Text("Value is String -> \(value)")
        }
        .navigationDestination(for: Int.self) { value in
            Text("New screen")
            Text("Value is Integer -> \(value)")
        }
    }
}
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
