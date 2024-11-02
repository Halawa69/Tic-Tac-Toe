import 'dart:io';
import 'dart:math';

// Board state
List<List<String>> board = List.generate(3, (_) => List.filled(3, ' '));

// Function to display the board
void displayBoard() {
  print('-------------');
  for (var row in board) {
    print('| ${row[0]} | ${row[1]} | ${row[2]} |');
    print('-------------');
  }
}

// Function to check if the board has a winner or a tie
String? checkWinner() {
  // Check rows and columns
  for (int i = 0; i < 3; i++) {
    if (board[i][0] != ' ' && board[i][0] == board[i][1] && board[i][1] == board[i][2]) {
      return board[i][0];
    }
    if (board[0][i] != ' ' && board[0][i] == board[1][i] && board[1][i] == board[2][i]) {
      return board[0][i];
    }
  }

  // Check diagonals
  if (board[0][0] != ' ' && board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
    return board[0][0];
  }
  if (board[0][2] != ' ' && board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
    return board[0][2];
  }

  // Check if the board is full (tie)
  if (board.every((row) => row.every((cell) => cell != ' '))) {
    return 'Tie';
  }

  // No winner yet
  return null;
}

// Function to make a move on the board
bool makeMove(int row, int col, String player) {
  if (board[row][col] == ' ') {
    board[row][col] = player;
    return true;
  }
  return false;
}

// Minimax algorithm implementation
int minimax(bool isMaximizing, int depth, bool easyMode) {
  String? winner = checkWinner();
  if (winner == 'O') return 10 - depth; // Computer wins
  if (winner == 'X') return depth - 10; // Player wins
  if (winner == 'Tie') return 0; // Tie

  if (isMaximizing) {
    int bestScore = -1000;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == ' ') {
          board[i][j] = 'O';
          int score = minimax(false, depth + 1, easyMode);
          board[i][j] = ' ';
          bestScore = max(score, bestScore);
          if (easyMode) return bestScore; // Exit early for easy mode
        }
      }
    }
    return bestScore;
  } else {
    int bestScore = 1000;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == ' ') {
          board[i][j] = 'X';
          int score = minimax(true, depth + 1, easyMode);
          board[i][j] = ' ';
          bestScore = min(score, bestScore);
        }
      }
    }
    return bestScore;
  }
}

// Function for the computer to find the best move
List<int> getBestMove(bool easyMode) {
  int bestScore = -1000;
  List<int> bestMove = [-1, -1];

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == ' ') {
        board[i][j] = 'O';
        int score = minimax(false, 0, easyMode);
        board[i][j] = ' ';
        if (score > bestScore) {
          bestScore = score;
          bestMove = [i, j];
        }
      }
    }
  }
  return bestMove;
}

// Helper function to get valid integer input
int getValidInput(String prompt) {
  while (true) {
    stdout.write(prompt);
    String? input = stdin.readLineSync();
    if (input != null && int.tryParse(input) != null) {
      int value = int.parse(input);
      if (value >= 0 && value <= 2) {
        return value;
      }
    }
    print('Invalid input. Please enter a number between 0 and 2.');
  }
}

// Game modes
void playerVsPlayer() {
  String currentPlayer = 'X';
  while (true) {
    displayBoard();
    int row = getValidInput('$currentPlayer\'s turn. Enter row (0-2): ');
    int col = getValidInput('$currentPlayer\'s turn. Enter column (0-2): ');

    if (makeMove(row, col, currentPlayer)) {
      String? winner = checkWinner();
      if (winner != null) {
        displayBoard();
        print(winner == 'Tie' ? 'It\'s a tie!' : '$winner wins!');
        break;
      }
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    } else {
      print('Invalid move. Try again.');
    }
  }
}

void playerVsComputer(bool easyMode) {
  while (true) {
    displayBoard();
    int row = getValidInput('Your turn. Enter row (0-2): ');
    int col = getValidInput('Your turn. Enter column (0-2): ');

    if (makeMove(row, col, 'X')) {
      String? winner = checkWinner();
      if (winner != null) {
        displayBoard();
        print(winner == 'Tie' ? 'It\'s a tie!' : '$winner wins!');
        break;
      }

      print('Computer\'s turn...');
      List<int> move = getBestMove(easyMode);
      makeMove(move[0], move[1], 'O');

      winner = checkWinner();
      if (winner != null) {
        displayBoard();
        print(winner == 'Tie' ? 'It\'s a tie!' : '$winner wins!');
        break;
      }
    } else {
      print('Invalid move. Try again.');
    }
  }
}

// Main function to start the game
void main() {
  print('Choose a mode:');
  print('1. Player vs Player');
  print('2. Player vs Computer (Easy)');
  print('3. Player vs Computer (Hard)');

  int choice = getValidInput('Enter your choice (1-3): ');
  switch (choice) {
    case 1:
      playerVsPlayer();
      break;
    case 2:
      playerVsComputer(true);
      break;
    case 3:
      playerVsComputer(false);
      break;
    default:
      print('Invalid choice. Exiting...');
  }
}
