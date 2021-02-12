import SwiftUI
import ComposableArchitecture
import BoggleEngine

struct ContentView: View {
    let store: Store<GameState, GameAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            if viewStore.board.count == 0 {
                Button("Start Game") {
                    viewStore.send(.newGameTapped)
                }
            } else {
                VStack {
                    Button("New Game") {
                        viewStore.send(.newGameTapped)
                    }
                    .padding()
                    LazyVGrid(
                        columns: [GridItem(.fixed(80)), GridItem(.fixed(80)), GridItem(.fixed(80)), GridItem(.fixed(80))],
                        alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                        ForEach(0 ..< 16) { i in
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
        .frame(width: 80, height: 80, alignment: .center)
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
