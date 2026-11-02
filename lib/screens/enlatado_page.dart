import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'tabs/enlatado_tab1.dart';
import 'tabs/enlatado_tab2.dart';

class EnlatadoPage extends StatefulWidget {
  const EnlatadoPage({super.key});

  @override
  State<EnlatadoPage> createState() => _EnlatadoPageState();
}

class _EnlatadoPageState extends State<EnlatadoPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enlatado'),
        backgroundColor: Colors.grey[200],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Inicio Enlatado', icon: Icon(Icons.play_arrow)),
            Tab(text: 'Fin Enlatado', icon: Icon(Icons.stop)),
          ],
        ),
      ),
      drawer: const AppSidebar(),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          enlatadoTab1(),
          enlatadoTab2(),
        ],
      ),
    );
  }
}