import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const KelimeAviApp());
}

class KelimeAviApp extends StatelessWidget {
  const KelimeAviApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kelime Avı',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B4BDB)),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

enum Difficulty { easy, medium, hard }

extension DifficultyX on Difficulty {
  String get title {
    switch (this) {
      case Difficulty.easy:
        return 'Kolay';
      case Difficulty.medium:
        return 'Orta';
      case Difficulty.hard:
        return 'Zor';
    }
  }

  int get gridSize {
    switch (this) {
      case Difficulty.easy:
        return 8;
      case Difficulty.medium:
        return 10;
      case Difficulty.hard:
        return 12;
    }
  }

  int get wordCount {
    switch (this) {
      case Difficulty.easy:
        return 5;
      case Difficulty.medium:
        return 7;
      case Difficulty.hard:
        return 9;
    }
  }

  int get timeLimit {
    switch (this) {
      case Difficulty.easy:
        return 180;
      case Difficulty.medium:
        return 240;
      case Difficulty.hard:
        return 300;
    }
  }

  int get scoreMultiplier {
    switch (this) {
      case Difficulty.easy:
        return 10;
      case Difficulty.medium:
        return 15;
      case Difficulty.hard:
        return 20;
    }
  }

  Color get color {
    switch (this) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.medium:
        return Colors.orange;
      case Difficulty.hard:
        return Colors.red;
    }
  }

  String get subtitle {
    switch (this) {
      case Difficulty.easy:
        return '8x8 tablo • 5 kelime';
      case Difficulty.medium:
        return '10x10 tablo • 7 kelime';
      case Difficulty.hard:
        return '12x12 tablo • 9 kelime';
    }
  }
}

class GridPos {
  final int row;
  final int col;

  const GridPos(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      other is GridPos && row == other.row && col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5B4BDB), Color(0xFF7B61FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutPage()),
                      );
                    },
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: const Icon(
                    Icons.manage_search_rounded,
                    size: 90,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Kelime Avı',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Gizlenmiş kelimeleri bul, süre bitmeden oyunu tamamla.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF5B4BDB),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text(
                      'Oyuna Başla',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DifficultyPage(),
                        ),
                      );
                    },
                  ),
                ),
                const Spacer(),
                const Text(
                  'Flutter ile geliştirildi',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uygulama Hakkında')),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Kelime Avı, Flutter ile geliştirilmiş bir kelime bulma oyunudur.\n\n'
          'Özellikler:\n'
          '• Navigator ile sayfa geçişleri\n'
          '• 3 farklı zorluk seviyesi\n'
          '• Süre, seviye ve durdurma sistemi\n'
          '• Otomatik kelime kontrolü\n'
          '• Ses efekti\n'
          '• İpucu sistemi\n'
          '• Bulunan harfleri tekrar kullanabilme',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}

class DifficultyPage extends StatelessWidget {
  const DifficultyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zorluk Seç'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: Difficulty.values.map((difficulty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GamePage(difficulty: difficulty),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: difficulty.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: difficulty.color.withOpacity(0.35)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: difficulty.color,
                      radius: 28,
                      child: const Icon(Icons.play_arrow, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            difficulty.title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: difficulty.color,
                            ),
                          ),
                          Text(difficulty.subtitle),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  final Difficulty difficulty;

  const GamePage({super.key, required this.difficulty});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Random _random = Random();
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<String> _wordPool = const [
    'ELMA',
    'ARABA',
    'KEDI',
    'OKUL',
    'MAVI',
    'DENIZ',
    'KITAP',
    'KALEM',
    'YILDIZ',
    'ORMAN',
    'SEKER',
    'BULUT',
    'RENK',
    'MASA',
    'PENCERE',
    'TELEFON',
    'OYUN',
    'KUS',
    'BAHAR',
    'GUNES',
    'YAZILIM',
    'EKRAN',
    'FUTBOL',
    'SINIF',
    'BILGISAYAR',
  ];

  late int _size;
  late List<List<String>> _board;
  late List<String> _selectedWords;

  final Map<String, List<GridPos>> _wordPositions = {};
  final Set<String> _foundWords = {};
  final List<GridPos> _selectedCells = [];

  Timer? _timer;
  late int _timeLeft;
  int _score = 0;
  int _hintsLeft = 2;
  bool _isPaused = false;
  bool _gameFinished = false;

  final List<List<int>> _directions = const [
    [0, 1],
    [1, 0],
    [0, -1],
    [-1, 0],
    [1, 1],
    [1, -1],
    [-1, 1],
    [-1, -1],
  ];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSuccessSound() async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource('sounds/success.mp3'));
  }

  void _startGame() {
    _timer?.cancel();

    _size = widget.difficulty.gridSize;
    _timeLeft = widget.difficulty.timeLimit;
    _score = 0;
    _hintsLeft = 2;
    _isPaused = false;
    _gameFinished = false;

    _foundWords.clear();
    _selectedCells.clear();
    _wordPositions.clear();

    _selectedWords = _pickWords();
    _generateBoard();
    _startTimer();

    setState(() {});
  }

  List<String> _pickWords() {
    final words =
        _wordPool
            .where((word) => word.length <= widget.difficulty.gridSize)
            .toList()
          ..shuffle(_random);

    return words.take(widget.difficulty.wordCount).toList();
  }

  void _generateBoard() {
    _board = List.generate(_size, (_) => List.generate(_size, (_) => ''));

    for (final word in _selectedWords) {
      bool placed = false;
      int attempts = 0;

      while (!placed && attempts < 300) {
        attempts++;

        final dir = _directions[_random.nextInt(_directions.length)];
        final row = _random.nextInt(_size);
        final col = _random.nextInt(_size);

        if (_canPlaceWord(word, row, col, dir[0], dir[1])) {
          final positions = <GridPos>[];

          for (int i = 0; i < word.length; i++) {
            final r = row + i * dir[0];
            final c = col + i * dir[1];
            _board[r][c] = word[i];
            positions.add(GridPos(r, c));
          }

          _wordPositions[word] = positions;
          placed = true;
        }
      }
    }

    const letters = 'ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ';

    for (int r = 0; r < _size; r++) {
      for (int c = 0; c < _size; c++) {
        if (_board[r][c].isEmpty) {
          _board[r][c] = letters[_random.nextInt(letters.length)];
        }
      }
    }
  }

  bool _canPlaceWord(String word, int row, int col, int dr, int dc) {
    final endRow = row + (word.length - 1) * dr;
    final endCol = col + (word.length - 1) * dc;

    if (endRow < 0 || endRow >= _size || endCol < 0 || endCol >= _size) {
      return false;
    }

    for (int i = 0; i < word.length; i++) {
      final r = row + i * dr;
      final c = col + i * dc;
      final current = _board[r][c];

      if (current.isNotEmpty && current != word[i]) {
        return false;
      }
    }

    return true;
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused || _gameFinished) return;

      if (_timeLeft <= 1) {
        timer.cancel();
        setState(() => _timeLeft = 0);
        _showEndDialog(success: false);
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _pauseGame() {
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeGame() {
    setState(() {
      _isPaused = false;
    });
  }

  void _confirmRestart() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Yeniden Başlat'),
          content: const Text('Oyunu yeniden başlatmak istiyor musun?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _startGame();
              },
              child: const Text('Evet'),
            ),
          ],
        );
      },
    );
  }

  void _onCellTap(GridPos pos) {
    if (_gameFinished || _isPaused) return;

    setState(() {
      if (_selectedCells.isEmpty) {
        _selectedCells.add(pos);
      } else if (_selectedCells.length == 1) {
        if (pos == _selectedCells.first) {
          _selectedCells.clear();
        } else if (_isAdjacent(_selectedCells.first, pos)) {
          _selectedCells.add(pos);
        }
      } else {
        final last = _selectedCells.last;

        if (pos == last) {
          _selectedCells.removeLast();
        } else if (!_selectedCells.contains(pos) && _isAdjacent(last, pos)) {
          final first = _selectedCells[0];
          final second = _selectedCells[1];

          final expectedRowDir = _sign(second.row - first.row);
          final expectedColDir = _sign(second.col - first.col);

          final newRowDir = _sign(pos.row - last.row);
          final newColDir = _sign(pos.col - last.col);

          if (expectedRowDir == newRowDir && expectedColDir == newColDir) {
            _selectedCells.add(pos);
          }
        }
      }
    });

    _autoCheckSelection();
  }

  void _autoCheckSelection() {
    if (_selectedCells.length < 2) return;

    final selectedText = _selectedCells
        .map((cell) => _board[cell.row][cell.col])
        .join();
    final reversedText = selectedText.split('').reversed.join();

    String? matchedWord;

    for (final word in _selectedWords) {
      if (_foundWords.contains(word)) continue;

      final positions = _wordPositions[word]!;
      final reversedPositions = positions.reversed.toList();

      if (_listEqualsGridPos(_selectedCells, positions) ||
          _listEqualsGridPos(_selectedCells, reversedPositions) ||
          selectedText == word ||
          reversedText == word) {
        matchedWord = word;
        break;
      }
    }

    if (matchedWord == null) return;

    setState(() {
      _foundWords.add(matchedWord!);
      _score += matchedWord.length * widget.difficulty.scoreMultiplier;
      _selectedCells.clear();
    });

    _playSuccessSound();
    _showMessage('$matchedWord bulundu!');

    if (_foundWords.length == _selectedWords.length) {
      _gameFinished = true;
      _timer?.cancel();
      _showEndDialog(success: true);
    }
  }

  bool _isAdjacent(GridPos a, GridPos b) {
    final rowDiff = (a.row - b.row).abs();
    final colDiff = (a.col - b.col).abs();

    return rowDiff <= 1 && colDiff <= 1 && !(rowDiff == 0 && colDiff == 0);
  }

  int _sign(int value) {
    if (value == 0) return 0;
    return value > 0 ? 1 : -1;
  }

  bool _listEqualsGridPos(List<GridPos> a, List<GridPos> b) {
    if (a.length != b.length) return false;

    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }

    return true;
  }

  void _clearSelection() {
    setState(() {
      _selectedCells.clear();
    });
  }

  void _useHint() {
    if (_isPaused) return;

    if (_hintsLeft <= 0) {
      _showMessage('İpucu hakkın kalmadı.');
      return;
    }

    final remainingWords = _selectedWords
        .where((word) => !_foundWords.contains(word))
        .toList();

    if (remainingWords.isEmpty) return;

    final hintWord = remainingWords[_random.nextInt(remainingWords.length)];
    final positions = _wordPositions[hintWord]!;
    final first = positions.first;

    setState(() {
      _hintsLeft--;
      _score = max(0, _score - 10);
    });

    _showMessage(
      'İpucu: ${hintWord[0]} ile başlıyor, ${hintWord.length} harf. '
      'Başlangıç: ${first.row + 1}. satır, ${first.col + 1}. sütun.',
    );
  }

  void _showEndDialog({required bool success}) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text(success ? 'Tebrikler!' : 'Süre Doldu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                success ? Icons.emoji_events_rounded : Icons.timer_off_rounded,
                size: 60,
                color: success ? Colors.amber : Colors.red,
              ),
              const SizedBox(height: 12),
              Text(
                success
                    ? 'Tüm kelimeleri buldun.'
                    : 'Süre bitti. Oyun tamamlanamadı.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Puan: $_score',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Bulunan: ${_foundWords.length}/${_selectedWords.length}'),
              Text('Seviye: ${widget.difficulty.title}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startGame();
              },
              child: const Text('Yeniden Oyna'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Menüye Dön'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
      );
  }

  String _formatTime(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;

    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  bool _isFoundCell(GridPos pos) {
    for (final word in _foundWords) {
      if (_wordPositions[word]!.contains(pos)) return true;
    }

    return false;
  }

  bool _isSelectedCell(GridPos pos) => _selectedCells.contains(pos);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final gridWidth = min(width - 24, 520.0);
    final remainingWords = _selectedWords.length - _foundWords.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kelime Avı • ${widget.difficulty.title}'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _useHint,
            icon: const Icon(Icons.lightbulb_outline_rounded),
          ),
          IconButton(
            onPressed: _confirmRestart,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _TopSmallCard(
                        title: 'Süre',
                        value: _formatTime(_timeLeft),
                        icon: Icons.timer_outlined,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TopSmallCard(
                        title: 'Seviye',
                        value: widget.difficulty.title,
                        icon: Icons.bar_chart_rounded,
                        color: widget.difficulty.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: _pauseGame,
                        child: const _TopSmallCard(
                          title: 'Durdur',
                          value: 'Pause',
                          icon: Icons.pause_circle_outline_rounded,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _MiniStatCard(
                        title: 'Bulunan',
                        value: _foundWords.length.toString(),
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MiniStatCard(
                        title: 'Kalan',
                        value: remainingWords.toString(),
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MiniStatCard(
                        title: 'Puan',
                        value: _score.toString(),
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MiniStatCard(
                        title: 'İpucu',
                        value: _hintsLeft.toString(),
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Bulunacak Kelimeler',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _clearSelection,
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            label: const Text('Temizle'),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _selectedWords.map((word) {
                          final found = _foundWords.contains(word);

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: found
                                  ? Colors.green.withOpacity(0.15)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: found
                                    ? Colors.green
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              word,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: found
                                    ? Colors.green.shade800
                                    : Colors.black87,
                                decoration: found
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: gridWidth,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _size * _size,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _size,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                          itemBuilder: (context, index) {
                            final row = index ~/ _size;
                            final col = index % _size;
                            final pos = GridPos(row, col);

                            final isFound = _isFoundCell(pos);
                            final isSelected = _isSelectedCell(pos);

                            Color bgColor = const Color(0xFFF1F3F9);
                            Color textColor = Colors.black87;
                            Color borderColor = Colors.transparent;

                            if (isSelected) {
                              bgColor = const Color(0xFF5B4BDB);
                              textColor = Colors.white;
                              borderColor = const Color(0xFF3C2ACF);
                            } else if (isFound) {
                              bgColor = Colors.green.shade400;
                              textColor = Colors.white;
                              borderColor = Colors.green.shade700;
                            }

                            return GestureDetector(
                              onTap: () => _onCellTap(pos),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Center(
                                  child: Text(
                                    _board[row][col],
                                    style: TextStyle(
                                      fontSize: _size >= 12 ? 13 : 17,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (_selectedCells.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEBFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Seçim: ${_selectedCells.map((e) => _board[e.row][e.col]).join()}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
          if (_isPaused)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.85),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(28),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.pause_circle_filled_rounded,
                        size: 80,
                        color: Color(0xFF5B4BDB),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Oyun Duraklatıldı',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Oyun alanı gizlendi. Devam etmek için butona bas.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _resumeGame,
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Devam Et'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _confirmRestart,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Yeniden Başlat'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TopSmallCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _TopSmallCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 23),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MiniStatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
