import UIKit
import ComposableArchitecture

public struct GameState: Equatable {
    public var board: [String] = []
    public var words: [String] = []
    public var currentWord: [Int] = []
    public var score: Int = 0
    
    public init(
        board: [String] = [],
        words: [String] = [],
        currentWord: [Int] = [],
        score: Int = 0
    ) {
        self.board = board
        self.words = words
        self.currentWord = currentWord
        self.score = score
    }
}

public enum GameAction: Equatable {
    case newGameTapped
    case letterSelected(Int)
    case submitWordTapped
    case resetWordTapped
}

public struct GameEnvironment {
    let newBoard: () -> [String]
    let isValidWord: (String) -> Bool
}

enum SelectionValidity {
    case valid
    case notTouching
    case alreadyUsed
    case outOfBounds
}

func isAdjacentTo(lastLetter: Int, selection: Int, width: Int) -> Bool {
    return
        selection == lastLetter + 1 ||
        selection == lastLetter - 1 ||
        selection == lastLetter + width ||
        selection == lastLetter - width ||
        selection == lastLetter + width + 1 ||
        selection == lastLetter + width - 1 ||
        selection == lastLetter - width + 1 ||
        selection == lastLetter - width - 1
}

func isSelectionValid(boardSize: Int, currentWord: [Int], selection: Int) -> SelectionValidity {
    if currentWord == [] {
        return .valid
    }
    
    if let lastLetter = currentWord.last,
       lastLetter == selection {
        return .valid
    }
    
    if selection < 0 || boardSize - 1 < selection {
        return .outOfBounds
    }
    
    if let lastLetter = currentWord.last,
       case let width = Int(sqrt(Double(boardSize))),
       !isAdjacentTo(lastLetter: lastLetter, selection: selection, width: width) {
        return .notTouching
    }
    
    if currentWord.dropLast().contains(selection) {
        return .alreadyUsed
    }
    
    return .valid
}

func score(word: String) -> Int {
    switch word.count {
    case ...2:
        return 0
    case 3...4:
        return 1
    case 5:
        return 2
    case 6:
        return 3
    case 7:
        return 5
    case 8...:
        return 11
    default:
        fatalError("How did you get here?")
    }
}

public let gameReducer = Reducer<GameState, GameAction, GameEnvironment> { state, action, environment in
    switch action {
    case .newGameTapped:
        state.board = environment.newBoard()
        state.score = 0
        state.currentWord = []
        state.words = []
        return .none
        
    case let .letterSelected(selection):
        let validity = isSelectionValid(
            boardSize: state.board.count,
            currentWord: state.currentWord,
            selection: selection
        )
        
        guard validity == .valid else {
            return .none
        }
        
        if let lastLetter = state.currentWord.last,
           lastLetter == selection {
            _ = state.currentWord.removeLast()
        } else {
            state.currentWord.append(selection)
        }
        return .none
        
    case .submitWordTapped:
        let word = state.currentWord.map {
            state.board[$0]
        }.joined()
        
        if !state.words.contains(word),
           environment.isValidWord(word) {
            state.words.append(word)
            state.currentWord = []
            state.score += score(word: word)
        }
        
        return .none
        
    case .resetWordTapped:
        state.currentWord = []
        return .none
    }
}

public extension GameEnvironment {
    static let live = GameEnvironment(
        newBoard:  {
            [
                ["A", "A", "E", "E", "G", "N"],
                ["E", "L", "R", "T", "T", "Y"],
                ["A", "O", "O", "T", "T", "W"],
                ["A", "B", "B", "J", "O", "O"],
                ["E", "H", "R", "T", "V", "W"],
                ["C", "I", "M", "O", "T", "U"],
                ["D", "I", "S", "T", "T", "Y"],
                ["E", "I", "O", "S", "S", "T"],
                ["D", "E", "L", "R", "V", "Y"],
                ["A", "C", "H", "O", "P", "S"],
                ["H", "I", "M", "N", "QU", "U"],
                ["E", "E", "I", "N", "S", "U"],
                ["E", "E", "G", "H", "N", "W"],
                ["A", "F", "F", "K", "P", "S"],
                ["H", "L", "N", "N", "R", "Z"],
                ["D", "E", "I", "L", "R", "X"],
            ]
            .compactMap { $0.randomElement() }
            .shuffled()
        },
        isValidWord: { word in
            guard word.count >= 3 else {
                return false
            }
            
            return wordList.contains(word.lowercased())
        }
    )
}
