import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/custom_alert_dialog.dart';

InputDecoration _customInputDecorationText(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(fontSize: 14),
  );
}

// class CreateWineButton extends StatelessWidget {
//   const CreateWineButton({super.key, this.onPressed, this.onPressedSave});

//   final void Function()? onPressed;
//   final void Function()? onPressedSave; // TODO

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 96,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SearchWineButton(onPressed: onPressed),

//           AddWineButton(onPressedSave: onPressedSave),
//         ],
//       ),
//     );
//   }
// }

class AddWineButton extends StatelessWidget {
  const AddWineButton({
    super.key,
    required this.onPressedSave,
  });

  final void Function()? onPressedSave;

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WinesService>(context, listen: true);
    final colors = Theme.of(context).colorScheme;
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);

    return IconButton(
      icon: Icon(
        Icons.add, 
        color: colors.onSurface,
        size: 22
      ),
      onPressed: () {
        wineForm.setDefaultCreateWine();
        winesService.selectedWine = wineForm.wine;
        winesService.loadWines();
        showGeneralDialog(
          context: context,
          barrierDismissible: false, 
          pageBuilder: (context, animation, secondaryAnimation) {
            return PopScope(
              canPop: false,
              child: CreateWineDialog(onPressedSave: onPressedSave),
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
      },
    );
  }
}

class CreateWineDialog extends StatelessWidget {
  const CreateWineDialog({super.key, this.onPressedSave});

  final void Function()? onPressedSave;

  @override
  Widget build(BuildContext context) {

    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: false);

    return CustomAlertDialog(
      title: 'Añadir vino al listado', 
      content: CreateNewWineForm(wineForm), 
      cancelText: 'Cancelar', 
      saveText: 'Guardar',
      onPressedCancel: () {
        wineForm.setDefaultCreateWine();
        Navigator.pop(context, 'Cancelar');
      },
      onPressedSave: onPressedSave,
    );
  }
}

class CreateNewWineForm extends StatelessWidget {

  final CreateEditWineFormProvider wineForm;

  const CreateNewWineForm(this.wineForm, {super.key});

  String? defaultValidator(String? value) {
    return value!.isEmpty 
      ? 'Este campo es obligatorio'
      : null;
  }  

  @override
  Widget build(BuildContext context) {

    final Wines wine = wineForm.wine;
    final Size size = MediaQuery.of(context).size;
    final winesService = Provider.of<WinesService>(context, listen: true);

    return SizedBox(
      width: size.width * 0.8,
      child: SingleChildScrollView(
        reverse: false,
        child: Form(
          key: wineForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ficha técnica del vino', style: TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis)),
        
              TextFormFieldText(
                label: 'Vino', 
                initialValue: wine.vino, 
                onChanged: (value) => wine.vino = value, 
                validator: (value) {
                  if(value!.isEmpty) return 'Este campo es obligatorio';

                  final String wineCheckname = '${wine.vino.toLowerCase()}${wine.anada}${wine.tipo}${wine.region}';
                  final bool isWineCreated = winesService.winesByIndex.any((element) {
                    return '${element.vino.toLowerCase()}${element.anada}${element.tipo}${element.region}' == wineCheckname;
                  },);

                  if (isWineCreated) return 'El vino ya se encuentra en nuestra base de datos';

                  return null;
                },
              ),
              
              TextFormFieldText(
                label: 'Bodega', 
                initialValue: wine.bodega, 
                onChanged: (value) => wine.bodega = value, 
                validator: defaultValidator
              ),
               
              TextFormFieldSearch(
                label: 'Region', 
                wine: wine, 
                autocompleteWidth: size.width * 0.8
              ),
        
              TextFormFieldSearch(
                label: 'Tipo', 
                wine: wine, 
                autocompleteWidth: size.width * 0.8
              ),
              
              TextFormFieldText(
                label: 'Añada', 
                initialValue: wine.anada == -1 ? '' : wine.anada.toString(), 
                onChanged: (value) {
                  if (value != '') wine.anada = int.parse(value);
                }, 
                validator: (value) {
                  if (value!.isEmpty) return 'Este campo es obligatorio';

                  final int anada = int.parse(value);
                  final year = DateTime.now().year;
                      
                  if (anada < 1950 || anada > year ) return 'Añada no válida';

                  return null;                 
                }, 
                textInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,1}'))], 
                textInputType: TextInputType.number,
              ),
        
              const SizedBox(height: 24),
              
              const Text('Información opcional', style: TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis)),
              
              const SizedBox(height: 5),
              
              TextFormFieldText(
                label: 'Variedades', 
                initialValue: wine.variedades, 
                onChanged: (value) => wine.variedades = value, 
                maxLines: 2, validator: null
              ),
         
              TextFormFieldGraduacion(wine: wine),
          
              TextFormFieldText(
                label: 'Descripción', 
                initialValue: wine.descripcion, 
                onChanged: (value) => wine.descripcion = value,
                maxLines: 3, 
              validator: null),
          
              const SizedBox(height: 25),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
          
                  IconButton(
                    // color: colors.surface,
                    icon: const Icon(Icons.camera_alt_outlined),
                    onPressed: () {},
                  ),
                   
                  IconButton(
                    // color: colors.surface,
                    icon: const Icon(Icons.upload_file_outlined),
                    onPressed: () {},
                  ),
          
                  const SizedBox(width:10),
          
                  const Text('Añadir imagen del vino', style: TextStyle(fontSize: 14)),
                ],
              ),
            ]
          )
        ),
      ),
    );
  }
}

class TextFormFieldGraduacion extends StatelessWidget {
  const TextFormFieldGraduacion({
    super.key,
    required this.wine,
  });

  final Wines wine;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: wine.graduacion == '' ? '' : wine.graduacion.toString(),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,1}')),
      ],
      keyboardType: TextInputType.number,
      maxLines: 1,
      style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
      decoration: _customInputDecorationText('Graduación'),
      validator: (value) {
        if (value == '') {
          return null;
        }
        double graduation = double.parse(value!);
    
        if (graduation > 28 || graduation < 1) {
          return 'Valor alcohólico incorrecto';
        }
        return null;
      },
      onChanged: (value) => wine.graduacion = value,
    );
  }
}

class TextFormFieldAnada extends StatelessWidget {
  const TextFormFieldAnada({
    super.key,
    required this.wine,
  });

  final Wines wine;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: wine.anada == -1 ? '' : wine.anada.toString(),
      inputFormatters: [ // r'^(\d+)?\.?\d{0,1}'
        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,1}')),
      ],
      keyboardType: TextInputType.number,
      maxLines: 1,
      style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
      decoration: _customInputDecorationText('Añada'),
      validator: (value) {
            
        if (value == '') {
          return 'Este campo es obligatorio';
        }
            
        final int anada = int.parse(value!);
        final year = DateTime.now().year;
            
        if (anada < 1950 || anada > year ) {
          return 'Añada no válida';
        }
        return null;
      },
      onChanged: (value) {
        if (value != '') { 
          // final int anada = int.parse(value);
          wine.anada = int.parse(value);
        }
      },
    );
  }
}

class TextFormFieldText extends StatelessWidget {
  const TextFormFieldText({
    super.key,
    required this.label, 
    required this.onChanged, 
    required this.initialValue, 
    this.maxLines = 1,
    this.validator,
    this.textInputFormatter,
    this.textInputType,
  });

  final String label;
  final Function(String) onChanged;
  final String initialValue;
  final int? maxLines;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputType? textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      inputFormatters: textInputFormatter,
      textCapitalization: TextCapitalization.sentences,
      initialValue: initialValue,
      minLines: 1,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
      decoration: _customInputDecorationText(label),
      validator: validator,
      onChanged: onChanged,
    );
  }
}

class TextFormFieldSearch extends StatelessWidget {

  final String label;
  final Wines wine;
  final double autocompleteWidth;

  const TextFormFieldSearch({super.key, required this.label, required this.wine, required this.autocompleteWidth});

  List<String> get selectList{

    List<String> selectedList = [];

      if (label == 'Region') {
        selectedList = ItemsAddWineForm.region;
      }

      if (label == 'Añada') {
        selectedList = ItemsAddWineForm.anada();
      }

      if (label == 'Tipo') {
        selectedList = ItemsAddWineForm.tipos;
      }

    return selectedList;
  }

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return selectList.where((String option) {
          return option
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        if (label == 'Region') {
          wine.region = selection;
        }

        if (label == 'Añada') {
          wine.anada = int.parse(selection);
        }

        if (label == 'Tipo') {
          wine.tipo = selection;
        }
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        
        if (label == 'Region') {
          fieldTextEditingController.text = wine.region;
        }

        if (label == 'Añada') {
          if (wine.anada == -1){
            fieldTextEditingController.text = '';
          }
          else {
            fieldTextEditingController.text = wine.anada.toString();
          }
        }

        if (label == 'Tipo') {
          fieldTextEditingController.text = wine.tipo;
        }

        return TextFormField(
          scrollPadding: EdgeInsets.only(bottom: size.height * 0.361), // TODO comprobar que estos valores funcionan bien en todos los dispositivos
          textCapitalization: TextCapitalization.sentences,
          maxLines: 1,
          style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio';
            }

            final bool validateList = selectList.contains(value);

            if (!validateList) {
              return 'Selecciona un valor del listado';
            }
            return null;
          },
          decoration: _customInputDecorationText(label),
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
        );
      },
      optionsViewBuilder:(BuildContext context, AutocompleteOnSelected<String>onSelected, Iterable<String>options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            child: SizedBox(
              height: options.length * 56,
              width: autocompleteWidth,
              child: ListView.builder(
                padding: const EdgeInsetsDirectional.all(0),
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    contentPadding: const EdgeInsets.only(left: 20,right: 20),
                    onTap: () => onSelected(option),
                    title: Text(option, style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),),
                    tileColor: colors.surfaceContainerLow
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}