
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';
import 'package:puntuacion_tacher/providers/providers.dart';

class NotesCommentsBox extends StatelessWidget {

  final String titulo;

  const NotesCommentsBox({super.key, required this.titulo});

  void showBox(BuildContext context, CreateEditWineFormProvider wineForm) {

    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (context) {
        if (titulo == 'Notas de Cata') {
          return NotasCataBox(wineForm);
        }
        else {
          return ComentariosBox(wineForm);
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        alignment: Alignment.topLeft,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromWidth(160),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 5),
            backgroundColor: const Color.fromARGB(64, 114, 47, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: Text(titulo, style: const TextStyle(fontSize: 14, color: Colors.black), maxLines: 2, textAlign: TextAlign.center),
          onPressed: () {
            showBox(context, wineForm);
          }
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      title: const Text('Notas de Cata', style: TextStyle(fontSize: 16, color: Colors.black)),
      content: SizedBox(
      width: size.width * 0.8,
      height: 301,
      child: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                initialValue: wineForm.notasVista,
                maxLines: 3,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor())),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor(), width: 2)),  
                  labelText: 'Vista',
                  labelStyle: TextStyle(color: redColor()),
                ),
                cursorColor: redColor(),
                onChanged: (value) {
                  wineForm.editNotasVista = value;
                },
              ),

              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                initialValue: wineForm.notasNariz,
                maxLines: 3,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor())),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor(), width: 2)),  
                  labelText: 'Nariz',
                  labelStyle: TextStyle(color: redColor()),
                ),
                cursorColor: redColor(),
                onChanged: (value) {
                  wineForm.editNotasNariz = value;
                },
              ),

              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                initialValue: wineForm.notasBoca,
                maxLines: 3,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor())),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor(), width: 2)),  
                  labelText: 'Boca',
                  labelStyle: TextStyle(color: redColor()),
                ),
                cursorColor: redColor(),
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
          child: Text('Descartar',  style: TextStyle(fontSize: 14, color: redColor()))
        ),

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Guardar',  style: TextStyle(fontSize: 14, color: redColor()))
        ),

      ],
    );
  }
}

class ComentariosBox extends StatelessWidget {

  final CreateEditWineFormProvider wineForm;
 
  const ComentariosBox(this.wineForm,{super.key});
  
  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      title: const Text('Añadir comentarios', style: TextStyle(fontSize: 16, color: Colors.black)),
      content: SizedBox(
        width: size.width * 0.8,
        height: 101,
        child: Form(
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            initialValue: wineForm.comentarios,
            maxLines: 5,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor())),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor(), width: 2)),  
              labelText: 'Comentarios',
              labelStyle: TextStyle(color: redColor()),
            ),
            cursorColor: redColor(),
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
          child: Text('Descartar', style: TextStyle(fontSize: 14, color: redColor()))
        ),

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          child: Text('Guardar', style: TextStyle(fontSize: 14, color: redColor()))
        )

      ],
    );
  }
}
