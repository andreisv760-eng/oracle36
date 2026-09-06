import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const OracleApp());

const GOLD = Color(0xFFC9A84C);
const EMERALD = Color(0xFF0E3B33);
const PARCH = Color(0xFFF5F0E8);
const WINE = Color(0xFF7B2D3B);

Widget velvet(Widget child) {
  return Container(
    decoration: const BoxDecoration(
      gradient: RadialGradient(
        colors: [Color(0xFF155A4E), EMERALD],
      ),
    ),
    child: child,
  );
}

class LCard {
  final int n;
  final String name, general;
  const LCard(this.n, this.name, this.general);
}

const DECK = [
  LCard(1, 'Всадник', 'Весть, скорые перемены'),
  LCard(2, 'Клевер', 'Удача, шанс'),
  LCard(3, 'Корабль', 'Дорога, планы'),
  LCard(4, 'Дом', 'Семья, уют'),
  LCard(5, 'Дерево', 'Рост, здоровье'),
  LCard(6, 'Тучи', 'Неясность, тревога'),
  LCard(7, 'Змея', 'Хитрость, интрига'),
  LCard(8, 'Гроб', 'Завершение этапа'),
  LCard(9, 'Букет', 'Подарок, радость'),
  LCard(10, 'Коса', 'Резкое решение'),
  LCard(11, 'Метла', 'Споры, активность'),
  LCard(12, 'Совы', 'Тревога, суета'),
  LCard(13, 'Ребёнок', 'Новое начало'),
  LCard(14, 'Лиса', 'Хитрость, работа'),
  LCard(15, 'Медведь', 'Сила, власть'),
  LCard(16, 'Звёзды', 'Надежда, мечта'),
  LCard(17, 'Аист', 'Перемены к лучшему'),
  LCard(18, 'Собака', 'Друг, поддержка'),
  LCard(19, 'Башня', 'Изоляция, структуры'),
  LCard(20, 'Сад', 'Общество, события'),
  LCard(21, 'Гора', 'Препятствие'),
  LCard(22, 'Развилка', 'Выбор из двух'),
  LCard(23, 'Крысы', 'Потери, стресс'),
  LCard(24, 'Сердце', 'Любовь, чувства'),
  LCard(25, 'Кольцо', 'Союз, договор'),
  LCard(26, 'Книга', 'Тайна, знания'),
  LCard(27, 'Письмо', 'Документы, новости'),
  LCard(28, 'Мужчина', 'Мужчина вопроса'),
  LCard(29, 'Женщина', 'Женщина вопроса'),
  LCard(30, 'Лилии', 'Чистота, мудрость'),
  LCard(31, 'Солнце', 'Успех, ясность'),
  LCard(32, 'Луна', 'Интуиция, тайны'),
  LCard(33, 'Ключ', 'Решение найдено'),
  LCard(34, 'Рыбы', 'Деньги, поток'),
  LCard(35, 'Якорь', 'Стабильность'),
  LCard(36, 'Крест', 'Судьба, финал цикла'),
];

class SpreadType {
  final String title;
  final List<String> positions;
  const SpreadType(this.title, this.positions);
}

const SPREADS = [
  SpreadType('Три карты', ['Прошлое', 'Настоящее', 'Будущее']),
  SpreadType('Пять карт', ['Ситуация', 'Препятствие', 'Совет', 'Помощь', 'Итог']),
];

class DiaryEntry {
  final DateTime date;
  final String question;
  final List<LCard> cards;
  String status;
  DiaryEntry(this.date, this.question, this.cards,
      [this.status = 'pending']);
}

final List<DiaryEntry> diary = [];

class Game {
  static int coins = 0;
  static int streak = 0;
}

class Combo {
  final String a, b, text;
  const Combo(this.a, this.b, this.text);
}

const COMBOS = [
  Combo('Всадник', 'Клевер', 'Быстрая удача, хорошая новость'),
  Combo('Всадник', 'Письмо', 'Письмо или весть в пути'),
  Combo('Змея', 'Сердце', 'Соперница в любви'),
  Combo('Кольцо', 'Книга', 'Тайный договор'),
  Combo('Солнце', 'Луна', 'Успех и признание'),
  Combo('Рыбы', 'Ключ', 'Решение денежного вопроса'),
  Combo('Тучи', 'Солнце', 'Трудности сменятся ясностью'),
  Combo('Лиса', 'Медведь', 'Хитрый и сильный недруг'),
  Combo('Коса', 'Сердце', 'Внезапный разрыв'),
  Combo('Собака', 'Лиса', 'Друг хитрит, проверьте'),
  Combo('Аист', 'Дом', 'Переезд, перемена жилья'),
  Combo('Крысы', 'Рыбы', 'Утечка денег, потери'),
  Combo('Якорь', 'Солнце', 'Стабильный успех'),
  Combo('Гроб', 'Аист', 'После конца — новое начало'),
  Combo('Ключ', 'Книга', 'Разгадка тайны'),
  Combo('Лилии', 'Сердце', 'Зрелая, спокойная любовь'),
];

class Lesson {
  final String title, text, q;
  final List<String> opts;
  final int ok;
  const Lesson(this.title, this.text, this.q, this.opts, this.ok);
}

const LESSONS = [
  Lesson('История Марии Ленорман',
      'Знаменитая предсказательница Парижа. Колода из 36 карт вышла после её смерти.',
      'Сколько карт в колоде?', ['78', '36', '52'], 1),
  Lesson('Ленорман против Таро',
      'Таро — архетипы. Ленорман — конкретные ответы через сочетания.',
      'Основа чтения?', ['Сочетания', 'Одна карта', 'Гороскоп'], 0),
  Lesson('Обзор 36 карт',
      'Группы: люди, события, объекты, природа. У каждой карты ядро значения.',
      'Сигнификатор мужчины?', ['Всадник', 'Медведь', 'Мужчина'], 2),
  Lesson('Чтение пар',
      'Пара — предложение: первая карта субъект, вторая действие.',
      'Всадник плюс Письмо?', ['Дорога', 'Весть', 'Потери'], 1),
  Lesson('Чтение троек',
      'Тройка — законченная фраза. Средняя карта связывает крайние.',
      'Роль средней карты?', ['Итог', 'Мост', 'Фон'], 1),
  Lesson('Линии и зеркало',
      'Карты зеркалят через центр колоды, добавляя скрытый контекст.',
      'Что дают зеркала?', ['Время', 'Контекст', 'Имена'], 1),
  Lesson('Позиции времени',
      'Слева от сигнификатора прошлое, справа будущее.',
      'Где прошлое?', ['Справа', 'Снизу', 'Слева'], 2),
  Lesson('Сигнификаторы',
      'Мужчина (28) и Женщина (29) — герои. Расстояние показывает близость.',
      'Что показывает расстояние?', ['Возраст', 'Доход', 'Близость'], 2),
  Lesson('Grand Tableau: вводный',
      'Все 36 карт в схеме 8 на 4 плюс 4. Каждая позиция — дом.',
      'Сколько домов?', ['22', '78', '36'], 2),
  Lesson('Grand Tableau: продвинутый',
      'Ряды — события, колонки — проявление, диагонали — фон.',
      'Что показывают ряды?', ['События', 'Даты', 'Имена'], 0),
  Lesson('Система Домов',
      'У карты свой дом по номеру. Рыбы в доме Письма — деньги в документах.',
      'Что добавляет дом?', ['Время', 'Оттенок', 'Цвет'], 1),
  Lesson('Практические кейсы',
      'Лиса плюс Медведь в вопросе о работе — хитрый начальник.',
      'Лиса в работе?', ['Любовь', 'Дорога', 'Осторожность'], 2),
];

class OracleApp extends StatelessWidget {
  const OracleApp({super.key});
  @override
  Widget build(BuildContext c) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'serif',
        scaffoldBackgroundColor: EMERALD,
        colorScheme: const ColorScheme.dark(primary: GOLD),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A2A24),
          foregroundColor: GOLD,
          centerTitle: true,
        ),
        useMaterial3: true,
      ),
      home: const Onboarding(),
    );
  }
}

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final ctrl = PageController();
  bool flipped = false;
  bool combined = false;
  late final LCard first = DECK[Random().nextInt(36)];

  void next() {
    ctrl.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext c) {
    return MediaQuery(
      data: MediaQuery.of(c).copyWith(
        textScaler: TextScaler.linear(1),
      ),
      child: PageView(
        controller: ctrl,
        physics: const NeverScrollableScrollPhysics(),
        children: [_p1(), _p2(), _p3(), _p4(), _p5()],
      ),
    );
  }

  Widget _scr(Widget child) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF155A4E), EMERALD],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(child: child),
        ),
      ),
    );
  }

  Widget _back() {
    return Container(
      width: 100,
      height: 150,
      decoration: BoxDecoration(
        color: WINE,
        border: Border.all(color: GOLD, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.45),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: GOLD.withOpacity(.6)),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: const Text('36',
            style: TextStyle(color: GOLD, fontSize: 24)),
      ),
    );
  }

  Widget _front(String t) {
    return Container(
      width: 100,
      height: 150,
      decoration: BoxDecoration(
        color: PARCH,
        border: Border.all(color: GOLD, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.45),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Text(t,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: WINE, fontWeight: FontWeight.bold)),
    );
  }

  Widget _btn(String t, VoidCallback fn) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: GOLD,
        foregroundColor: EMERALD,
        elevation: 6,
      ),
      onPressed: fn,
      child: Text(t),
    );
  }

  Widget _p1() {
    return _scr(Column(mainAxisSize: MainAxisSize.min, children: [
      _back(),
      const SizedBox(height: 24),
      const Text('Когда все слишком запутано...',
          style: TextStyle(color: PARCH, fontSize: 18)),
      const SizedBox(height: 8),
      const Text('...нужен ясный ответ',
          style: TextStyle(color: GOLD, fontSize: 18)),
      const SizedBox(height: 28),
      _btn('Дальше', next),
    ]));
  }

  Widget _p2() {
    return _scr(Column(mainAxisSize: MainAxisSize.min, children: [
      GestureDetector(
        onTap: () => setState(() => flipped = true),
        child: flipped ? _front('Ключ') : _back(),
      ),
      const SizedBox(height: 24),
      Text(
        flipped
            ? '36 точных символов вместо туманных предсказаний'
            : 'Нажмите на карту',
        style: const TextStyle(color: PARCH, fontSize: 16),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 28),
      if (flipped) _btn('Дальше', next),
    ]));
  }

  Widget _p3() {
    return _scr(Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('Смысл рождается на стыке',
          style: TextStyle(color: GOLD, fontSize: 18)),
      const SizedBox(height: 8),
      const Text('Перетащите Солнце на Тучи',
          style: TextStyle(color: PARCH, fontSize: 14)),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        DragTarget<int>(
          onAccept: (d) => setState(() => combined = true),
          builder: (c, cand, rej) => _front('Тучи'),
        ),
        const SizedBox(width: 20),
        if (!combined)
          Draggable<int>(
            data: 1,
            feedback: _front('Солнце'),
            child: _front('Солнце'),
          ),
      ]),
      const SizedBox(height: 20),
      if (combined) ...[
        const Text('Тучи + Солнце',
            style: TextStyle(color: GOLD, fontSize: 16)),
        const Text('Трудности закончатся триумфом',
            style: TextStyle(color: PARCH, fontSize: 14)),
        const SizedBox(height: 20),
        _btn('Дальше', next),
      ],
    ]));
  }

  Widget _p4() {
    return _scr(Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('Что требует ясности?',
          style: TextStyle(color: GOLD, fontSize: 18)),
      const SizedBox(height: 20),
      Wrap(spacing: 8, children: [
        for (final t in ['Любовь', 'Деньги', 'Выбор'])
          ActionChip(label: Text(t), onPressed: next),
      ]),
    ]));
  }

  Widget _p5() {
    return _scr(Column(mainAxisSize: MainAxisSize.min, children: [
      _front(first.name),
      const SizedBox(height: 16),
      Text(first.general,
          style: const TextStyle(color: PARCH, fontSize: 14),
          textAlign: TextAlign.center),
      const SizedBox(height: 28),
      _btn('В приложение', () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Root()),
        );
      }),
    ]));
  }
}

class Root extends StatefulWidget {
  const Root({super.key});
  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int tab = 0;
  @override
  Widget build(BuildContext c) {
    const pages = [
      SpreadHome(),
      CardOfDay(),
      DiaryPage(),
      LearningPage(),
      ProfilePage(),
    ];
    return Scaffold(
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF0A2A24),
        indicatorColor: GOLD.withOpacity(.2),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.style_outlined), label: 'Расклад'),
          NavigationDestination(
              icon: Icon(Icons.wb_sunny_outlined), label: 'День'),
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined), label: 'Дневник'),
          NavigationDestination(
              icon: Icon(Icons.school_outlined), label: 'Учёба'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'Профиль'),
        ],
        onDestinationSelected: (i) => setState(() => tab = i),
        selectedIndex: tab,
      ),
    );
  }
}

class SpreadHome extends StatelessWidget {
  const SpreadHome({super.key});
  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ленорман: Оракул 36')),
      body: velvet(ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final s in SPREADS)
            Card(
              color: PARCH,
              elevation: 4,
              child: ListTile(
                title: Text(s.title,
                    style: const TextStyle(color: Color(0xFF2C2C2C))),
                onTap: () => Navigator.push(c,
                    MaterialPageRoute(builder: (_) => SpreadRun(s))),
              ),
            ),
          Card(
            color: PARCH,
            elevation: 4,
            child: ListTile(
              title: const Text('Grand Tableau (36 карт)',
                  style: TextStyle(color: Color(0xFF2C2C2C))),
              onTap: () => Navigator.push(c,
                  MaterialPageRoute(builder: (_) => const GrandTableau())),
            ),
          ),
          Card(
            color: PARCH,
            elevation: 4,
            child: ListTile(
              title: const Text('ИИ-оракул',
                  style: TextStyle(color: Color(0xFF2C2C2C))),
              onTap: () => Navigator.push(c,
                  MaterialPageRoute(builder: (_) => const AiOracle())),
            ),
          ),
        ],
      )),
    );
  }
}

class SpreadRun extends StatefulWidget {
  final SpreadType type;
  const SpreadRun(this.type, {super.key});
  @override
  State<SpreadRun> createState() => _SpreadRunState();
}

class _SpreadRunState extends State<SpreadRun> {
  late final List<LCard> cards;
  bool revealed = false;
  final TextEditingController q = TextEditingController();

  @override
  void initState() {
    super.initState();
    final idx = List.generate(DECK.length, (i) => i)..shuffle(Random());
    cards = idx.take(widget.type.positions.length).toList()
        .map((i) => DECK[i]).toList();
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.type.title)),
      body: velvet(ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: q,
            style: const TextStyle(color: PARCH),
            decoration: const InputDecoration(
              hintText: 'Ваш вопрос (необязательно)',
              hintStyle: TextStyle(color: Colors.white38),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: GOLD)),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 10, runSpacing: 10, children: [
            for (int i = 0; i < cards.length; i++)
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => revealed = true);
                },
                child: Container(
                  width: 86,
                  height: 129,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: revealed ? PARCH : WINE,
                    border: Border.all(color: GOLD, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    revealed ? '${cards[i].n}. ${cards[i].name}' : '✦',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: revealed ? WINE : GOLD,
                      fontSize: revealed ? 12 : 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 16),
          if (!revealed)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: GOLD,
                  foregroundColor: EMERALD,
                  elevation: 6),
              onPressed: () {
                HapticFeedback.mediumImpact();
                setState(() => revealed = true);
              },
              child: const Text('Открыть карты'),
            )
          else ...[
            for (int i = 0; i < cards.length; i++)
              Card(
                color: PARCH,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '${widget.type.positions[i]}: ${cards[i].name} — ${cards[i].general}',
                    style: const TextStyle(color: Color(0xFF2C2C2C)),
                  ),
                ),
              ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: GOLD, foregroundColor: EMERALD),
              icon: const Icon(Icons.save_alt),
              label: const Text('Сохранить в дневник'),
              onPressed: () {
                diary.insert(0, DiaryEntry(DateTime.now(), q.text, cards));
                ScaffoldMessenger.of(c).showSnackBar(
                    const SnackBar(content: Text('Сохранено')));
              },
            ),
          ],
        ],
      )),
    );
  }
}

class GrandTableau extends StatefulWidget {
  const GrandTableau({super.key});
  @override
  State<GrandTableau> createState() => _GrandTableauState();
}

class _GrandTableauState extends State<GrandTableau> {
  late final List<int> layout;
  late final Map<int, List<int>> posOf;
  late final Map<String, int> cellOf;

  @override
  void initState() {
    super.initState();
    layout = List.generate(36, (i) => i)..shuffle(Random());
    posOf = {};
    cellOf = {};
    for (var p = 0; p < 36; p++) {
      final r = p < 32 ? p ~/ 8 : 4;
      final col = p < 32 ? p % 8 : 2 + (p - 32);
      posOf[layout[p]] = [r, col];
      cellOf['$r,$col'] = p;
    }
  }

  List<int> neighbors(int p) {
    final rc = posOf[layout[p]]!;
    final res = <int>[];
    for (final d in [
      [rc[0], rc[1] - 1],
      [rc[0], rc[1] + 1],
      [rc[0] - 1, rc[1]],
      [rc[0] + 1, rc[1]],
    ]) {
      final x = cellOf['${d[0]},${d[1]}'];
      if (x != null) res.add(x);
    }
    return res;
  }

  Widget cell(int p) {
    final card = DECK[layout[p]];
    final sig = card.n == 28 || card.n == 29;
    return GestureDetector(
      onTap: () => open(p),
      child: Container(
        width: 40,
        height: 60,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: PARCH,
          border: Border.all(color: sig ? GOLD : WINE, width: sig ? 3 : 1),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text('${card.n}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF2C2C2C))),
      ),
    );
  }

  void open(int p) {
    final card = DECK[layout[p]];
    final nb = neighbors(p).map((x) => DECK[layout[x]].name).join(', ');
    showModalBottomSheet(
      context: context,
      backgroundColor: PARCH,
      builder: (c) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${card.n}. ${card.name}',
                  style: const TextStyle(
                      color: WINE,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Text('Дом ${p + 1}: ${DECK[p].name}'),
              const SizedBox(height: 8),
              Text(card.general),
              const SizedBox(height: 8),
              Text('Соседи: $nb'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grand Tableau')),
      body: velvet(ListView(children: [
        const SizedBox(height: 8),
        for (var r = 0; r < 4; r++)
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var col = 0; col < 8; col++) cell(r * 8 + col),
          ]),
        Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [for (var p = 32; p < 36; p++) cell(p)]),
        const SizedBox(height: 8),
      ])),
    );
  }
}

class AiOracle extends StatefulWidget {
  const AiOracle({super.key});
  @override
  State<AiOracle> createState() => _AiOracleState();
}

class _AiOracleState extends State<AiOracle> {
  final q = TextEditingController();
  String? answer;

  void ask() {
    final idx = List.generate(36, (i) => i)..shuffle(Random());
    final a = DECK[idx[0]];
    final b = DECK[idx[1]];
    final t = DECK[idx[2]];
    setState(() {
      answer = 'Сейчас вокруг вас «${a.name}»: '
          '${a.general.toLowerCase()}. '
          'Совет — «${b.name}»: ${b.general.toLowerCase()}. '
          'Итог — «${t.name}»: ${t.general.toLowerCase()}. '
          'Это развлекательный инструмент.';
    });
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('ИИ-оракул')),
      body: velvet(ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: q,
            maxLines: 3,
            style: const TextStyle(color: PARCH),
            decoration: const InputDecoration(
              hintText: 'Опишите ситуацию и вопрос',
              hintStyle: TextStyle(color: Colors.white38),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: GOLD)),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: GOLD,
                foregroundColor: EMERALD,
                elevation: 6),
            onPressed: ask,
            child: const Text('Спросить оракул'),
          ),
          const SizedBox(height: 16),
          if (answer != null)
            Card(
              color: PARCH,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(answer!,
                    style: const TextStyle(color: Color(0xFF2C2C2C))),
              ),
            ),
        ],
      )),
    );
  }
}

class CardOfDay extends StatelessWidget {
  const CardOfDay({super.key});
  @override
  Widget build(BuildContext c) {
    final card = DECK[Random(DateTime.now().day).nextInt(36)];
    return Scaffold(
      appBar: AppBar(title: const Text('Карта дня')),
      body: velvet(ListView(shrinkWrap: true, children: [
        Center(
          child: Container(
            width: 160,
            height: 240,
            margin: const EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: PARCH,
              border: Border.all(color: GOLD, width: 3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: GOLD.withOpacity(.35),
                  blurRadius: 30,
                ),
              ],
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Text('${card.n}. ${card.name}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: WINE,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(card.general,
              textAlign: TextAlign.center,
              style: const TextStyle(color: PARCH, fontSize: 16)),
        ),
      ])),
    );
  }
}

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});
  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Дневник раскладов')),
      body: velvet(diary.isEmpty
          ? const Center(
              child: Text('Пока пусто. Сделайте расклад!',
                  style: TextStyle(color: PARCH)))
          : ListView.builder(
              itemCount: diary.length,
              itemBuilder: (c, i) {
                final e = diary[i];
                return Card(
                  color: PARCH,
                  elevation: 3,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      e.question.isEmpty ? 'Без вопроса' : e.question,
                      style: const TextStyle(color: Color(0xFF2C2C2C)),
                    ),
                    subtitle: Text(
                      e.cards.map((k) => k.name).join(' + '),
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: ActionChip(
                      label: Text(e.status == 'pending'
                          ? '🟡'
                          : e.status == 'fulfilled'
                              ? '🟢'
                              : '🔴'),
                      onPressed: () {
                        setState(() {
                          e.status = e.status == 'pending'
                              ? 'fulfilled'
                              : e.status == 'fulfilled'
                                  ? 'failed'
                                  : 'pending';
                        });
                      },
                    ),
                  ),
                );
              },
            )),
    );
  }
}

class Trainer extends StatefulWidget {
  const Trainer({super.key});
  @override
  State<Trainer> createState() => _TrainerState();
}

class _TrainerState extends State<Trainer> {
  late Combo target;
  late List<String> options;
  String? picked;

  @override
  void initState() {
    super.initState();
    newRound();
  }

  void newRound() {
    final r = Random();
    target = COMBOS[r.nextInt(COMBOS.length)];
    final others = COMBOS.where((x) => x != target).toList();
    others.shuffle(r);
    options = others.take(3).map((x) => x.text).toList();
    options.add(target.text);
    options.shuffle(r);
    picked = null;
  }

  void pick(String o) {
    final ok = o == target.text;
    setState(() {
      picked = o;
      if (ok) {
        Game.streak += 1;
        Game.coins += 5;
      } else {
        Game.streak = 0;
      }
    });
  }

  Color colorOf(String o) {
    if (picked == null) return PARCH;
    if (o == target.text) return const Color(0xFF2D5A47);
    if (o == picked) return WINE;
    return PARCH;
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: Text('Тренажёр • серия ${Game.streak}')),
      body: velvet(ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Что означает эта пара?',
              style: TextStyle(color: GOLD, fontSize: 18)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (final t in [target.a, target.b])
              Container(
                width: 100,
                height: 56,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: PARCH,
                  border: Border.all(color: GOLD, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(t,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: WINE, fontWeight: FontWeight.bold)),
              ),
          ]),
          const SizedBox(height: 24),
          for (final o in options)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorOf(o),
                  foregroundColor: picked == null ? EMERALD : PARCH,
                ),
                onPressed: picked == null ? () => pick(o) : null,
                child: Text(o),
              ),
            ),
          if (picked != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: GOLD, foregroundColor: EMERALD),
              onPressed: () => setState(newRound),
              child: const Text('Следующая пара'),
            ),
        ],
      )),
    );
  }
}

class LessonPage extends StatefulWidget {
  final Lesson lesson;
  final int index;
  const LessonPage(this.lesson, this.index, {super.key});
  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  int? picked;

  @override
  Widget build(BuildContext c) {
    final l = widget.lesson;
    return Scaffold(
      appBar: AppBar(title: Text('Урок ${widget.index + 1}')),
      body: velvet(ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.title,
              style: const TextStyle(color: GOLD, fontSize: 18)),
          const SizedBox(height: 12),
          Text(l.text, style: const TextStyle(color: PARCH)),
          const SizedBox(height: 24),
          Text(l.q, style: const TextStyle(color: GOLD)),
          const SizedBox(height: 12),
          for (var i = 0; i < l.opts.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: picked == null
                      ? PARCH
                      : i == l.ok
                          ? const Color(0xFF2D5A47)
                          : picked == i
                              ? WINE
                              : PARCH,
                  foregroundColor: picked == null ? EMERALD : PARCH,
                ),
                onPressed: picked == null
                    ? () {
                        setState(() => picked = i);
                        if (i == l.ok) Game.coins += 10;
                      }
                    : null,
                child: Text(l.opts[i]),
              ),
            ),
          if (picked != null)
            Text(
              picked == l.ok
                  ? 'Верно! Плюс 10 монет'
                  : 'Верный ответ подсвечен.',
              style: const TextStyle(color: GOLD),
            ),
        ],
      )),
    );
  }
}

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});
  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: Text('Учёба • ${Game.coins} монет')),
      body: velvet(ListView(children: [
        ListTile(
          leading: const CircleAvatar(
              backgroundColor: GOLD,
              foregroundColor: EMERALD,
              child: Icon(Icons.bolt)),
          title: const Text('Тренажёр сочетаний',
              style: TextStyle(color: PARCH)),
          onTap: () => Navigator.push(c,
              MaterialPageRoute(builder: (_) => const Trainer())),
        ),
        for (var i = 0; i < LESSONS.length; i++)
          ListTile(
            leading: CircleAvatar(
                backgroundColor: GOLD,
                foregroundColor: EMERALD,
                child: Text('${i + 1}')),
            title: Text(LESSONS[i].title,
                style: const TextStyle(color: PARCH)),
            onTap: () => Navigator.push(
                c,
                MaterialPageRoute(
                    builder: (_) => LessonPage(LESSONS[i], i))),
          ),
      ])),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Подписка')),
      body: velvet(ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Судьба благоволит подготовленным',
              textAlign: TextAlign.center,
              style: TextStyle(color: GOLD, fontSize: 18)),
          const SizedBox(height: 16),
          _plan('Месяц', '399', null),
          _plan('Год', '2 490', '-48% · 2 месяца в подарок'),
          _plan('Навсегда', '5 990', 'Для коллекционеров'),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: GOLD,
                foregroundColor: EMERALD,
                minimumSize: const Size.fromHeight(52),
                elevation: 6),
            onPressed: () {},
            child: const Text('Начать 7 дней бесплатно'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Приложение носит развлекательный характер.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      )),
    );
  }

  Widget _plan(String t, String p, String? badge) {
    return Card(
      color: PARCH,
      elevation: 3,
      child: ListTile(
        title: Text(t,
            style: const TextStyle(color: Color(0xFF2C2C2C))),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(p,
                style: const TextStyle(
                    color: WINE, fontWeight: FontWeight.bold)),
            if (badge != null)
              Text(badge,
                  style: const TextStyle(
                      color: Color(0xFF2D5A47), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
