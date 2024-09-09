
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
          width: 150,
          height: 35,
          color: colors.surfaceContainerHighest,
          onPressed: () {
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

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      title: const Text('Notas de Cata'),
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
                    wineForm.editNotasVista = value;
                  },
                ),

                _CustomTextFormField(
                  wineForm: wineForm, 
                  maxLines: 3, 
                  label: 'Nariz',
                  onChanged: (value) {
                    wineForm.editNotasNariz = value;
                  },
                ),

                _CustomTextFormField(
                  wineForm: wineForm, 
                  maxLines: 3, 
                  label: 'Boca',
                  onChanged: (value) {
                    wineForm.editNotasBoca = value;
                  },
                ),
              ]
            ),
          ),
        ),
      ),
    actions: [
        TextButton(
          onPressed: () {
            wineForm.clearNotas();
            Navigator.pop(context);
          },
          child: const Text('Descartar')
        ),

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Guardar')
        ),
      ],
    );
  }
}

class ComentariosBox extends StatelessWidget {
  const ComentariosBox(this.wineForm,{super.key});

  final CreateEditWineFormProvider wineForm; 
  
  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      title: const Text('Añadir comentarios'),
      content: SizedBox(
        width: size.width * 0.8,
        child: Form(
          child: _CustomTextFormField(
            wineForm: wineForm, 
            maxLines: 5,
            label: 'Comentarios',
            onChanged: (value) {
              wineForm.editCommentarios = value;
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            wineForm.clearComentarios();            
            Navigator.pop(context);
          },
          child: const Text('Descartar')
        ),
    
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          child: const Text('Guardar')
        )
      ],
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
