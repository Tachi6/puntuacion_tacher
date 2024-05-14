
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/search/search_delegate_form.dart';
import 'package:puntuacion_tacher/services/services.dart';

class CreateAddWine extends StatelessWidget {
  
  const CreateAddWine({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.add, 
              color: redColor(),
              size: 22
            ),
            onPressed: () {
    
              final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: false); // TODO listen tru dentro de funcion
              final winesService = Provider.of<WinesService>(context, listen: false);
              final taste = Provider.of<VisibleOptionsProvider>(context, listen: false);
              showGeneralDialog(
                context: context,
                barrierDismissible: false, 
                pageBuilder: (context, animation, secondaryAnimation) {
                  return PopScope(
                    canPop: false,
                    child: _CustomDialog(wineForm: wineForm, winesService: winesService, taste: taste),
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
              // showDialog(
              //   barrierDismissible: false,
              //   context: context,
              //   builder: (BuildContext context) {
              //     return PopScope(
              //       canPop: false,
              //       child: _CustomDialog(wineForm: wineForm, winesService: winesService, taste: taste),
              //     );
              //   },
              // );
            },
          ),
    
          IconButton(
            onPressed: () {
              final winesService = Provider.of<WinesService>(context, listen: false);
              winesService.loadWines;

              showSearch(context: context, delegate: WineSearchForm());
            }, 
            icon: Icon(
              Icons.search, 
              color: redColor(),
              size: 22
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomDialog extends StatelessWidget {
  const _CustomDialog({
    required this.wineForm,
    required this.winesService,
    required this.taste,
  });

  final CreateEditWineFormProvider wineForm;
  final WinesService winesService;
  final VisibleOptionsProvider taste;

  @override
  Widget build(BuildContext context) {
    return AlertDialog( // TODO pasar a Dialog??
      backgroundColor: Colors.white,
      // scrollable: true, // TODO necesario?
      surfaceTintColor: Colors.transparent,
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(20)),
      actionsPadding: const EdgeInsets.all(10),
      insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      title: const Text('Añadir vino al listado', style: TextStyle(fontSize: 16, color: Colors.black)),
      content: ChangeNotifierProvider(
        create: ( _ ) => ShowMoreFieldsCreateWine(),
        child: CreateNewWineForm(wineForm)
        ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            wineForm.setDefaultCreateWine();
            Navigator.pop(context, 'Cancelar');
          },
          child: Text('Cancelar', style: TextStyle(fontSize: 14, color: redColor())),
        ),
        TextButton(
          onPressed: () {
            
            if (wineForm.isValidForm()) {
    
              wineForm.wine.nombre = '${wineForm.wine.vino} ${wineForm.wine.anada.toString()}';
              
              winesService.selectedWine = wineForm.wine;
              taste.showContinueButton = true;
              Navigator.pop(context, 'Guardar');
            }
          },
          child: Text('Guardar', style: TextStyle(fontSize: 14, color: redColor())),
        ),
      ],
    );
  }
}

class CreateNewWineForm extends StatelessWidget {

  final CreateEditWineFormProvider wineForm;

  const CreateNewWineForm(this.wineForm, {super.key});

  @override
  Widget build(BuildContext context) {

    final moreFields = Provider.of<ShowMoreFieldsCreateWine>(context);

    final Wines wine = wineForm.wine;
    final Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(0),
        width: size.width * 0.8,
        // height: 600,
        child: Form(
          key: wineForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
        
              const Text('Ficha técnica del vino', style: TextStyle(fontSize: 14, color: Colors.black, overflow: TextOverflow.ellipsis)),
        
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                initialValue: wine.vino,
                maxLines: 1,
                style: const TextStyle(fontSize: 14, color: Colors.black, overflow: TextOverflow.ellipsis),
                decoration: _customInputDecorationText('Vino'),
                cursorColor: redColor(),
                validator: (value) {
                  if (value == null || value.length < 2) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
                onChanged: (value) => wine.vino = value,
              ),
        
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                initialValue: wine.bodega,
                maxLines: 1,
                style: const TextStyle(fontSize: 14, color: Colors.black, overflow: TextOverflow.ellipsis),
                decoration: _customInputDecorationText('Bodega'),
                cursorColor: redColor(),
                validator: (value) {
                  if (value == null || value.length < 2) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
                onChanged: (value) => wine.bodega = value,
              ),
        
              TextFormFieldSearch(label: 'Region', wine: wine, autocompleteWidth: size.width * 0.8),
        
              TextFormFieldSearch(label: 'Tipo', wine: wine, autocompleteWidth: size.width * 0.8),
        
              TextFormField(
                initialValue: '',
                inputFormatters: [ // r'^(\d+)?\.?\d{0,1}'
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,1}')),
                ],
                keyboardType: TextInputType.number,
                maxLines: 1,
                style: const TextStyle(fontSize: 14, color: Colors.black, overflow: TextOverflow.ellipsis),
                decoration: _customInputDecorationText('Añada'),
                cursorColor: redColor(),
                validator: (value) {
        
                  if (value == '') {
                    return 'Este campo es obligatorio';
                  }
        
                  final int anada = int.parse(value!);
                  final date = DateTime.now();
                  final year = date.year;
        
                  if (anada < 1950 || anada > year ) {
                    return 'Añada no válida';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value != '') { 
                    final int anada = int.parse(value);
                    wine.anada = anada;
                  }
                },
              ),
        
              Transform.translate(
                offset: const Offset(-15, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (moreFields.showMoreFieldsCreateWine) {
                          moreFields.showMoreFieldsCreateWine = false;
                        }
                        else {
                          moreFields.showMoreFieldsCreateWine = true;
                        }
                      },
                      icon: moreFields.showMoreFieldsCreateWine ? const Icon(Icons.remove) : const Icon(Icons.add),
                    ),
                
                    const Text('Ampliar información', style: TextStyle(fontSize: 14, color: Colors.black, overflow: TextOverflow.ellipsis))
                  ],
                ),
              ),
        
              Visibility(
                visible: moreFields.showMoreFieldsCreateWine,
                child: ExtendInformation(wine: wine)
              ),
              
            ]
          )
        ),
      ),
    );
  }

  InputDecoration _customInputDecorationText(String label) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor())),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor(), width: 2)),  
      labelText: label,
      labelStyle: TextStyle(fontSize: 14, color: redColor()),
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
          enableSuggestions: false,
          autocorrect: false,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 1,
          style: const TextStyle(fontSize: 14, color: Colors.black, overflow: TextOverflow.ellipsis),
          cursorColor: redColor(),
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
          decoration: _cutomInputDecorationAutocomplete(),
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
                    contentPadding: const EdgeInsets.only(left: 20),
                    onTap: () => onSelected(option),
                    title: Text(option, style: const TextStyle(fontSize: 14, color: Colors.black, overflow: TextOverflow.ellipsis),),
                    tileColor: Colors.white
                    // tileColor: Colors.grey.shade100, // todo definir color
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _cutomInputDecorationAutocomplete() {
    return InputDecoration(
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor())),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor(), width: 2)),  
          labelText: label,
          labelStyle: TextStyle(fontSize: 14, color: redColor()),
        );
  }
}

class ExtendInformation extends StatelessWidget {

  final Wines wine;

  const ExtendInformation({super.key, required this.wine});

  InputDecoration _customInputDecorationText(String label) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor())),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor(), width: 2)),  
      labelText: label,
      labelStyle: TextStyle(fontSize: 14, color: redColor()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Column(
          children: [
        
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              initialValue: wine.variedades,
              minLines: 1,
              maxLines: 2,
              style: const TextStyle(fontSize: 14, color: Colors.black, overflow: TextOverflow.ellipsis),
              decoration: _customInputDecorationText('Variedades'),
              cursorColor: redColor(),
              validator: (value) {
                if (value == '') {
                  return null;
                }
                if (value!.length < 3) {
                  return 'Descripción demasiado corta';
                }
                return null;
              },
              onChanged: (value) => wine.variedades = value,
            ),
        
            TextFormField(
              initialValue: '',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,1}')),
              ],
              keyboardType: TextInputType.number,
              maxLines: 1,
              style: const TextStyle(fontSize: 14, color: Colors.black, overflow: TextOverflow.ellipsis),
              decoration: _customInputDecorationText('Graduación'),
              cursorColor: redColor(),
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
            ),
        
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              initialValue: wine.descripcion,
              minLines: 1,
              maxLines: 3,
              style: const TextStyle(fontSize: 14, color: Colors.black, overflow: TextOverflow.ellipsis),
              decoration: _customInputDecorationText('Descripcion'),
              cursorColor: redColor(),
              validator: (value) {
                if (value == '') {
                  return null;
                }
                if (value!.length < 3) {
                  return 'Descripción demasiado corta';
                }
                return null;
              },
              onChanged: (value) => wine.descripcion = value,
            ),
        
            const SizedBox(height: 25),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
        
                CircleAvatar(
                  backgroundColor: redColor(),
                  child: IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.camera_alt_outlined),
                    onPressed: () {},
                  ),
                ),
        
                const SizedBox(width:10),
        
                CircleAvatar(
                  backgroundColor: redColor(),
                  child: IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.upload_file_outlined),
                    onPressed: () {},
                  ),
                ),
        
                const SizedBox(width:10),
        
                Text('Añadir o cargar imagen del vino', style: TextStyle(fontSize: 14, color: redColor())),
              ],
            ),
          ],
        ),
      ],
    );
  }
}