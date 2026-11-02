import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/SelectOptionsWidget.dart';
import '../providers/select_options_provider.dart';

class AppSidebar extends StatefulWidget {
  const AppSidebar({super.key});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  final Map<String, String> _optionsWithEmails = {
    'Seleccionar': 'operador@vivawildbeverages.com',
    'Eliazar Chamorro': 'eliazar.chamorro@vivawildbeverages.com',
    'Fernando Chamorro': 'fernando.chamorro@vivawildbeverages.com',
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      height: 100,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'OPERADOR DE ENLATADO',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),

                // Email dinámico según operador
                Consumer<SelectOptionsProvider>(
                  builder: (context, provider, _) {
                    final selected = provider.getSelectedValue('operador') ?? 'Seleccionar';
                    final email = _optionsWithEmails[selected] ?? 'operador@vivawildbeverages.com';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        email,
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // Navegación
                ListTile(
                  leading: const Icon(Icons.precision_manufacturing),
                  title: const Text('Enlatado'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.qr_code),
                  title: const Text('Lote de Lata'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/lote_lata');
                  },
                ),
              ],
            ),
          ),

          // Select de operador (usa Provider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SelectOptionsWidget(
              id: 'operador',
              label: 'Operador',
              options: [
                'SELECCIONAR',
                'Eliazar Chamorro',
                'Fernando Chamorro',
              ],
              width: 400,
              height: 100,
              controlSource: 'libre',
            ),
          ),
          const SizedBox(height: 12),

          const Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'DEVELOPED BY IAB',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}