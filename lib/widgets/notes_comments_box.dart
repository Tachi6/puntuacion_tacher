import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/domain/entities/entities.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class NotesCommentsBox extends StatelessWidget {

  final String titulo;
  final WineTaste? selectedWineTaste;

  const NotesCommentsBox({super.key, required this.titulo, this.selectedWineTaste});

  @override
  Widget build(BuildContext context) {

    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: false);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        alignment: Alignment.topLeft,
        child: CustomElevatedButton(
          width: 150,
          height: 45,
          color: colors.surfaceContainerHighest,
          label: titulo,
          onPressed: () async {
            showCustomDialog(context, child: titulo == 'Notas de Cata'
              ? NotasCataBox(wineForm, selectedWineTaste)
              : ComentariosBox(wineForm, selectedWineTaste),
            );
          },
          style: TextStyle(color: colors.onSurface),
        ),
      ),
    );
  }
}

class NotasCataBox extends StatelessWidget {

  final CreateEditWineFormProvider wineForm;
  final WineTaste? selectedWineTaste;
  
  const NotasCataBox(this.wineForm, this.selectedWineTaste, {super.key});

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

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
                  initialValue: selectedWineTaste?.notasVista,
                  maxLines: 3, 
                  label: 'Vista',
                  readOnly: selectedWineTaste != null ? true : false,
                  onChanged: (value) {
                    timerVista?.cancel();
                    timerVista = Timer(const Duration(milliseconds: 500), () => wineForm.editNotasVista = value);
                  },
                ),

                _CustomTextFormField(
                  wineForm: wineForm,
                  initialValue: selectedWineTaste?.notasNariz,
                  maxLines: 3, 
                  label: 'Nariz',
                  readOnly: selectedWineTaste != null ? true : false,
                  onChanged: (value) {
                    timerNariz?.cancel();
                    timerNariz = Timer(const Duration(milliseconds: 500), () =>wineForm.editNotasNariz = value);
                  },
                ),

                _CustomTextFormField(
                  wineForm: wineForm,
                  initialValue: selectedWineTaste?.notasBoca,
                  maxLines: 3, 
                  label: 'Boca',
                  readOnly: selectedWineTaste != null ? true : false,
                  onChanged: (value) {
                    timerBoca?.cancel();
                    timerBoca = Timer(const Duration(milliseconds: 500), () => wineForm.editNotasBoca = value);
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
  const ComentariosBox(this.wineForm, this.selectedWineTaste, {super.key});

  final CreateEditWineFormProvider wineForm;
  final WineTaste? selectedWineTaste;
  
  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
   
    Timer? timer;

    return CustomAlertDialog(
      title: 'Añadir comentarios',
      content: SizedBox(
        width: size.width * 0.8,
        child: Form(
          child: _CustomTextFormField(
            wineForm: wineForm,
            initialValue: selectedWineTaste?.comentarios,
            maxLines: 5,
            label: 'Comentarios',
            readOnly: selectedWineTaste != null ? true : false,
            onChanged: (value) {
              timer?.cancel();
              timer = Timer(const Duration(milliseconds: 500), () => wineForm.editComentarios = value);
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
    this.onChanged,
    this.initialValue,
    required this.readOnly,
  });

  final CreateEditWineFormProvider wineForm;
  final int maxLines;
  final String label;
  final Function(String)? onChanged;
  final String? initialValue;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      canRequestFocus: !readOnly,
      textCapitalization: TextCapitalization.sentences,
      initialValue: initialValue ?? wineForm.comentarios,
      minLines: 1,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: onChanged,
    );
  }
}