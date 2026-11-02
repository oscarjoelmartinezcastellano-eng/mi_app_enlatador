import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sidebar.dart';
import '../components/EditableCounterWidget.dart';
import '../components/ComentarioWidget.dart';
import '../components/ImagenLogoWidget.dart';
import '../components/SelectOptionsWidget.dart';
import '../components/TextInputWidget.dart';
import '../providers/comentario_provider.dart';
import '../providers/select_options_provider.dart';
import '../providers/text_input_provider.dart';
import '../providers/counter_provider.dart';
import '../services/service.dart';  // importa tu servicio


class LoteLataPage extends StatefulWidget {
  const LoteLataPage({super.key});

  @override
  State<LoteLataPage> createState() => _LoteLataPageState();
}

class _LoteLataPageState extends State<LoteLataPage> {


/////////////////////////////////////////////////////////////////////////////

  Future<bool> mostrarMSG(String msg) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(msg),
      ),
    ) ?? false; // si el dialogo se cierra sin seleccionar, devuelve false
  }


//////////////////////////////////////////////////////////////////////////////


  Future<bool> mostrarConfirmacion() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar envío'),
        content: const Text('¿Seguro de enviar los datos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // No enviar
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Confirmar envío
            child: const Text('Enviar'),
          ),
        ],
      ),
    ) ?? false; // si el dialogo se cierra sin seleccionar, devuelve false
  }

  Future<void> enviar_datos() async {
    bool confirmado = await mostrarConfirmacion();

    if (!confirmado) {
      print('Envio cancelado por el usuario');
      return; // Salir si no confirma
    }

    // El resto del código de envío
    final counterProvider = context.read<CounterProvider>();
    final comentarioProvider = context.read<ComentarioProvider>();
    final selectProvider = context.read<SelectOptionsProvider>();
    final textInputProvider = context.read<TextInputProvider>();
    final allSelects = selectProvider.getAllSelectedValues();

    final allValues = {
        'counters': Map.fromEntries(
          counterProvider.getAllValues().entries.where((entry) => entry.key.contains('loteLata')),
        ),
        'comments': Map.fromEntries(
          comentarioProvider.getAllComentarios().entries.where((entry) => entry.key.contains('loteLata')),
        ),
        'selects': Map.fromEntries(
          selectProvider.getAllSelectedValues().entries.where((entry) => entry.key.contains('loteLata')),
        ),
        'inputs': Map.fromEntries(
          textInputProvider.getAllValues().entries.where((entry) => entry.key.contains('loteLata')),
        ),

        'operador': allSelects['operador'] ?? '', // agrega el operador si existe
      };

    final service = ServiceHTTP();
    final response = await service.enviarDatos(allValues,tipo: 'loteLata');

    String msgback = "";
    String imgback = "";
    if (response.statusCode == 200) {
      print('✅ Datos enviados correctamente');
      msgback = "Datos Enviados Correctamente";
      imgback="success";
      comentarioProvider.limpiarComentariosPorFiltro('loteLata');
      counterProvider.limpiarContersPorFiltro('loteLata');
      textInputProvider.limpiarTextInputsPorFiltro('loteLata');
      selectProvider.limpiarSelectsPorFiltro('loteLata');


    } else {
      print('⚠️ Error al enviar los datos');
      msgback = "Error al Enviar los Datos";
      imgback="error";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(""),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/'+imgback+'.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 16),
              Text(msgback),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );

  }


  @override
  Widget build(BuildContext context) {

    final selectProvider = context.watch<SelectOptionsProvider>();
    final textInputProvider = context.watch<TextInputProvider>();
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Lote de Lata'),backgroundColor: Colors.grey[200]),
        drawer: const AppSidebar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
              // Fila 0
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end, // Alineación a la izquierda
                        children: [
                          ImagenLogoWidget(
                            rutaAsset: 'assets/images/vivaLogo.png',
                            altura: 100,
                            ancho: 100,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),

                // Fila 1
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 400,
                          height: 100,
                          child: SelectOptionsWidget(
                            id: 'loteLata_select1',
                            label: 'Producto',
                            options: selectProvider.getOptionsList('loteLata_select1'),
                            width: 400,
                            height: 100,
                            controlSource: 'libre',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Fila 2
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          height: 90,
                          child: TextInputWidget(
                            id: 'loteLata_input1',
                            label: 'Lote de Lata',
                            width: 200,
                            height: 90,
                            controlSource: 'libre',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Fila 3
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          height: 90,
                          child: TextInputWidget(
                            id: 'loteLata_input2',
                            label: 'SKU de Lata',
                            width: 200,
                            height: 90,
                            controlSource: 'libre',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Fila 4
                Row(
                  children: [
                    Expanded(
                      child: EditableCounterWidget(
                        id: 'loteLata_counter1',
                        label: 'Cantidad de Latas',
                        controlSource: 'libre',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Fila 5
                Row(
                  children: [
                    const Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 2,
                      child: ComentarioWidget(
                        id: 'loteLata_comentario1',
                        label: 'Comentarios Generales',
                        controlSource: 'libre',
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                  ],
                ),
                const SizedBox(height: 100),

                // Fila 6
                Row(
                  children: [
                    const Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectProvider.getSelectedValue('operador')!="SELECCIONAR" && selectProvider.getSelectedValue('loteLata_select1')!="SELECCIONAR" && textInputProvider.getValue('loteLata_input1')!="" ){
                              enviar_datos();
                            }
                            else{
                              mostrarMSG("Seleccionar Operador, Producto y Colocar Lote");
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(200, 50),
                            backgroundColor: Colors.green.shade500,
                            foregroundColor: Colors.white, // Color del texto
                          ),
                          child: const Text('Enviar datos'),
                        ),
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                  ],
                ),

                const SizedBox(height: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}