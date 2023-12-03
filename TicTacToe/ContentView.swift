import SwiftUI

struct Winner: Identifiable {
    var id: String { player }
    let player: String
}

struct ContentView: View {
    @State private var board = Array(repeating: "", count: 9)
    @State private var currentPlayer = "X"
    @State private var winner: Winner?

    var body: some View {
        VStack {
            Text("Tic Tac Toe")
                .font(.title)
                .padding()

            LazyVGrid(columns: Array(repeating: GridItem(.fixed(100), spacing: 5), count: 3), spacing: 5) {
                ForEach(0..<9) { index in
                    Button(action: {
                        if board[index].isEmpty && winner == nil {
                            currentPlayer = "X"
                            board[index] = currentPlayer
                            checkForWinner()
                            makeComputerMove()
                        }
                    }) {
                        Text(board[index])
                            .font(.title)
                            .frame(width: 100, height: 100)
                            .background(Color.blue)
                            .foregroundColor(.white)
                    }
                }
            }
            
            Button(action: {
                resetGame()
            }) {
                Text("Reset")
                    .font(.headline)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .alert(item: $winner) { winner in
            Alert(title: Text("\(winner.player) wins!"), dismissButton: .default(Text("New Game")) {
                        resetGame()
                    })
                }
    }
    
    func checkForWinner() {
        // Check rows
        for i in stride(from: 0, to: 9, by: 3) {
            if !board[i].isEmpty && board[i] == board[i + 1] && board[i + 1] == board[i + 2] {
                winner = Winner(player: board[i])
                return
            }
        }

        // Check columns
        for i in 0..<3 {
            if !board[i].isEmpty && board[i] == board[i + 3] && board[i + 3] == board[i + 6] {
                winner = Winner(player: board[i])
                return
            }
        }

        // Check diagonals
        if board[0] == board[4] && board[4] == board[8] && !board[0].isEmpty {
            winner = Winner(player: board[0])
            return
        }
        if board[2] == board[4] && board[4] == board[6] && !board[2].isEmpty {
            winner = Winner(player: board[2])
            return
        }

        // Check for a tie (no winner and all cells filled)
        if !board.contains("") {
            winner = Winner(player: "Tie")
        }
    }



    func resetGame() {
        // Reset your game state variables here (e.g., clear the board, set currentPlayer to "X")
        board = Array(repeating: "", count: 9)
        currentPlayer = "X"
        winner = nil
    }
    
    func makeComputerMove() {
        if winner == nil {
            currentPlayer = "O"
            let emptyCells = board.indices.filter { board[$0].isEmpty }
            if let randomIndex = emptyCells.randomElement() {
                board[randomIndex] = "O"
                checkForWinner()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
