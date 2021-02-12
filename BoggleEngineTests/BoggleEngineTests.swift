import XCTest
import ComposableArchitecture
@testable import BoggleEngine

class BoggleEngineTests: XCTestCase {
    
    func testFirstWord() {
        let testStore = TestStore(
            initialState: GameState(),
            reducer: gameReducer,
            environment: GameEnvironment(
                newBoard: { [
                    "A", "B", "C",
                    "D", "E", "F",
                    "G", "H", "I"
                ] },
                isValidWord: { $0.count >= 3 }
            )
        )
        
        testStore.assert(
            .send(.newGameTapped) {
                $0.board = [
                    "A", "B", "C",
                    "D", "E", "F",
                    "G", "H", "I"
                ]
            },
            .send(.letterSelected(1)) {
                $0.currentWord = [1]
            },
            .send(.letterSelected(0)) {
                $0.currentWord = [1, 0]
            },
            .send(.letterSelected(8)),
            .send(.letterSelected(1)),
            .send(.letterSelected(0)) {
                $0.currentWord = [1]
            },
            .send(.submitWordTapped),
            .send(.letterSelected(0)) {
                $0.currentWord = [1, 0]
            },
            .send(.letterSelected(3)) {
                $0.currentWord = [1, 0, 3]
            },
            .send(.submitWordTapped) {
                $0.words = ["BAD"]
                $0.currentWord = []
                $0.score += 1
            },
            .send(.submitWordTapped),
            .send(.letterSelected(1)) {
                $0.currentWord = [1]
            },
            .send(.letterSelected(0)) {
                $0.currentWord = [1, 0]
            },
            .send(.letterSelected(3)) {
                $0.currentWord = [1, 0, 3]
            },
            .send(.submitWordTapped)
        )
    }
    
    func testInvalidWord() {
        let testStore = TestStore(
            initialState: GameState(
                board: [
                    "A", "B", "C",
                    "D", "E", "F",
                    "G", "H", "I"
                ],
                currentWord: [0, 1, 2, 3, 4, 5, 6, 7]
            ),
            reducer: gameReducer,
            environment: GameEnvironment.live
        )
        
        testStore.assert(
            .send(.submitWordTapped)
        )
    }
    
    func testResetWord() {
        let testStore = TestStore(
            initialState: GameState(
                board: [],
                currentWord: [0, 1, 2, 3, 4, 5, 6, 7]
            ),
            reducer: gameReducer,
            environment: GameEnvironment.live
        )
        
        testStore.assert(
            .send(.resetWordTapped) {
                $0.currentWord = []
            }
        )
    }
    
    func testScoring() {
        let testStore = TestStore(
            initialState: GameState(
                board: [
                    "H", "I", "J",
                    "A", "C", "K",
                    "E", "R", "S"
                ],
                currentWord: [0, 1, 2, 3, 4, 5, 6, 7, 8]
            ),
            reducer: gameReducer,
            environment: GameEnvironment(
                newBoard: { [] },
                isValidWord: { _ in true }
            )
        )
        
        testStore.assert(
            .send(.submitWordTapped) {
                $0.score += 11
                $0.currentWord = []
                $0.words = ["HIJACKERS"]
            },
            .send(.letterSelected(0)) {
                $0.currentWord.append(0)
            },
            .send(.letterSelected(1)) {
                $0.currentWord.append(1)
            },
            .send(.letterSelected(2)) {
                $0.currentWord.append(2)
            },
            .send(.submitWordTapped) {
                $0.score += 1
                $0.currentWord = []
                $0.words.append("HIJ")
            },
            .send(.letterSelected(0)) {
                $0.currentWord.append(0)
            },
            .send(.letterSelected(1)) {
                $0.currentWord.append(1)
            },
            .send(.letterSelected(2)) {
                $0.currentWord.append(2)
            },
            .send(.letterSelected(3)) {
                $0.currentWord.append(3)
            },
            .send(.submitWordTapped) {
                $0.score += 1
                $0.currentWord = []
                $0.words.append("HIJA")
            },
            .send(.letterSelected(0)) {
                $0.currentWord.append(0)
            },
            .send(.letterSelected(1)) {
                $0.currentWord.append(1)
            },
            .send(.letterSelected(2)) {
                $0.currentWord.append(2)
            },
            .send(.letterSelected(3)) {
                $0.currentWord.append(3)
            },
            .send(.letterSelected(4)) {
                $0.currentWord.append(4)
            },
            .send(.submitWordTapped) {
                $0.score += 2
                $0.currentWord = []
                $0.words.append("HIJAC")
            },
            .send(.letterSelected(0)) {
                $0.currentWord.append(0)
            },
            .send(.letterSelected(1)) {
                $0.currentWord.append(1)
            },
            .send(.letterSelected(2)) {
                $0.currentWord.append(2)
            },
            .send(.letterSelected(3)) {
                $0.currentWord.append(3)
            },
            .send(.letterSelected(4)) {
                $0.currentWord.append(4)
            },
            .send(.letterSelected(5)) {
                $0.currentWord.append(5)
            },
            .send(.submitWordTapped) {
                $0.score += 3
                $0.currentWord = []
                $0.words.append("HIJACK")
            },
            .send(.letterSelected(0)) {
                $0.currentWord.append(0)
            },
            .send(.letterSelected(1)) {
                $0.currentWord.append(1)
            },
            .send(.letterSelected(2)) {
                $0.currentWord.append(2)
            },
            .send(.letterSelected(3)) {
                $0.currentWord.append(3)
            },
            .send(.letterSelected(4)) {
                $0.currentWord.append(4)
            },
            .send(.letterSelected(5)) {
                $0.currentWord.append(5)
            },
            .send(.letterSelected(6)) {
                $0.currentWord.append(6)
            },
            .send(.submitWordTapped) {
                $0.score += 5
                $0.currentWord = []
                $0.words.append("HIJACKE")
            },
            .send(.letterSelected(0)) {
                $0.currentWord.append(0)
            },
            .send(.letterSelected(1)) {
                $0.currentWord.append(1)
            },
            .send(.letterSelected(2)) {
                $0.currentWord.append(2)
            },
            .send(.letterSelected(3)) {
                $0.currentWord.append(3)
            },
            .send(.letterSelected(4)) {
                $0.currentWord.append(4)
            },
            .send(.letterSelected(5)) {
                $0.currentWord.append(5)
            },
            .send(.letterSelected(6)) {
                $0.currentWord.append(6)
            },
            .send(.letterSelected(7)) {
                $0.currentWord.append(7)
            },
            .send(.submitWordTapped) {
                $0.score += 11
                $0.currentWord = []
                $0.words.append("HIJACKER")
            },
            .send(.letterSelected(0)) {
                $0.currentWord.append(0)
            },
            .send(.letterSelected(1)) {
                $0.currentWord.append(1)
            },
            .send(.letterSelected(2)) {
                $0.currentWord.append(2)
            },
            .send(.letterSelected(3)) {
                $0.currentWord.append(3)
            },
            .send(.letterSelected(4)) {
                $0.currentWord.append(4)
            },
            .send(.letterSelected(5)) {
                $0.currentWord.append(5)
            },
            .send(.letterSelected(6)) {
                $0.currentWord.append(6)
            },
            .send(.letterSelected(7)) {
                $0.currentWord.append(7)
            },
            .send(.letterSelected(8)) {
                $0.currentWord.append(8)
            },
            .send(.submitWordTapped)
        )
    }
    
    func testDiagonalSelection() {
        let testStore = TestStore(
            initialState: GameState(
                board: [
                    "H", "I", "J",
                    "A", "C", "K",
                    "E", "R", "S"
                ]
            ),
            reducer: gameReducer,
            environment: GameEnvironment(
                newBoard: { [] },
                isValidWord: { _ in true }
            )
        )
        
        testStore.assert(
            .send(.letterSelected(0)) {
                $0.currentWord.append(0)
            },
            .send(.letterSelected(4)) {
                $0.currentWord.append(4)
            }
        )
    }
    
}
