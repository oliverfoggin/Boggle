import SwiftUI
import ComposableArchitecture
import BoggleEngine
import Foundation

struct ContentView: View {
    let store: Store<GameState, GameAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            if viewStore.board.count == 0 {
                VStack {
                    Button("Start 4x4 Game") { viewStore.send(.newGameTapped(.four)) }
                        .padding()
                    Button("Start 5x5 Game") { viewStore.send(.newGameTapped(.five)) }
                        .padding()
                }
            } else {
                VStack {
                    Button("Exit Game") { viewStore.send(.exitGameTapped) }
                    .padding()
                    LazyVGrid(
                        columns: Array.init(repeating: GridItem(.fixed(70)), count: (viewStore.boardSize == .four ? 4 : 5)),
                        alignment: .center) {
                        ForEach(0 ..< viewStore.board.count) { i in
                            LetterCell(
                                letter: viewStore.board[i],
                                partOfWord: viewStore.currentWord.contains(i),
                                action: { viewStore.send(.letterSelected(i)) }
                            )
                        }
                    }
                    Text("\(viewStore.currentWord.map { viewStore.board[$0] }.joined())")
                        .padding()
                    HStack(spacing: 20) {
                        Button("Submit word") { viewStore.send(.submitWordTapped) }
                        Button("Clear word") { viewStore.send(.resetWordTapped) }
                    }
                    .padding()
                    HStack {
                        VStack {
                            Text("Last three words...")
                            if viewStore.words.count >= 1 {
                                Text("\(viewStore.words.reversed()[0])")
                            }
                            if viewStore.words.count >= 2 {
                                Text("\(viewStore.words.reversed()[1])")
                            }
                            if viewStore.words.count >= 3 {
                                Text("\(viewStore.words.reversed()[2])")
                            }
                        }
                        Text("Score: \(viewStore.score)")
                            .padding()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct LetterCell: View {
    let letter: String
    let partOfWord: Bool
    let action: () -> Void
    
    var body: some View {
        ZStack {
            self.partOfWord ? Color.purple : Color.gray
            Text("\(letter)")
                .foregroundColor(.black)
                .font(Font.title.bold())
        }
        .aspectRatio(1, contentMode: .fill)
        .onTapGesture(perform: action)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: GameState(),
                reducer: gameReducer,
                environment: .live
            )
        )
    }
}
