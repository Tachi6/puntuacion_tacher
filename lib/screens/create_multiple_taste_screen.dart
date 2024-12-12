// Image credit https://www.freepik.es/foto-gratis/copas-png-bebida-vino-aislada-sobre-fondo-blanco_314264077.htm?log-in=google#fromView=image_search_similar&page=1&position=1&uuid=bc65a2d4-8962-482e-9323-663bcedacd7d

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/helpers/helpers.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/search/search.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

PersistentBottomSheetController viewBottomMenu(BuildContext context) {
  return showBottomSheet(
    // clipBehavior: Clip.antiAliasWithSaveLayer,
    builder: (context) {
      return const SafeArea(child: MultipleActionsButtons());
    },
    context: context,
  );
}

class CreateMultipleTasteScreen extends StatelessWidget{
  const CreateMultipleTasteScreen({super.key});
    
  @override
  Widget build(BuildContext context) {

    final screenElementsSizeProvider = Provider.of<ScreenElementsSizeProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final double bottomPadding = screenElementsSizeProvider.bottomElementHeight;
    final double opacity = 0.8;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 48,
        titleSpacing: 0,
        title: const _CustomAppBar(),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 58 + bottomPadding),
            child: BottomImageBackground(image: 'assets/initial-multiple-background.jpg', opacity: opacity),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 58 + bottomPadding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(opacity),
                    colors.surface,
                  ],
                )
              ),
            ),
          ),

          const _CustomBody(),
        ],
      ),      
    );
  }


}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        IconButton(
          onPressed: () {
            // To close bottomsheet
            if (multipleTaste.winesMultipleTaste.length > 1) Navigator.pop(context);
            multipleTaste.resetSettings();
            multipleTaste.autovalidateMode = AutovalidateMode.disabled;
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded, color: colors.onSurface)
        ),
          
        Container(
          height: 48,
          alignment: Alignment.center,
          width: size.width - 96,
          child: Text(
            multipleTaste.multipleName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20, height: 1.1)),
        ),
              
        IconButton(
          onPressed: () {
            // To close bottomsheet
            if (multipleTaste.winesMultipleTaste.length > 1) Navigator.pop(context);
            multipleTaste.clearWines();
          },
          icon: Icon(Icons.clear_all_rounded, color: colors.onSurface)
        ),
      ],
    );
  }
}

class _CustomBody extends StatelessWidget {
  const _CustomBody();

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
    final styles = Theme.of(context).textTheme;

    Timer? timer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 10),
      
          TextFormField(
            maxLines: null,
            style: styles.bodySmall,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(16, 16, 12, 10),
              labelText: 'Descripcion de la cata a realizar',
              labelStyle: styles.bodySmall,
              floatingLabelStyle: styles.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(width: 1)
              ),
            ),
            onChanged: (value) {
              timer?.cancel();
              timer = Timer(const Duration(milliseconds: 500), () {
                multipleTaste.multipleTaste.description = value;
              },);
            },
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          ),
      
          const SizedBox(height: 20),
      
          TextFormField(    
            style: styles.bodySmall,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(16, 16, 12, 10),
              labelText: 'Contraseña de la cata (opcional)',
              labelStyle: styles.bodySmall,
              floatingLabelStyle: styles.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(width: 1)
              ),
            ),
            onChanged: (value) {
              final String encryptedPassword = EncryptionService().encryptData(value);
              
              multipleTaste.multipleTaste.password = encryptedPassword;
            },
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          ),

          const SizedBox(height: 20),

          const DateTextFormField(),
      
          // TextFormField(
          //   controller: multipleTaste.dateController,  
          //   minLines: 1,
          //   readOnly: true,
          //   canRequestFocus: false,
          //   autofocus: false,
          //   style: styles.bodySmall,
          //   decoration: InputDecoration(
          //     isDense: true,
          //     contentPadding: EdgeInsets.fromLTRB(16, 16, 12, 10),
          //     labelText: 'Fecha límite de cata (opcional)',
          //     labelStyle: styles.bodySmall,
          //     floatingLabelStyle: styles.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(15),
          //       borderSide: const BorderSide(width: 1)
          //     ),
          //     suffixIcon: IconButton(
          //       onPressed: () {
          //         showCustomDialog(
          //           context, 
          //           child: const CalendarDialog(),
          //         );
          //       },
          //       icon: const Icon(Icons.calendar_month_rounded)
          //     ),
          //   ),
          //   onTap: () {
          //     showCustomDialog(
          //       context, 
          //       child: const CalendarDialog()
          //     );
          //   },
          // ),

          const SizedBox(height: 10),

          const RowVisibleWines(),

          const SizedBox(height: 10),

          const Expanded(
            child: ListViewMultipleWines()
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
      ),
    );
  }
}

class DateTextFormField extends StatefulWidget {
  const DateTextFormField({super.key});

  @override
  State<DateTextFormField> createState() => _DateTextFormFieldState();
}

class _DateTextFormFieldState extends State<DateTextFormField> {

  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme;

    void showCustomDialog() {
      showGeneralDialog(
        context: context,
        barrierDismissible: false, 
        pageBuilder: (context, animation, secondaryAnimation) {
          return PopScope(
            canPop: false,
            child: CalendarDialog(dateController: dateController),
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

    return TextFormField(
      controller: dateController,  
      minLines: 1,
      readOnly: true,
      canRequestFocus: false,
      autofocus: false,
      style: styles.bodySmall,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(16, 16, 12, 10),
        labelText: 'Fecha límite de cata (opcional)',
        labelStyle: styles.bodySmall,
        floatingLabelStyle: styles.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 1)
        ),
        suffixIcon: const Icon(Icons.calendar_month_rounded),
      ),
      onTap: showCustomDialog,
    );
  }
}

class CalendarDialog extends StatelessWidget {
  const CalendarDialog({
    super.key, 
    required this.dateController
  });

  final TextEditingController dateController;

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);

    return CustomAlertDialog(
      title: 'Fecha limite de cata',
      cancelText: 'Cancelar',
      onPressedCancel: () {
        dateController.text = 'Sin fecha límite de cata';
        Navigator.pop(context);
      },
      content: SizedBox(
        width: 232,
        height: 160,
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
            viewHeaderHeight: 0,
            firstDayOfWeek: 1,
          ),
          selectionMode: DateRangePickerSelectionMode.single,
          selectionShape: DateRangePickerSelectionShape.rectangle,
          onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
            final DateTime date = dateRangePickerSelectionChangedArgs.value;
            final String dateEndDay = CustomDatetime().toTextToEndOfDay(date);
            multipleTaste.multipleTaste.dateLimit = dateEndDay;
            dateController.text = CustomDatetime().toPlainText(dateEndDay);
            Navigator.pop(context);
          },
        )
      ),
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
    // final hideIndex = multipleTaste.hideIndex.indexOf(index) + 1;
    final styles = Theme.of(context).textTheme;

    return Card(
      key: key,
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const SizedBox(width: 16),
      
          const Icon(Icons.menu),
      
          const SizedBox(width: 16),
      
          Expanded(
            child: multipleTaste.multipleTaste.hidden // multipleTaste.hideIndex.contains(index) 
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // 'Vino a catar a ciegas $hideIndex', 
                    'Vino a catar a ciegas ${index + 1}', 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis, 
                    style: styles.bodySmall!.copyWith(fontWeight: FontWeight.bold),
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
                style: styles.bodySmall!.copyWith(fontWeight: FontWeight.bold),
              ),
          ),
             
          // IconButton (
          //   icon: Icon(
          //     multipleTaste.hideIndex.contains(index)
          //     ? Icons.visibility_rounded
          //     : Icons.visibility_off_rounded
          //   ),
          //   onPressed: () => multipleTaste.hideWine(index),
          // ),
      
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
            width: 105,
            child: const Text('Guardar'),
            onPressed: () async {
              // Valido campo descripcion
              if (multipleTaste.multipleTaste.description.isEmpty || multipleTaste.multipleTaste.description.trim().isEmpty) {
                NotificationsService.showSnackbar('La descripcion de la cata es obligatoria', context);
                return;
              }
              if (multipleTaste.multipleTaste.description.trim().length < 10) {
                NotificationsService.showSnackbar('La descripcion de la cata muy corta', context);
                return;
              }
              // Asigno nombre de cata definitivamente
              multipleTaste.multipleTaste.name = multipleTaste.multipleName;
              // Subo a Firebase la cata multiple
              await multipleService.createMultipleTaste(multipleTaste.initMultiple());
              // Cierro bottomsheet
              if (multipleTaste.winesMultipleTaste.length > 1 && context.mounted) Navigator.pop(context);
              multipleTaste.resetSettings();
              multipleTaste.autovalidateMode = AutovalidateMode.disabled;
              if (context.mounted) Navigator.pop(context);
            },
          ),

          CustomElevatedButton(
            width: 105,
            child: const Text('Realizar'),
            onPressed: () async {
              // Valido campo descripcion
              if (multipleTaste.multipleTaste.description.isEmpty || multipleTaste.multipleTaste.description.trim().isEmpty) {
                NotificationsService.showSnackbar('La descripcion de la cata es obligatoria', context);
                return;
              }
              if (multipleTaste.multipleTaste.description.trim().length < 10) {
                NotificationsService.showSnackbar('La descripcion de la cata muy corta', context);
                return;
              }
              // Asigno nombre de cata definitivamente
              multipleTaste.multipleTaste.name = multipleTaste.multipleName;

              // Subo a Firebase la cata multiple
              await multipleService.createMultipleTaste(multipleTaste.initMultiple());
              // Lo comprueblo por si se ha quedado la variable en true antes
              multipleService.checkIsMultipleTasted(multipleName: multipleTaste.multipleTaste.name, user: authService.userDisplayName);
              multipleTaste.initUserTaste(multipleService.isMultipleTasted);
              multipleTaste.autovalidateMode = AutovalidateMode.disabled;

              final routeList = CupertinoPageRoute(
                builder: (context) => const MultipleTasteScreen()
              );
              if (context.mounted) Navigator.pushReplacement(context, routeList);
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
    final styles = Theme.of(context).textTheme;

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Text('Añade/oculta tus vinos', style: styles.bodyMedium),
                                
          const Spacer(),
                    
          Transform.translate(
            offset: const Offset(5, 0),
            child: Row(
              children: [
                SearchWineButton(
                  onPressed: () async {
                    winesService.loadWines();
                    if (context.mounted) {
                      final wineSearched = await showSearch(context: context, delegate: SearchDelegateWines(
                        customResultText: 'Vuelve atras y crea tu vino' '\n' 'para añadirlo a la cata.'
                      ));
                      // Compruebo si el vino ya esta añadido al listado
                      if (context.mounted && multipleTaste.winesMultipleTaste.any((element) => element.id == wineSearched.id)) {
                        NotificationsService.showSnackbar('Vino duplicado', context);
                        return;
                      }
                      if (wineSearched != null) multipleTaste.addWine(wineSearched);
                      if (multipleTaste.winesMultipleTaste.length == 2 && context.mounted) viewBottomMenu(context);
                    }
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
                    // multipleTaste.multipleTaste.hidden = !multipleTaste.multipleTaste.hidden;
                    multipleTaste.hideAllWines();
                  },
                  icon: Icon(
                    multipleTaste.multipleTaste.hidden
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                    color: colors.onSurface,
                    size: 22
                  ),
                ),
              ],
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
