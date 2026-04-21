import 'package:flutter/material.dart';

void main() {
  runApp(const ZAIAllInOneApp());
}

class ZAIAllInOneApp extends StatelessWidget {
  const ZAIAllInOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZAI All In One',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const TodoPage(),
    const CalculatorPage(),
    const NotesPage(),
    const AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Todo'),
          NavigationDestination(icon: Icon(Icons.calculate), label: 'Calc'),
          NavigationDestination(icon: Icon(Icons.note), label: 'Notes'),
          NavigationDestination(icon: Icon(Icons.info), label: 'About'),
        ],
      ),
    );
  }
}

// 1. HOME PAGE
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZAI All In One'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flash_on, size: 120, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text('Welcome to ZAI Apps', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text('All In One Solution 🔥', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 40),
            const Text('বস, নিচের মেনু থেকে পার্ট সিলেক্ট করো ১৮ XOXO', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// 2. TODO PAGE
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<String> _todos = ['Gradle বাগ মারো ✅', 'APK বিল্ড করো ✅'];
  final _controller = TextEditingController();

  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todos.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZAI Todo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'নতুন কাজ লিখো...'))),
                IconButton(onPressed: _addTodo, icon: const Icon(Icons.add))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_todos[index]),
                trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _todos.removeAt(index))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 3. CALCULATOR PAGE
class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = "0";
  String _input = "";

  void _buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        _input = ""; _output = "0";
      } else if (value == "=") {
        try {
          _output = _calculate(_input).toString();
        } catch (e) { _output = "Error"; }
      } else { _input += value; _output = _input; }
    });
  }

  double _calculate(String input) {
    input = input.replaceAll('×', '*').replaceAll('÷', '/');
    return double.parse(input); // Simple calc, upgrade later
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _buttonPressed(text),
          child: Text(text, style: const TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZAI Calculator')),
      body: Column(
        children: [
          Expanded(child: Container(alignment: Alignment.bottomRight, padding: const EdgeInsets.all(24), child: Text(_output, style: const TextStyle(fontSize: 48)))),
          Column(children: [
            Row(children: ['7','8','9','÷'].map(_buildButton).toList()),
            Row(children: ['4','5','6','×'].map(_buildButton).toList()),
            Row(children: ['1','2','3','-'].map(_buildButton).toList()),
            Row(children: ['C','0','=','+'].map(_buildButton).toList()),
          ])
        ],
      ),
    );
  }
}

// 4. NOTES PAGE
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZAI Notes')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(maxLines: null, decoration: InputDecoration(hintText: 'বস, তোমার নোট এখানে লিখো...', border: InputBorder.none)),
      ),
    );
  }
}

// 5. ABOUT PAGE
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About ZAI')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ZAI All In One', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Version 1.0'),
            SizedBox(height: 20),
            Text('Made by বস 🔥 ১৮ XOXO'),
            SizedBox(height: 10),
            Text('Powered by Flutter'),
          ],
        ),
      ),
    );
  }
}
