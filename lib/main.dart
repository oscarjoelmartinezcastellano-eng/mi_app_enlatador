import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../providers/comentario_provider.dart';
import '../providers/imagen_time_provider.dart';
import '../providers/select_options_provider.dart';
import '../providers/text_input_provider.dart';
import '../providers/counter_provider.dart';
import '../providers/global_states_provider.dart';
import '../providers/list_options_provider.dart';
import '../services/service.dart'; 

import 'screens/enlatado_page.dart';
import 'screens/loteLata_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar providers que requieren persistencia
  final comentarioProvider = ComentarioProvider();
  await comentarioProvider.loadComentarios();

  final counterProvider = CounterProvider();
  await counterProvider.loadCounters();

  final imagenTimeProvider = ImagenTimeProvider();
  await imagenTimeProvider.loadTiempos();

  final selectOptionsProvider = SelectOptionsProvider();
  await selectOptionsProvider.loadSelectedValues();

  final textInputProvider = TextInputProvider();
  await textInputProvider.loadValues();

  final globalStatesProvider = GlobalStatesProvider();
  await globalStatesProvider.loadWidgetsEnabled();

  final listOptionsProvider = ListOptionsProvider();
  await listOptionsProvider.loadSelectedValues();


  final allValues = {
    'get': 'Productos',
  };

  final service = ServiceHTTP();
  try {
    final response = await service.enviarDatos(allValues,tipo: 'enlatado_getConf');


    if (response.statusCode == 200){

      print("back..");

      // ✅ decodifica con UTF-8 correctamente
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));

      //final responseData = jsonDecode(response.body);
      print(responseData);
      selectOptionsProvider.setOptionsList('enlatado_tab1_select1', List<String>.from(responseData["data"]["data"]));
      selectOptionsProvider.setOptionsList('loteLata_select1', List<String>.from(responseData["data"]["data"]));
      } else {
        print("❌ Servidor respondió con error: ${response.statusCode}");
        // Aquí puedes mostrar un SnackBar, AlertDialog, etc.
      }
  } catch (e) {
    print("⚠️ No se pudo conectar al servidor: $e");
    // Aquí decides qué hacer: valores por defecto, mensaje, etc.
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ComentarioProvider>.value(value: comentarioProvider),
        ChangeNotifierProvider<CounterProvider>.value(value: counterProvider),
        ChangeNotifierProvider<ImagenTimeProvider>.value(value: imagenTimeProvider),
        ChangeNotifierProvider<SelectOptionsProvider>.value(value: selectOptionsProvider),
        ChangeNotifierProvider<TextInputProvider>.value(value: textInputProvider),
        ChangeNotifierProvider<GlobalStatesProvider>.value(value: globalStatesProvider),
        ChangeNotifierProvider<ListOptionsProvider>.value(value: listOptionsProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App con Sidebar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const EnlatadoPage(),
        '/lote_lata': (context) => const LoteLataPage(),
      },
    );
  }
}