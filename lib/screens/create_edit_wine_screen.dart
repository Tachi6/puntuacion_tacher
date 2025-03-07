import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class CreateEditWineScreen extends StatelessWidget {
  const CreateEditWineScreen({super.key, required this.saveEndAction});

  final void Function() saveEndAction;

  @override
  Widget build(BuildContext context) {
    
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 48,
          titleSpacing: 0,
          title: const Text('Crear vino'),
          leading: IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus(); // Quitar teclado
              wineForm.resetSettings();
              Navigator.pop(context);
              wineForm.autovalidateMode = AutovalidateMode.disabled;
            }, 
            icon: const Icon(Icons.arrow_back)
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 58),
          child: SingleChildScrollView(
            child: CreateEditWineForm()  
          ),
        ),
        bottomSheet: _FixedBottomSheet(saveEndAction), // TODO hacer desaparecer y aparecer
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

class _FixedBottomSheet extends StatelessWidget {
  const _FixedBottomSheet(this.saveEndAction);

  final void Function() saveEndAction;

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WineServices>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);

    return Container(
      height: 58,
      alignment: Alignment.center,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomElevatedButton(
            width: 120,
            label: 'Cancelar',
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus(); // Quitar teclado
              wineForm.resetSettings();
              Navigator.pop(context);
              wineForm.autovalidateMode = AutovalidateMode.disabled;
            },
          ),
    
          CustomElevatedButton(
            width: 120,
            label: 'Guardar',
            isSendingLabel: 'Guardando',
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus(); // Quitar teclado

              wineForm.autovalidateMode = AutovalidateMode.always;
              if (wineForm.wine.imagenVino != null && wineForm.wine.imagenVino != '') {
                final urlChecked = await winesService.isValidImage(wineForm.wine.imagenVino);
                if (!urlChecked && context.mounted) {
                  NotificationServices.showFlushBar('URL DE IMAGEN DE VINO INCORRECTA', context);
                  return;
                }
              }
              if (wineForm.wine.logoBodega != null && wineForm.wine.logoBodega != '') {
                final urlChecked = await winesService.isValidImage(wineForm.wine.logoBodega);
                if (!urlChecked && context.mounted) {
                  NotificationServices.showFlushBar('URL DE LOGO BODEGA INCORRECTA', context);
                  return;
                }
              }
              if (wineForm.isValidForm()) {
                wineForm.wine.nombre = '${wineForm.wine.vino} ${wineForm.wine.anada.toString()}';
                final String wineId = await winesService.createWine(wineForm.wine);
                wineForm.setWineId(wineId);
                if (context.mounted) saveEndAction();
                wineForm.autovalidateMode = AutovalidateMode.disabled;
              }
            }
          ),
        ],
      ),
    );
  }
}

InputDecoration _customInputDecorationText(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(fontSize: 14),
  );
}

class CreateEditWineForm extends StatelessWidget {
  const CreateEditWineForm({super.key});

  String? defaultValidator(String? value) {
    return value!.isEmpty 
      ? 'Este campo es obligatorio'
      : null;
  }  

  @override
  Widget build(BuildContext context) {

    final wineFormProvider = context.watch<CreateEditWineFormProvider>();
    final winesService = Provider.of<WineServices>(context, listen: true);
    final Wines wine = wineFormProvider.wine;
    final Size size = MediaQuery.of(context).size;

    return Form(
      key: wineFormProvider.formKey,
      autovalidateMode: wineFormProvider.autovalidateMode,
      child: Column( // TODO:gestionar scroll para que suba mas
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),

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
            autocompleteWidth: size.width - 40
          ),
    
          TextFormFieldSearch(
            label: 'Tipo', 
            wine: wine, 
            autocompleteWidth: size.width - 40
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
              final year = DateTime.now().toUtc().year;
                  
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
            maxLines: 2, 
            validator: null
          ),
     
          TextFormFieldGraduacion(wine: wine),
        
          TextFormFieldText(
            label: 'Notas de cata Vista', 
            initialValue: wine.notaVista, 
            onChanged: (value) => wine.notaVista = value, 
            maxLines: 3, 
            validator: null
          ),
        
          TextFormFieldText(
            label: 'Notas de cata Nariz', 
            initialValue: wine.notaNariz, 
            onChanged: (value) => wine.notaNariz = value, 
            maxLines: 3, 
            validator: null
          ),
        
          TextFormFieldText(
            label: 'Notas de cata Boca', 
            initialValue: wine.notaBoca, 
            onChanged: (value) => wine.notaBoca = value, 
            maxLines: 3, 
            validator: null
          ),
        
      
          TextFormFieldText(
            label: 'Descripción', 
            initialValue: wine.descripcion, 
            onChanged: (value) => wine.descripcion = value,
            maxLines: 3, 
            validator: null
          ),
      
          TextFormFieldText(
            label: 'Imagen del vino (url)', 
            initialValue: wine.imagenVino ?? '', 
            onChanged: (value) => wine.imagenVino = value,
            maxLines: 1, 
            validator: null,
          ),
      
          TextFormFieldText(
            label: 'Logo de la bodega (url)', 
            initialValue: wine.logoBodega ?? '', 
            onChanged: (value) => wine.logoBodega = value,
            maxLines: 1, 
            validator: null,
          ),
      
          const SizedBox(height: 25),
        ]
      )
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
        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?[\,\.]?\d{0,1}')),
      ],
      keyboardType: TextInputType.text,
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
      onChanged: (value) => wine.graduacion = value.replaceAll(',', '.'),
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
        final year = DateTime.now().toUtc().year;
            
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
      if (label == 'Tipo') {
        selectedList = ItemsAddWineForm.tipos;
      }
    return selectedList;
  }

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);
    final size = MediaQuery.of(context).size;

    return Autocomplete<String>(
      // initialValue: TextEditingValue(text: label == 'Region' ? wine.region : wine.tipo), // TODO: para editar???
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return selectList.where((String option) {
          return removeDiacritics(option.trim().toLowerCase())
            .startsWith(removeDiacritics(textEditingValue.text.trim().toLowerCase()));
        });
      },
      onSelected: (String selection) {
        if (label == 'Region') {
          wine.region = selection;
        }
        if (label == 'Tipo') {
          wine.tipo = selection;
        }
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        
        // if (label == 'Region') { // TODO: no se si lo necesito, quizas para editar vinos
        //   fieldTextEditingController.text = wine.region;
        // }
        // if (label == 'Tipo') {
        //   fieldTextEditingController.text = wine.tipo;
        // }

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
                    tileColor: themeColor.isDarkMode
                      ? colors.inverseSurface
                      : colors.surface,
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