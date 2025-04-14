import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:diacritic/diacritic.dart';

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
              Navigator.pop(context, false);
              wineForm.autovalidateMode = AutovalidateMode.disabled;
            }, 
            icon: const Icon(Icons.arrow_back)
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: CreateEditWineForm(),
        ),
        extendBody: true,
        bottomNavigationBar: _FixedBottomSheet(saveEndAction),
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
    final colors = Theme.of(context).colorScheme;
    final double bottomPadding = context.read<ScreenElementsSizeProvider>().bottomElementHeight;

    return Material(
      elevation: 1,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      color: colors.surfaceContainerLow,
      child: Container(
        height: 58 + bottomPadding,
        padding: EdgeInsets.only(bottom: bottomPadding),
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
                Navigator.pop(context, false);
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
                    NotificationServices.showSnackbar('IMAGEN DE VINO ERRONEA O FORMATO NO ACEPTADO', context);
                    return;
                  }
                }
                if (wineForm.wine.logoBodega != null && wineForm.wine.logoBodega != '') {
                  final urlChecked = await winesService.isValidImage(wineForm.wine.logoBodega);
                  if (!urlChecked && context.mounted) {
                    NotificationServices.showSnackbar('LOGO BODEGA ERRONEO O FORMATO NO ACEPTADO', context);
                    return;
                  }
                }
                if (wineForm.isValidForm()) {
                  wineForm.wine.nombre = '${wineForm.wine.vino} ${wineForm.wine.anada.toString()}';
                  if (wineForm.wine.imagenVino == '') wineForm.wine.imagenVino = null;
                  if (wineForm.wine.logoBodega == '') wineForm.wine.logoBodega = null;
                  final String wineId = await winesService.createWine(wineForm.wine);
                  wineForm.setWineId(wineId);
                  if (context.mounted) saveEndAction();
                  wineForm.autovalidateMode = AutovalidateMode.disabled;
                }
              }
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _customInputDecorationText(String label, TextTheme styles) {
  return InputDecoration(
    labelText: label,
    labelStyle: styles.bodySmall,
    contentPadding: const EdgeInsets.fromLTRB(16, 16, 12, 10),
    floatingLabelStyle: styles.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1)
    ),
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

    final List<Widget> children = [
      const SizedBox(height: 5),
  
      const Text('Ficha técnica del vino', style: TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis)),
      
      TextFormFieldText(
        label: 'Vino', 
        initialValue: wine.vino, 
        onChanged: (value) => wine.vino = value, 
        validator: (value) {
          if(value!.isEmpty) return 'Este campo es obligatorio';
    
          final String wineCheckname = '${removeDiacritics(wine.vino.replaceAll(' ', '').toLowerCase())}${wine.anada}${wine.tipo}${wine.region}';
          final bool isWineCreated = winesService.winesByIndex.any((element) {
            return '${removeDiacritics(element.vino.replaceAll(' ', '').toLowerCase())}${element.anada}${element.tipo}${element.region}' == wineCheckname;
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
        autocompleteWidth: size.width - 20
      ),
      
      TextFormFieldSearch(
        label: 'Tipo', 
        wine: wine, 
        autocompleteWidth: size.width - 20
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
        textInputFormatter: [
          FilteringTextInputFormatter.deny(RegExp(r'\D')),
          FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{1,4}')),
        ], 
        textInputType: const TextInputType.numberWithOptions(decimal: false, signed: true),
        textInputAction: TextInputAction.done,
      ),
      
      const SizedBox(height: 20),
      
      const Text('Información opcional', style: TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis)),
      
      TextFormFieldText(
        label: 'Variedades', 
        initialValue: wine.variedades, 
        onChanged: (value) => wine.variedades = value, 
        maxLines: 2, 
        validator: null
      ),
  
      TextFormFieldText(
        label: 'Graduación', 
        initialValue: wine.graduacion, 
        onChanged: (value) => wine.graduacion = value.replaceAll(',', '.'), 
        validator: (value) {
          if (value == '') {
            return null;
          }
          double graduation = double.parse(value!.replaceAll(',', '.'));
      
          if (graduation > 28 || graduation < 1) {
            return 'Valor alcohólico incorrecto';
          }
          return null;
        },
        textInputType: const TextInputType.numberWithOptions(decimal: true, signed: true),
        textInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^([0-9]{1,2})([\,\.]{0,1})([0-9]{0,1})'))],
      ),
    
      TextFormFieldText(
        label: 'Notas de cata Vista oficial', 
        initialValue: wine.notaVista, 
        onChanged: (value) => wine.notaVista = value, 
        maxLines: 3, 
        validator: null
      ),
    
      TextFormFieldText(
        label: 'Notas de cata Nariz oficial', 
        initialValue: wine.notaNariz, 
        onChanged: (value) => wine.notaNariz = value, 
        maxLines: 3, 
        validator: null
      ),
    
      TextFormFieldText(
        label: 'Notas de cata Boca oficial', 
        initialValue: wine.notaBoca, 
        onChanged: (value) => wine.notaBoca = value, 
        maxLines: 3, 
        validator: null
      ),
    
  
      TextFormFieldText(
        label: 'Descripción oficial', 
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
        textInputType: TextInputType.url,
      ),
  
      TextFormFieldText(
        label: 'Logo de la bodega (url)', 
        initialValue: wine.logoBodega ?? '', 
        onChanged: (value) => wine.logoBodega = value,
        maxLines: 1, 
        validator: null,
        textInputType: TextInputType.url,
        textInputAction: TextInputAction.done,
      ),

      const SizedBox(height: 10),
    ];

    return Form(
      key: wineFormProvider.formKey,
      autovalidateMode: wineFormProvider.autovalidateMode,
      child: ListView.builder(
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
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
    this.textInputAction,
  });

  final String label;
  final Function(String) onChanged;
  final String initialValue;
  final int? maxLines;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        keyboardType: textInputType ?? TextInputType.text,
        textInputAction: textInputAction ?? TextInputAction.next,
        inputFormatters: textInputFormatter,
        textCapitalization: TextCapitalization.sentences,
        initialValue: initialValue,
        minLines: 1,
        maxLines: maxLines,
        style: styles.bodySmall!.copyWith(overflow: TextOverflow.ellipsis),
        decoration: _customInputDecorationText(label, styles),
        validator: validator,
        onChanged: onChanged,
      ),
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
    final styles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Autocomplete<String>(
        initialValue: TextEditingValue(text: label == 'Region' ? wine.region : wine.tipo), // TODO: para editar???
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          }
          return selectList.where((String option) {
            if (label == 'Region') {
              return removeDiacritics(option.trim().toLowerCase())
                .startsWith(removeDiacritics(textEditingValue.text.trim().toLowerCase()));
            }
            return removeDiacritics(option.trim().toLowerCase())
              .contains(removeDiacritics(textEditingValue.text.trim().toLowerCase()));
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
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 1,
            scrollPadding: EdgeInsets.only(bottom: size.height * 0.47),
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
            decoration: _customInputDecorationText(label, styles),
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
          );
        },
        optionsViewBuilder:(BuildContext context, AutocompleteOnSelected<String>onSelected, Iterable<String>options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
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
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}