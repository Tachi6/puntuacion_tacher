import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/search/search.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

PersistentBottomSheetController viewBottomMenu(BuildContext context) {
  return showBottomSheet(
    builder: (context) {
      return const MultipleActionsButtons();
    },
    context: context,
  );
}

class CreateMultipleTaste extends StatelessWidget{
  const CreateMultipleTaste({super.key});
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 260,
        // toolbarHeight: 302,
        titleSpacing: 0,
        title: _CustomBodyAppBar(),
      ),
      body: const ListViewMultipleWines(),      
    );
  }


}

class _CustomBodyAppBar extends StatelessWidget {

  void showCustomDialog(BuildContext context, {required Widget child}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, 
      pageBuilder: (context, animation, secondaryAnimation) {
        return PopScope(
          canPop: false,
          child: child,
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

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (multipleTaste.winesMultipleTaste.length > 1) Navigator.pop(context);
                Navigator.pop(context);
                multipleTaste.resetSettings();
              },
              icon: Icon(Icons.arrow_back_rounded, color: colors.onSurface)
            ),
              
            Container(
              height: 48,
              alignment: Alignment.center,
              width: size.width - 96,
              child: Text(
                multipleTaste.multipleTaste.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20, height: 1.1)),
            ),
                 
            IconButton(
              onPressed: () {
                if (multipleTaste.winesMultipleTaste.length > 1) Navigator.pop(context);
                multipleTaste.clearWines();
              },
              icon: Icon(Icons.clear_all_rounded, color: colors.onSurface)
            ),
          ],
        ),
      
        Container(
          height: 84,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: TextFormField(
            textAlignVertical: TextAlignVertical.top,                 
            maxLines: 3,
            minLines: 3,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              isDense: true,
              labelText: 'Descripcion de la cata a realizar',
              alignLabelWithHint: true,
              labelStyle: const TextStyle(fontSize: 14),
              floatingLabelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 1)
              ),
            ),
            onChanged: (value) => multipleTaste.editMultipleTaste(() => multipleTaste.multipleTaste.description = value),
          ),
        ),
    
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 42,
          child: TextFormField(    
            textAlignVertical: TextAlignVertical.center,             
            maxLines: 1,
            minLines: 1,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              isDense: true,
              labelText: 'Contraseña de la cata (opcional)',
              alignLabelWithHint: true,
              labelStyle: const TextStyle(fontSize: 14),
              floatingLabelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(width: 1)
              ),
            ),
            onChanged: (value) => multipleTaste.editMultipleTaste(() => multipleTaste.multipleTaste.password = value),
          ),
        ),
    
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10),
          height: 42,
          child: Row(
            children: [
              const Text('Fecha limite de la cata', style: TextStyle(fontSize: 14)),
    
              const SizedBox(width: 16),
    
              Expanded(
                child: TextFormField(  
                  controller: multipleTaste.dateController,  
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,             
                  maxLines: 1,
                  minLines: 1,
                  readOnly: true,
                  canRequestFocus: false,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    isDense: true,
                    alignLabelWithHint: true,
                    labelStyle: const TextStyle(fontSize: 14),
                    floatingLabelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 1)
                    ),
                  ),
                ),
              ),
    
              IconButton(
                onPressed: () {
                  showCustomDialog(
                    context, 
                    child: CustomAlertDialog(
                      title: 'Fecha limite de cata',
                      cancelText: 'Cancelar',
                      onPressedCancel: () {
                        multipleTaste.dateController.text = 'Sin limite';
                        Navigator.pop(context);
                      },
                      content: SizedBox(
                        width: 232,
                        height: 180,
                        child: SfDateRangePicker(
                          monthFormat: 'MMMM',
                          view: DateRangePickerView.month,
                          showNavigationArrow: true,
                          backgroundColor: Colors.transparent,
                          enablePastDates: false,
                          headerStyle: const DateRangePickerHeaderStyle(
                            textAlign: TextAlign.center,
                            backgroundColor: Colors.transparent,
                            textStyle: TextStyle(fontFeatures: [FontFeature.alternative(1)])
                          ),
                          monthViewSettings: const DateRangePickerMonthViewSettings(
                            firstDayOfWeek: 1,
                          ),
                          selectionMode: DateRangePickerSelectionMode.single,
                          selectionShape: DateRangePickerSelectionShape.rectangle,
                          onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                            final DateTime date = dateRangePickerSelectionChangedArgs.value;
                            multipleTaste.editMultipleTaste(() => multipleTaste.multipleTaste.dateLimit = CustomDatetime().toText(date));
                            multipleTaste.dateController.text = '${date.day}-${date.month}-${date.year}';
                            Navigator.pop(context);
                          },
                        )
                      ),
                    )
                  );
                },
                icon: const Icon(Icons.calendar_month_rounded)
              ),
            ],
          ),
        ),
      
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   alignment: Alignment.center,
        //   height: 42,
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       const Text('Realizar la cata totalmente a ciegas', style: TextStyle(fontSize: 14)),
          
        //       const Spacer(),
          
        //       SizedBox(
        //         width: 48,
        //         child: FittedBox(
        //           fit: BoxFit.fitWidth,
        //           child: Switch(
        //             value: multipleTaste.multipleTaste.hidden,
        //             onChanged: (_) {
        //               multipleTaste.editMultipleTaste(() => multipleTaste.multipleTaste.hidden = !multipleTaste.multipleTaste.hidden);
        //               if (multipleTaste.winesMultipleTaste.length > 1) Navigator.pop(context);
        //               multipleTaste.clearWines();
        //             }
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // ),

        const RowVisibleWines(),
      
        // AnimatedSwitcher(
        //   duration: const Duration(milliseconds: 250),
        //   layoutBuilder: (currentChild, previousChildren) {
        //     return currentChild!;
        //   },
        //   child: multipleTaste.multipleTaste.hidden
        //     ? const RowHiddenWines(key: ValueKey<String>('notHidden'))
        //     : const RowVisibleWines(key: ValueKey<String>('hidden')), 
        // ),
      ],
    );
  }
}

class ListViewMultipleWines extends StatefulWidget {
  const ListViewMultipleWines({
    super.key,
  });

  @override
  State<ListViewMultipleWines> createState() => _ListViewMultipleWinesState();
}

class _ListViewMultipleWinesState extends State<ListViewMultipleWines> {

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
            proxyDecorator: (child, index, animation) {
              return CustomMultipleWinesRow(
                key: Key('move_$index'),
                index: index,
                color: colors.surfaceContainerLow,
              );
            },  
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: multipleTaste.winesMultipleTaste.length, 
            itemBuilder: (context, index) {
              return CustomMultipleWinesRow(
                key: Key('main_$index'),
                index: index,
                color: colors.surfaceContainerHigh,
              );  
            }, 
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final Wines item = multipleTaste.winesMultipleTaste.removeAt(oldIndex);
                multipleTaste.winesMultipleTaste.insert(newIndex, item);
              });
            },
          ),
        ),
      ],
    );
  }
}

class CustomMultipleWinesRow extends StatelessWidget {
  const CustomMultipleWinesRow({
    super.key,
    required this.index,
    required this.color,
  });

  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final hideIndex = multipleTaste.hideIndex.indexOf(index) + 1;

    return Card(
      key: key,
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const SizedBox(width: 16),
      
          const Icon(Icons.menu),
      
          const SizedBox(width: 18),
      
          Expanded(
            child: multipleTaste.hideIndex.contains(index) 
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vino a catar a ciegas $hideIndex', 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis, 
                    style: const TextStyle(fontSize: 14)
                  ),

                  Text(
                    '${multipleTaste.winesMultipleTaste[index].vino} ${multipleTaste.winesMultipleTaste[index].anada}', 
                    maxLines: 1,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis, 
                    style: const TextStyle(fontSize: 10)
                  ),
                ],
              )
              : Text(
                multipleTaste.winesMultipleTaste[index].nombre, 
                maxLines: 2, 
                overflow: TextOverflow.ellipsis, 
                style: const TextStyle(fontSize: 14)
              ),
          ),
             
          if (!multipleTaste.multipleTaste.hidden) IconButton (
            icon: Icon(
              multipleTaste.hideIndex.contains(index)
              ? Icons.visibility_rounded
              : Icons.visibility_off_rounded
            ),
            onPressed: () => multipleTaste.hideWine(index),
          ),
      
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              multipleTaste.removeWine(multipleTaste.winesMultipleTaste[index]);
              if (multipleTaste.winesMultipleTaste.length == 1) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class MultipleActionsButtons extends StatelessWidget {
  const MultipleActionsButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleService>(context);
    final authService = Provider.of<AuthService>(context);

    return Container(
      height: 58,
      alignment: Alignment.center,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomElevatedButton(
            width: 100,
            child: const Text('Guardar'),
            onPressed: () {
              // Subo a Firebase la cata multiple
              multipleService.createMultipleTaste(multipleTaste.initMultiple());

              // TODO dejo este codigo de abajo que sera util
              // Actualizar cata multiple
              // multipleService.updateMultiple(
              //   multipleName:multipleTaste.name,
              //   averageRatings: AverageRatings(boca: 3.90, nariz: 3.90, puntos: 70, vista: 3.90)
              // );

              // Actualizar taste de cata multiple
              // String dateToString() {
              //   final date = DateTime.now();
              //   return date.toIso8601String().replaceAll('.', ':');
              // }

              // final Map<String, WineTaste> taste = {
              //   dateToString(): WineTaste(user: 'pepito', ratingVista: 5, ratingNariz: 5, ratingBoca: 6, ratingPuntos: 7, puntosFinal: 70, comentarios: '', id: 'Vino a catar a ciegas 1', notasBoca: '', notasNariz: '', notasVista: ''),
              //   dateToString(): WineTaste(user: 'pepito', ratingVista: 6, ratingNariz: 7, ratingBoca: 8, ratingPuntos: 7, puntosFinal: 74, comentarios: '', id: 'Vino a catar a ciegas 2', notasBoca: '', notasNariz: '', notasVista: ''),
              // };

              // multipleService.updateTaste(
              //   multipleName:multipleTaste.name, 
              //   wineTaste: taste
              // );
            },
          ),

          CustomElevatedButton(
            width: 100,
            child: const Text('Realizar'),
            onPressed: () async {
              // Subo a Firebase la cata multiple
              final Multiple multiple = await multipleService.createMultipleTaste(multipleTaste.initMultiple());

              multipleTaste.editMultipleTaste(() => multipleTaste.multipleTaste = multiple);
              multipleService.checkIsMultipleTasted(multipleName: multipleTaste.multipleTaste.name, user: authService.userDisplayName);
              multipleTaste.initUserTaste(multipleService.isMultipleTasted);

              final routeList = CupertinoPageRoute(
                builder: (context) => const MultipleTasteScreen()
              );
              if (context.mounted) Navigator.push(context, routeList);
            },
          ),

        ],
      ),
    );
  }
}

class RowVisibleWines extends StatelessWidget {
  const RowVisibleWines({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final winesService = Provider.of<WinesService>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: false);
    final taste = Provider.of<VisibleOptionsProvider>(context, listen: false);
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(left: 10),
      alignment: Alignment.center,
      height: 42,
      child: Row(
        children: [
          const Text('Busca, añade y oculta los vinos', style: TextStyle(fontSize: 14)),
                                
          const Spacer(),
                    
          SearchWineButton(
            onPressed: () async {
              winesService.loadWines();
              final wineSearched = await showSearch(context: context, delegate: SearchDelegateWines(
                customResultText: 'Vuelve atras y crea tu vino' '\n' 'para añadirlo a la cata.'
              ));
              // Compruebo si el vino ya esta añadido al listado
              if (context.mounted && multipleTaste.winesMultipleTaste.any((element) => element.id == wineSearched.id)) {
                NotificationsService.showSnackbar('Vino duplicado', context);
                return;
              }
              if (wineSearched != null) multipleTaste.addWine(wineSearched.copy());
              if (multipleTaste.winesMultipleTaste.length == 2 && context.mounted) viewBottomMenu(context);
            },
          ),
                    
          AddWineButton(
            onPressedSave: () async {
              if (wineForm.isValidForm()) {
                wineForm.wine.nombre = '${wineForm.wine.vino} ${wineForm.wine.anada.toString()}';
                final String wineId = await winesService.createWine(wineForm.wine);
                wineForm.wine.id = wineId;
                multipleTaste.addWine(wineForm.wine.copy());
                if (multipleTaste.winesMultipleTaste.length == 2 && context.mounted) viewBottomMenu(context);
                taste.showContinueButton = true;
                if (context.mounted) Navigator.pop(context, 'Guardar');
              }
            },
          ),

          IconButton(
            onPressed: () {
              multipleTaste.hideNames = !multipleTaste.hideNames;
              multipleTaste.hideAllWines();
            },
            icon: Icon(
              multipleTaste.hideNames
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
              color: colors.onSurface,
              size: 22
            ),
          ),
        ],
      ),
    );
  }
}

class RowHiddenWines extends StatelessWidget {
  const RowHiddenWines({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 10),
      height: 42,
      child: Row(
        children: [
          const Text('Numero de vinos a catar a ciegas', style: TextStyle(fontSize: 14)),
      
          const Spacer(),
      
          Container(
            alignment: Alignment.center,
            height: 42,
            width: 84,
            child: TextFormField(
              textAlignVertical: TextAlignVertical.top,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,1}'))
              ],
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                isDense: true,
                labelText: '',
                alignLabelWithHint: true,
                labelStyle: const TextStyle(fontSize: 14),
                floatingLabelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(width: 1)
                ),
              ),
              // autovalidateMode: AutovalidateMode.onUnfocus,
              // validator: (value) {
              //   if (value == '') {
              //     return ;
              //   }
              //   if (int.parse(value!) < 2 || int.parse(value) > 20) {
              //     return '';
              //   }
              //   return null;
              // },
              onChanged: (value) {
                if (value == '') return;
                multipleTaste.winesHiddenNumber = int.parse(value);
              },
              onFieldSubmitted: (value) {
                if (int.parse(value) > 1 && int.parse(value) < 21) {
                  multipleTaste.clearWines();
                  FocusManager.instance.primaryFocus?.unfocus();
                  multipleTaste.addHiddenWines();
                  if (multipleTaste.winesMultipleTaste.length > 1) viewBottomMenu(context);
                }
                else {
                  NotificationsService.showSnackbar('NUMERO DE VINOS DEBE ESTAR ENTRE 2 Y 20', context);
              }

              },
            ),
          ),
      
          IconButton(
            onPressed: () {
              if (multipleTaste.winesHiddenNumber > 1 && multipleTaste.winesHiddenNumber < 21) {
                multipleTaste.clearWines();
                FocusManager.instance.primaryFocus?.unfocus();
                multipleTaste.addHiddenWines();
                if (multipleTaste.winesMultipleTaste.length > 1) viewBottomMenu(context);
              }
              else {
                FocusManager.instance.primaryFocus?.unfocus();
                NotificationsService.showSnackbar('EL NUMERO DE VINOS DEBE ESTAR ENTRE 2 Y 20', context);
              }
            }, 
            icon: Icon(
              Icons.check, 
              color: colors.onSurface,
              size: 22
            ),
          ),
        ],
      ),
    );
  }
}
