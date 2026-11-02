import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../sidebar.dart';
import '../../components/EditableCounterWidget.dart';
import '../../components/ComentarioWidget.dart';
import '../../components/ImagenLogoWidget.dart';
import '../../components/SelectOptionsWidget.dart';
import '../../components/TextInputWidget.dart';
import '../../components/ImagenTimeWidget.dart';
import '../../components/ModalButtonConfirm.dart';
import '../../components/ListOptionsWidget.dart';
import '../../providers/global_states_provider.dart';
import '../../providers/imagen_time_provider.dart';
import '../../providers/text_input_provider.dart';
import '../../providers/select_options_provider.dart';

class enlatadoTab1 extends StatefulWidget {
  const enlatadoTab1({super.key});

  @override
  State<enlatadoTab1> createState() => _enlatadoTab1State();
}

class _enlatadoTab1State extends State<enlatadoTab1> {

  void _handleAccept() {
    print('El usuario aceptó');
    final globalState = context.read<GlobalStatesProvider>();
    globalState.enableWidgets();
  }

  void _handleCancel() {
    print('El usuario canceló');
  }


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


  @override
  Widget build(BuildContext context) {
    final globalState = context.watch<GlobalStatesProvider>();
    final timeProvider = context.watch<ImagenTimeProvider>();
    final textInputProvider = context.watch<TextInputProvider>();
    final selectProvider = context.watch<SelectOptionsProvider>();
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

                // Fila 0
                Row(
                  children: [

                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 100,
                          height: 50,
                          child: ModalButtonConfirm(
                                id:"enlatado_tab1_modal1",
                                buttonText: 'CLEAN',
                                dialogTitle: 'CLEAN',
                                dialogContent: const Text('¿Seguro de Limpiar los tiempo?'),
                                buttonColor: const Color(0xFFCC9900), // fondo
                                textStyle: const TextStyle(fontSize: 10),
                                textColor: Colors.white, // textodialogContent: const Text('¿Quieres guardar los cambios?'),
                                actions: [

                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      print("Aceptar");
                                      globalState.enableWidgets();
                                      timeProvider.limpiarTiemposPorFiltro('enlatado');
                                    },
                                    child: const Text('Aceptar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      print("Cancelar");
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                ],
                              ),
                        ),
                      ),
                    ),


                  ],
                ),
                const SizedBox(height: 40),

                // Fila 1
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 400,
                          height: 100,
                          child: SelectOptionsWidget(
                            id: 'enlatado_tab1_select1',
                            label: 'Producto',
                            options: selectProvider.getOptionsList('enlatado_tab1_select1'),
                            width: 400,
                            height: 100,
                            controlSource: 'global_states_provider',

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
                          width: 400,
                          height: 100,
                          child: ListOptionsButtonWidget(
                            id: 'enlatado_tab1_list1',
                            label: 'Equipo de Enlatado',
                            options: [
                              'Tapetes y cepillo',
                              'CIP de enlatadora',
                              'Tanque de sanitizante latas',
                              'Latas del sabor correctas',
                              'Rejas vacias',
                              'Presión de aire comprimido',
                              'Máquina de velcorin',
                              'Tapas cercas de la enlatadora',
                              'Verificar codigo de impresión de lata',
                              'Basculas dentro y fuera de la enlatadora',
                              'Apertura de válvulas de glicol de linea de enlatado',
                              'Personal en posición',
                            ],
                            width: 250,
                            controlSource: 'global_states_provider',

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
                            id: 'enlatado_tab1_input1',
                            label: 'Lote del Producto',
                            width: 200,
                            height: 90,
                            controlSource: 'global_states_provider',
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
                        id: 'enlatado_tab1_counter1',
                        label: 'Cuantificados Velcorin (m³)',
                        controlSource: 'global_states_provider',
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
                        id: 'enlatado_tab1_comentario1',
                        label: 'Comentarios Generales',
                        controlSource: 'global_states_provider',
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                  ],
                ),
                const SizedBox(height: 40),

                // Fila 6
                Row(
                  children: [
                    const Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      child: 

                        ImagenTimeWidget(
                          id: 'enlatado_tab1_time1',
                          rutaAsset: 'assets/images/time.png',
                          labelArriba: 'Inicio',
                          altura: 50,
                          ancho: 50,
                          controlSource: 'global_states_provider',
                          onPressed: () {

                            if (selectProvider.getSelectedValue('operador')!="SELECCIONAR" && selectProvider.getSelectedValue('enlatado_tab1_select1')!="SELECCIONAR" && textInputProvider.getValue('enlatado_tab1_input1')!="" ){
                              print('Hora actualizada');
                              final globalState = context.read<GlobalStatesProvider>();
                              globalState.disableWidgets();
                            }
                            else{
                              mostrarMSG("Seleccionar Operador, Producto y Colocar Lote");
                            }

                          },
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