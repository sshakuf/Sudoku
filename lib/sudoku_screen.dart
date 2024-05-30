import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sudoku_app/sudoku_logic.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key});

  @override
  _SudokuScreenState createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  List<List<int>> sudokuGrid = [
    [5, 3, 0, 0, 7, 0, 0, 0, 0],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 0, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 8, 0, 0, 7, 9],
  ];

  List<List<List<int>>> sudokuGridOptions = [
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
  ];

  List<List<int>> sudokuGridInitial = [
    [5, 3, 0, 0, 7, 0, 0, 0, 0],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 0, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 8, 0, 0, 7, 9],
  ];

  List<List<int>> sudokuGridFull = [
    [5, 3, 4, 6, 7, 8, 9, 1, 2],
    [6, 7, 2, 1, 9, 5, 3, 4, 8],
    [1, 9, 8, 3, 4, 2, 5, 6, 7],
    [8, 5, 9, 7, 6, 1, 4, 2, 3],
    [4, 2, 6, 8, 5, 3, 7, 9, 1],
    [7, 1, 3, 9, 2, 4, 8, 5, 6],
    [9, 6, 1, 5, 3, 7, 2, 8, 4],
    [2, 8, 7, 4, 1, 9, 6, 3, 5],
    [3, 4, 5, 2, 8, 6, 1, 7, 9]
  ];

  int selectedIndex = -1; // State variable to track the selected button index
  bool isOptionValue = false;
  bool clearOptionsValues = false;
  bool showErrors = false;
  bool showNumbersColors = false;

  List<List<List<int>>> initializeSudokuGridOptions(int size) {
    return List.generate(
      size,
      (_) => List.generate(
        size,
        (_) => <int>[],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSudokuState();
  }

  void _saveSudokuState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sudokuState = jsonEncode(sudokuGridInitial);
    await prefs.setString('sudokuGridInitial', sudokuState);
    sudokuState = jsonEncode(sudokuGridOptions);
    await prefs.setString('sudokuGridOptions', sudokuState);
    sudokuState = jsonEncode(sudokuGrid);
    await prefs.setString('sudokuGrid', sudokuState);
    sudokuState = jsonEncode(sudokuGridFull);
    await prefs.setString('sudokuGridFull', sudokuState);
    sudokuState = jsonEncode(showErrors);
    await prefs.setString('showErrors', sudokuState);
    sudokuState = jsonEncode(showNumbersColors);
    await prefs.setString('showNumbersColors', sudokuState);
  }

  void _loadSudokuState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sudokuStateInitial = prefs.getString('sudokuGridInitial');
    String? sudokuStateFull = prefs.getString('sudokuGridFull');
    String? sudokuStateOptions = prefs.getString('sudokuGridOptions');
    String? sudokuStateGrid = prefs.getString('sudokuGrid');
    String? sudokuStateShowErrors = prefs.getString('showErrors');
    String? sudokuStateShowNumbersColors = prefs.getString('showNumbersColors');
    if (sudokuStateGrid != null) {
      setState(() {
        sudokuGridInitial = List<List<int>>.from(
            jsonDecode(sudokuStateInitial!).map((row) => List<int>.from(row)));
        sudokuGridFull = List<List<int>>.from(
            jsonDecode(sudokuStateFull!).map((row) => List<int>.from(row)));

        sudokuGridOptions = List<List<List<int>>>.from(
            jsonDecode(sudokuStateOptions!).map((option) =>
                List<List<int>>.from(
                    option.map((row) => List<int>.from(row)))));

        sudokuGrid = List<List<int>>.from(
            jsonDecode(sudokuStateGrid).map((row) => List<int>.from(row)));

        showErrors = jsonDecode(sudokuStateShowErrors!);
        showNumbersColors = jsonDecode(sudokuStateShowNumbersColors!);

        _saveSudokuState();
      });
    }
  }

  void fillSudokuGrid(int row, int col, int value) {
    setState(() {
      if (sudokuGridInitial[row][col] != 0 || value == -1) {
        return;
      }
      sudokuGrid[row][col] = value;
      sudokuGridOptions[row][col].clear();
      _saveSudokuState();
    });
  }

  void fillSudokuOptionsGrid(int row, int col, int value) {
    setState(() {
      if (sudokuGridInitial[row][col] != 0 || value == -1 || value == 0) {
        return;
      }
      if (!sudokuGridOptions[row][col].contains(value)) {
        sudokuGridOptions[row][col].add(value);
        _saveSudokuState();
      }
    });
  }

  void clarSudokuOptionsGrid(int row, int col, int value) {
    setState(() {
      if (sudokuGridInitial[row][col] != 0 || value == -1 || value == 0) {
        return;
      }

      if (sudokuGridOptions[row][col].contains(value)) {
        sudokuGridOptions[row][col].remove(value);
        _saveSudokuState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   color: const Color.fromARGB(255, 200, 220, 237),
      // ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Sudoku',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
                childAspectRatio: 1,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              itemCount: 81,
              itemBuilder: (context, index) {
                int row = index ~/ 9;
                int col = index % 9;
                int value = sudokuGrid[row][col];
                bool isCorrect = sudokuGrid[row][col] == 0
                    ? true
                    : sudokuGridFull[row][col] == value;
                Color cellCollor = Colors.grey;
                Color numColor = Color.fromARGB(255, 200, 220, 237);
                Color numColorText = Colors.black;
                if (showErrors) {
                  cellCollor = isCorrect ? Colors.grey : Colors.red;
                }
                if (showNumbersColors && selectedIndex > 0) {
                  numColor = sudokuGrid[row][col] == selectedIndex
                      ? Color.fromARGB(255, 44, 90, 43)
                      : Color.fromARGB(255, 200, 220, 237);

                  numColorText = sudokuGrid[row][col] == selectedIndex
                      ? Color.fromARGB(255, 146, 219, 145)
                      : Colors.black;
                }
                return GestureDetector(
                  onTap: () {
                    if (isOptionValue) {
                      fillSudokuOptionsGrid(row, col, selectedIndex);
                    } else if (clearOptionsValues) {
                      clarSudokuOptionsGrid(row, col, selectedIndex);
                    } else {
                      fillSudokuGrid(row, col, selectedIndex);
                    }
                    print('Pressed cell at row $row, col $col');
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: numColor,
                      border: Border(
                        top: BorderSide(
                          color: cellCollor,
                          width: row % 3 == 0 ? 2.0 : 1.0,
                        ),
                        left: BorderSide(
                          color: cellCollor,
                          width: col % 3 == 0 ? 2.0 : 1.0,
                        ),
                        right: BorderSide(
                          color: cellCollor,
                          width: (col + 1) % 3 == 0 ? 2.0 : 1.0,
                        ),
                        bottom: BorderSide(
                          color: cellCollor,
                          width: (row + 1) % 3 == 0 ? 2.0 : 1.0,
                        ),
                      ),
                    ),
                    child: FittedBox(
                      child: Column(children: [
                        Row(children: [
                          if (sudokuGridOptions[row][col].isNotEmpty)
                            for (int i = 0;
                                i < sudokuGridOptions[row][col].length;
                                i++)
                              Text(
                                sudokuGridOptions[row][col][i] != 0
                                    ? sudokuGridOptions[row][col][i].toString()
                                    : ' ',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: numColorText,
                                ),
                              ),
                        ]),
                        Text(
                          value != 0 ? value.toString() : '',
                          style: TextStyle(
                            fontSize: 20,
                            color: numColorText,
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: 8.0,
            children: List.generate(10, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(
                      selectedIndex == index ? Colors.white : Colors.black,
                    ),
                    backgroundColor: WidgetStateProperty.all(
                      selectedIndex == index ? Colors.blueGrey : Colors.white,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    print('Pressed $index');
                  },
                  child: Text((index).toString()),
                ),
              );
            }),
          ),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: 8.0,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isOptionValue = false;
                    clearOptionsValues = !clearOptionsValues;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    clearOptionsValues ? Colors.blueGrey : Colors.white,
                  ),
                ),
                child: const Text('Clear Options'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isOptionValue = !isOptionValue;
                    clearOptionsValues = false;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    isOptionValue ? Colors.blueGrey : Colors.white,
                  ),
                ),
                child: const Text('Option'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    sudokuGrid =
                        (sudokuGridInitial.map((e) => e.toList())).toList();

                    sudokuGridOptions = initializeSudokuGridOptions(9);
                  });
                },
                child: const Text('Reset'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showErrors = !showErrors;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    showErrors ? Colors.blueGrey : Colors.white,
                  ),
                ),
                child: const Text('Show Errors'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showNumbersColors = !showNumbersColors;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    showNumbersColors ? Colors.blueGrey : Colors.white,
                  ),
                ),
                child: const Text('Show Numbers'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    sudokuGrid = generateSudoku();
                    sudokuGridInitial =
                        (sudokuGrid.map((e) => e.toList())).toList();
                    sudokuGridFull =
                        (sudokuGrid.map((e) => e.toList())).toList();

                    sudokuGridOptions = initializeSudokuGridOptions(9);

                    solveSudoku(sudokuGridFull);
                    printSudoku(sudokuGridFull);
                    //  (sudokuGridInitial.map((e) => e.toList())).toList();
                  });
                },
                child: const Text('New Game'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
