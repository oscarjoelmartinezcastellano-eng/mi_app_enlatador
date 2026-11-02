import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../sidebar.dart';
import '../../components/EditableCounterWidget.dart';
import '../../components/ComentarioWidget.dart';
import '../../components/ImagenLogoWidget.dart';
import '../../components/SelectOptionsWidget.dart';
import '../../providers/comentario_provider.dart';
import '../../providers/select_options_provider.dart';
import '../../providers/text_input_provider.dart';
import '../../providers/counter_provider.dart';
import '../../providers/imagen_time_provider.dart';
import '../../providers/list_options_provider.dart';
import '../../providers/global_states_provider.dart';
import '../../services/service.dart'; 

class enlatadoTab2 extends StatefulWidget {
  const enlatadoTab2({super.key});

  @override
  State<enlatadoTab2> createState() => _enlatadoTab2State();
}

class _enlatadoTab2State extends State<enlatadoTab2> {


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

    final counterProvider = context.read<CounterProvider>();
    final comentarioProvider = context.read<ComentarioProvider>();
    final selectProvider = context.read<SelectOptionsProvider>();
    final textInputProvider = context.read<TextInputProvider>();
    final timeProvider = context.read<ImagenTimeProvider>();
    final listProvider = context.read<ListOptionsProvider>();
    final allSelects = selectProvider.getAllSelectedValues();

    final allValues = {
      'counters': Map.fromEntries(
        counterProvider.getAllValues().entries.where((entry) => entry.key.contains('enlatado')),
      ),
      'comments': Map.fromEntries(
        comentarioProvider.getAllComentarios().entries.where((entry) => entry.key.contains('enlatado')),
      ),
      'selects': Map.fromEntries(
        selectProvider.getAllSelectedValues().entries.where((entry) => entry.key.contains('enlatado')),
      ),
      'inputs': Map.fromEntries(
        textInputProvider.getAllValues().entries.where((entry) => entry.key.contains('enlatado')),
      ),
      'lists': Map.fromEntries(
        listProvider.getAllSelectedValues().entries.where((entry) => entry.key.contains('enlatado')),
      ),
      'times': Map.fromEntries(
        timeProvider.getAllTiempos().entries.where((entry) => entry.key.contains('enlatado')),
      ),
      'operador': allSelects['operador'] ?? '', // agrega el operador si existe
    };

    final service = ServiceHTTP();
    final response = await service.enviarDatos(allValues,tipo: 'enlatado');

    String msgback = "";
    String imgback = "";
    if (response.statusCode == 200) {
      print('✅ Datos enviados correctamente');
      msgback = "Datos Enviados Correctamente";
      imgback="success";
      comentarioProvider.limpiarComentariosPorFiltro('enlatado');
      counterProvider.limpiarContersPorFiltro('enlatado');
      textInputProvider.limpiarTextInputsPorFiltro('enlatado');
      selectProvider.limpiarSelectsPorFiltro('enlatado');
      listProvider.limpiarListsPorFiltro('enlatado');
      timeProvider.limpiarTiemposPorFiltro('enlatado');

      final globalState = context.read<GlobalStatesProvider>();
      globalState.enableWidgets();


    } else {
      print('⚠️ Error al enviar los datos');
      msgback = "Error al Enviar los Datos...";
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
    final textInputProvider = context.watch<TextInputProvider>();
    final selectProvider = context.watch<SelectOptionsProvider>();
    final timeProvider = context.watch<ImagenTimeProvider>();

    return SafeArea(
      child: Scaffold(
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
                      child: EditableCounterWidget(
                        id: 'enlatado_tab2_counter1',
                        label: 'Cuantificados Enlatadora (lt)',
                        controlSource: 'libre',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: EditableCounterWidget(
                        id: 'enlatado_tab2_counter2',
                        label: 'Cuantificados Velcorin (m³)',
                        controlSource: 'libre',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Fila 2
                Row(
                  children: [
                    Expanded(
                      child: EditableCounterWidget(
                        id: 'enlatado_tab2_counter3',
                        label: 'Latas Obtenidas',
                        controlSource: 'libre',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: EditableCounterWidget(
                        id: 'enlatado_tab2_counter4',
                        label: 'Latas Microbiología',
                        controlSource: 'libre',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Fila 3
                Row(
                  children: [
                    Expanded(
                      child: EditableCounterWidget(
                        id: 'enlatado_tab2_counter5',
                        label: 'Latas Bajo Peso',
                        controlSource: 'libre',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: EditableCounterWidget(
                        id: 'enlatado_tab2_counter6',
                        label: 'Latas Golpeadas con Producto',
                        controlSource: 'libre',
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
                        id: 'enlatado_tab2_counter7',
                        label: 'Latas Prueba CO2',
                        controlSource: 'libre',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: EditableCounterWidget(
                        id: 'enlatado_tab2_counter8',
                        label: 'Latas Dañadas sin Producto',
                        controlSource: 'libre',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Fila 5
                Row(
                  children: [
                    Expanded(
                      child: EditableCounterWidget(
                        id: 'enlatado_tab2_counter9',
                        label: 'Merma Purgas(lt)',
                        controlSource: 'libre',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: EditableCounterWidget(
                        id: 'enlatado_tab2_counter10',
                        label: 'Sobre LLenado(ml)',
                        controlSource: 'libre',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),


                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          height: 100,
                          child: SelectOptionsWidget(
                            id: 'enlatado_tab2_select1',
                            label: 'Ubicación de Latas',
                            options: [
                              'SELECCIONAR',
                              'SECADO',
                              'AREA PROCESO',
                              'AREA INSUMOS',
                              'AREA TERMINADO'
                            ],
                            width: 200,
                            height: 100,
                            controlSource: 'libre',
  
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Comentario
                Row(
                  children: [
                    const Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 2,
                      child: ComentarioWidget(
                        id: 'enlatado_tab2_comentario1',
                        label: 'Comentarios Generales',
                        controlSource: 'libre',
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                  ],
                ),
                const SizedBox(height: 20),


                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: ElevatedButton(

                          onPressed: () {

                            if (selectProvider.getSelectedValue('operador')!="SELECCIONAR" && selectProvider.getSelectedValue('enlatado_tab1_select1')!="SELECCIONAR" && textInputProvider.getValue('enlatado_tab1_input1')!="" && timeProvider.getTime('enlatado_tab1_time1')!="00:00:00" ){
                              enviar_datos();
                            }
                            else{
                              mostrarMSG("Seleccionar Operador, Producto, Colocar Lote y Dar Inicio");
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
                  ],
                ),

                const SizedBox(height: 3), // espacio inferior
              ],
            ),
          ),
        ),
      ),
    );
  }
}