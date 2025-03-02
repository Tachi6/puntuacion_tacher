
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class NotesCommentsBox extends StatelessWidget {

  final String titulo;

  const NotesCommentsBox({super.key, required this.titulo});

  void showBox(BuildContext context, CreateEditWineFormProvider wineForm) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, 
      pageBuilder: (context, animation, secondaryAnimation) {
        return PopScope(
          canPop: false,
          child: titulo == 'Notas de Cata'
            ? NotasCataBox(wineForm)
            : ComentariosBox(wineForm),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: child
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: false);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        alignment: Alignment.topLeft,
        child: CustomElevatedButton(
          width: 145,
          height: 42.5,
          color: colors.surfaceContainerHighest,
          onPressed: () async {
            showBox(context, wineForm);
          },
          child: Text(titulo, style: TextStyle(color: colors.onSurface),),
        ),
      ),
    );
  }
}

class NotasCataBox extends StatelessWidget {

  final CreateEditWineFormProvider wineForm;
  
  const NotasCataBox(this.wineForm,{super.key});

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final screenProvider = Provider.of<ScreensProvider>(context);
    // Resto 1 porque el listado de userMultipleWineTaste empieza en 0, y las paginas tienen la pagina de inicio en el 0
    final multiplePage = screenProvider.multiplePage - 1;

    Timer? timerVista;
    Timer? timerNariz;
    Timer? timerBoca;

    return CustomAlertDialog(
      title: 'Añadir nota de cata',
      content: SizedBox(
        width: size.width * 0.8,
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CustomTextFormField(
                  wineForm: wineForm, 
                  maxLines: 3, 
                  label: 'Vista',
                  onChanged: (value) {
                    timerVista?.cancel();
                    timerVista = Timer(const Duration(milliseconds: 500), () {
                      if (multiplePage != -1) {
                        multipleTaste.updateWineTaste(() => multipleTaste.userMultipleTaste[multiplePage].notasVista = value); 
                        return;
                      }
                      wineForm.editNotasVista = value;
                    },);
                  },
                ),

                _CustomTextFormField(
                  wineForm: wineForm, 
                  maxLines: 3, 
                  label: 'Nariz',
                  onChanged: (value) {
                    timerNariz?.cancel();
                    timerNariz = Timer(const Duration(milliseconds: 500), () {
                      if (multiplePage != -1) {
                        multipleTaste.updateWineTaste(() => multipleTaste.userMultipleTaste[multiplePage].notasNariz = value); 
                        return;
                      }
                      wineForm.editNotasNariz = value;
                    },);
                  },
                ),

                _CustomTextFormField(
                  wineForm: wineForm, 
                  maxLines: 3, 
                  label: 'Boca',
                  onChanged: (value) {
                    timerBoca?.cancel();
                    timerBoca = Timer(const Duration(milliseconds: 500), () {
                      if (multiplePage != -1) {
                        multipleTaste.updateWineTaste(() => multipleTaste.userMultipleTaste[multiplePage].notasBoca = value); 
                        return;
                      }
                      wineForm.editNotasBoca = value;
                    },);
                  },
                ),
              ]
            ),
          ),
        ),
      ),
      cancelText: 'Descartar',
      saveText: 'Guardar',
      onPressedCancel: () {
        wineForm.clearNotas();
        Navigator.pop(context);
      },
      onPressedSave: () {
        Navigator.pop(context);
      },
    );
  }
}

class ComentariosBox extends StatelessWidget {
  const ComentariosBox(this.wineForm,{super.key});

  final CreateEditWineFormProvider wineForm;
  
  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final screenProvider = Provider.of<ScreensProvider>(context);
    // Resto 1 porque el listado de userMultipleWineTaste empieza en 0, y las paginas tienen la pagina de inicio en el 0
    final multiplePage = screenProvider.multiplePage - 1;
   
    Timer? timer;

    return CustomAlertDialog(
      title: 'Añadir comentarios',
      content: SizedBox(
        width: size.width * 0.8,
        child: Form(
          child: _CustomTextFormField(
            wineForm: wineForm, 
            maxLines: 5,
            label: 'Comentarios',
            onChanged: (value) {
              timer?.cancel();
              timer = Timer(const Duration(milliseconds: 500), () {
                if (multiplePage != -1) {
                  multipleTaste.updateWineTaste(() => multipleTaste.userMultipleTaste[multiplePage].comentarios = value); 
                  return;
                }
                wineForm.editComentarios = value;               
              },);
            },
          ),
        ),
      ), 
      cancelText: 'Descartar', 
      saveText: 'Guardar',
      onPressedCancel: () {
        wineForm.clearComentarios();            
        Navigator.pop(context);
      },
      onPressedSave: () {
          Navigator.pop(context);
        },
    );
  }
}

class _CustomTextFormField extends StatelessWidget {
  const _CustomTextFormField({
    required this.wineForm,
    required this.maxLines, 
    required this.label,
    this.onChanged
  });

  final CreateEditWineFormProvider wineForm;
  final int maxLines;
  final String label;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      initialValue: wineForm.comentarios,
      minLines: 1,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: onChanged,
    );
  }
}