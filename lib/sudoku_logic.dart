import 'dart:math';

void main() {
  List<List<int>> sudokuPuzzle = generateSudoku();
  printSudoku(sudokuPuzzle);
}

List<List<int>> generateSudoku() {
  List<List<int>> grid = List.generate(9, (_) => List.filled(9, 0));
  fillDiagonalBoxes(grid);
  fillRemaining(grid, 0, 3);
  removeNumbers(grid);
  return grid;
}

void fillDiagonalBoxes(List<List<int>> grid) {
  for (int i = 0; i < 9; i += 3) {
    fillBox(grid, i, i);
  }
}

void fillBox(List<List<int>> grid, int row, int col) {
  List<int> numList = List.generate(9, (index) => index + 1)..shuffle();
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      grid[row + i][col + j] = numList.removeLast();
    }
  }
}

bool fillRemaining(List<List<int>> grid, int row, int col) {
  if (col >= 9 && row < 8) {
    row++;
    col = 0;
  }
  if (row >= 9 && col >= 9) {
    return true;
  }
  if (row < 3) {
    if (col < 3) {
      col = 3;
    }
  } else if (row < 6) {
    if (col == (row ~/ 3) * 3) {
      col += 3;
    }
  } else {
    if (col == 6) {
      row++;
      col = 0;
      if (row >= 9) {
        return true;
      }
    }
  }
  for (int num = 1; num <= 9; num++) {
    if (isSafe(grid, row, col, num)) {
      grid[row][col] = num;
      if (fillRemaining(grid, row, col + 1)) {
        return true;
      }
      grid[row][col] = 0;
    }
  }
  return false;
}

bool isSafe(List<List<int>> grid, int row, int col, int num) {
  for (int x = 0; x < 9; x++) {
    if (grid[row][x] == num || grid[x][col] == num) {
      return false;
    }
  }
  int startRow = row - row % 3;
  int startCol = col - col % 3;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (grid[i + startRow][j + startCol] == num) {
        return false;
      }
    }
  }
  return true;
}

void removeNumbers(List<List<int>> grid) {
  Random random = Random();
  int count = 40; // Number of cells to remove
  while (count != 0) {
    int cellId = random.nextInt(81);
    int row = cellId ~/ 9;
    int col = cellId % 9;
    if (grid[row][col] != 0) {
      int backup = grid[row][col];
      grid[row][col] = 0;
      if (!isUniqueSolution(grid)) {
        grid[row][col] = backup;
      } else {
        count--;
      }
    }
  }
}

bool isUniqueSolution(List<List<int>> grid) {
  List<List<int>> gridCopy = List.generate(9, (i) => List.from(grid[i]));
  return solveSudoku(gridCopy);
}

bool solveSudoku(List<List<int>> grid) {
  for (int row = 0; row < 9; row++) {
    for (int col = 0; col < 9; col++) {
      if (grid[row][col] == 0) {
        for (int num = 1; num <= 9; num++) {
          if (isSafe(grid, row, col, num)) {
            grid[row][col] = num;
            if (solveSudoku(grid)) {
              return true;
            } else {
              grid[row][col] = 0;
            }
          }
        }
        return false;
      }
    }
  }
  return true;
}

void printSudoku(List<List<int>> grid) {
  for (int row = 0; row < 9; row++) {
    for (int col = 0; col < 9; col++) {
      print(grid[row][col]);
      print(" ");
    }
    print("\n");
  }
}
