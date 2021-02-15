import UIKit
import ComposableArchitecture

public struct GameState: Equatable {
    public var boardSize: BoardSize = .four
    public var board: [String] = []
    public var words: [String] = []
    public var currentWord: [Int] = []
    public var score: Int = 0
    
    public init(
        boardSize: BoardSize = .four,
        board: [String] = [],
        words: [String] = [],
        currentWord: [Int] = [],
        score: Int = 0
    ) {
        self.boardSize = boardSize
        self.board = board
        self.words = words
        self.currentWord = currentWord
        self.score = score
    }
}

public enum GameAction: Equatable {
    case newGameTapped(BoardSize)
    case exitGameTapped
    case letterSelected(Int)
    case submitWordTapped
    case resetWordTapped
}

public enum BoardSize: Int, Equatable {
    case three = 3
    case four = 4
    case five = 5
}

public struct GameEnvironment {
    let newBoard: (BoardSize) -> [String]
    let isValidWord: (String) -> Bool
}

enum SelectionValidity {
    case valid
    case notTouching
    case alreadyUsed
    case outOfBounds
}

extension BoardSize {
    func selectionCoords(selection: Int) -> (col: Int, row: Int) {
        let col = selection % self.rawValue
        let row = Int(floor(Double(selection / self.rawValue)))
        return (col, row)
    }
}

func isAdjacentTo(lastLetter: Int, selection: Int, boardSize: BoardSize) -> Bool {
    let (col, row) = boardSize.selectionCoords(selection: selection)
    
    let (pCol, pRow) = boardSize.selectionCoords(selection: lastLetter)
    
    return
        pCol - 1 <= col && col <= pCol + 1 &&
        pRow - 1 <= row && row <= pRow + 1
}

func isSelectionValid(boardSize: BoardSize, currentWord: [Int], selection: Int) -> SelectionValidity {
    if currentWord == [] {
        return .valid
    }
    
    if let lastLetter = currentWord.last,
       lastLetter == selection {
        return .valid
    }
    
    if selection < 0 || boardSize.rawValue * boardSize.rawValue - 1 < selection {
        return .outOfBounds
    }
    
    if let lastLetter = currentWord.last,
       !isAdjacentTo(lastLetter: lastLetter, selection: selection, boardSize: boardSize) {
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
    case let .newGameTapped(boardSize):
        state.boardSize = boardSize
        state.board = environment.newBoard(boardSize)
        state.score = 0
        state.currentWord = []
        state.words = []
        return .none
        
    case let .letterSelected(selection):
        let validity = isSelectionValid(
            boardSize: state.boardSize,
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
        
    case .exitGameTapped:
        state.board = []
        return .none
    }
}

extension BoardSize {
    var dice: [[String]] {
        switch self {
        case .four:
            return [
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
        case .five:
            return [
                ["A", "A", "A", "F", "R", "S"],
                ["A", "A", "E", "E", "E", "E"],
                ["A", "A", "F", "I", "R", "S"],
                ["A", "D", "E", "N", "N", "N"],
                ["A", "E", "E", "E", "E", "M"],
                ["A", "E", "E", "G", "M", "U"],
                ["A", "E", "G", "M", "N", "N"],
                ["A", "F", "I", "R", "S", "Y"],
                ["B", "J", "K", "QU", "X", "Z"],
                ["C", "C", "E", "N", "S", "T"],
                ["C", "E", "I", "I", "L", "T"],
                ["C", "E", "I", "L", "P", "T"],
                ["C", "E", "I", "P", "S", "T"],
                ["D", "D", "H", "N", "O", "T"],
                ["D", "H", "H", "L", "O", "R"],
                ["D", "H", "L", "N", "O", "R"],
                ["D", "H", "L", "N", "O", "R"],
                ["E", "I", "I", "I", "T", "T"],
                ["E", "M", "O", "T", "T", "T"],
                ["E", "N", "S", "S", "S", "U"],
                ["F", "I", "P", "R", "S", "Y"],
                ["G", "O", "R", "R", "V", "W"],
                ["I", "P", "R", "R", "R", "Y"],
                ["N", "O", "O", "T", "U", "W"],
                ["O", "O", "O", "T", "T", "U"],
            ]
        default:
            return []
        }
    }
}

public extension GameEnvironment {
    static let live = GameEnvironment(
        newBoard:  {
            $0.dice.compactMap { $0.randomElement() }
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
