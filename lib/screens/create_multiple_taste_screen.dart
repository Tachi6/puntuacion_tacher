// Image credit https://www.freepik.es/foto-gratis/copas-png-bebida-vino-aislada-sobre-fondo-blanco_314264077.htm?log-in=google#fromView=image_search_similar&page=1&position=1&uuid=bc65a2d4-8962-482e-9323-663bcedacd7d

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:puntuacion_tacher/helpers/helpers.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/search/search.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';
import '../apptheme/apptheme.dart';

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

    final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);
    final colors = Theme.of(context).colorScheme;
    final double opacity = 0.8;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 48,
        titleSpacing: 0,
        title: const _CustomAppBar(),
        // scrolledUnderElevation: 0,
        // forceMaterialTransparency: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            child: BottomImageBackground(image: 'assets/initial-multiple-background.jpg', opacity: opacity, bottomPadding: 0)
          ),

          if (!themeColor.isDarkMode) Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withAlpha((255 * opacity.toInt())),
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

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final styles = Theme.of(context).textTheme;

    Timer? timer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
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
        
            const SizedBox(height: 10),
            
            const EnableTasteQuiz(),
            
            const AddHideWines(),
        
            const SizedBox(height: 10),
        
            SafeArea(
              top: false,
              child: SizedBox(
                height: multipleTaste.winesMultipleTaste.length * 52 + 58 + 5,
                child: const ListViewMultipleWines()
              ),
            ),
          ],
        ),
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
            physics: const NeverScrollableScrollPhysics(),
            proxyDecorator: (child, index, animation) {
              return CustomMultipleWinesRow(
                key: Key('move_$index'),
                index: index,
                maxIndex: multipleTaste.winesMultipleTaste.length - 1,
                color: colors.surfaceContainerLow,
              );
            },  
            itemCount: multipleTaste.winesMultipleTaste.length, 
            itemBuilder: (context, index) {
              return CustomMultipleWinesRow(
                key: Key('main_$index'),
                index: index,
                maxIndex: multipleTaste.winesMultipleTaste.length - 1,
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
    required this.maxIndex,
    required this.color,
  });

  final int index;
  final int maxIndex;
  final Color color;

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
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
            child: multipleTaste.multipleTaste.hidden
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
    final multipleService = Provider.of<MultipleServices>(context);
    final authService = Provider.of<AuthServices>(context);
    final taste = Provider.of<TasteOptionsProvider>(context);

    return Container(
      height: 58,
      alignment: Alignment.center,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomElevatedButton(
            width: 120,
            label: 'Guardar',
            isSendingLabel: 'Guardando',
            onPressed: () async {
              // Valido campo descripcion
              if (multipleTaste.multipleTaste.description.isEmpty || multipleTaste.multipleTaste.description.trim().isEmpty) {
                NotificationServices.showSnackbar('La descripcion de la cata es obligatoria', context);
                return;
              }
              if (multipleTaste.multipleTaste.description.trim().length < 10) {
                NotificationServices.showSnackbar('La descripcion de la cata muy corta', context);
                return;
              }
              if (multipleTaste.multipleTaste.tasteQuiz != null && multipleTaste.isNotReadyForQuiz()) {
                NotificationServices.showSnackbar('La informacion opcional de los vinos es obligatoria para el quiz', context);
                return;
              }
              // Asigno nombre de cata definitivamente
              multipleTaste.multipleTaste.name = multipleTaste.multipleName;
              // Subo a Firebase la cata multiple
              await multipleService.createMultipleTaste(multipleTaste.initMultiple());
              // Compruebo si esta activado el quiz y lo subo si es true
              if (multipleTaste.tasteQuiz.values.contains(true) && context.mounted) {
                await context.read<QuizServices>().createQuiz(multipleName: multipleTaste.multipleName, wineList: multipleTaste.winesMultipleTaste);
              }
              // Cierro bottomsheet
              if (multipleTaste.winesMultipleTaste.length > 1 && context.mounted) Navigator.pop(context);
              multipleTaste.resetSettings();
              multipleTaste.autovalidateMode = AutovalidateMode.disabled;
              if (context.mounted) Navigator.pop(context);
            },
          ),

          CustomElevatedButton(
            width: 120,
            label: 'Acceder',
            isSendingLabel: 'Accediendo',
            onPressed: () async {
              // Valido campo descripcion
              if (multipleTaste.multipleTaste.description.isEmpty || multipleTaste.multipleTaste.description.trim().isEmpty) {
                NotificationServices.showSnackbar('La descripcion de la cata es obligatoria', context);
                return;
              }
              if (multipleTaste.multipleTaste.description.trim().length < 10) {
                NotificationServices.showSnackbar('La descripcion de la cata muy corta', context);
                return;
              }
              if (multipleTaste.multipleTaste.tasteQuiz != null && multipleTaste.isNotReadyForQuiz()) {
                NotificationServices.showSnackbar('El quiz necesita la informacion opcional de los vinos', context);
                return;
              }
              // Asigno nombre de cata definitivamente
              multipleTaste.multipleTaste.name = multipleTaste.multipleName;

              // Subo a Firebase la cata multiple
              await multipleService.createMultipleTaste(multipleTaste.initMultiple());
              // Compruebo si hay quiz activado y lo subo si es true
              if (multipleTaste.tasteQuiz.values.contains(true) && context.mounted) {
                await context.read<QuizServices>().createQuiz(multipleName: multipleTaste.multipleName, wineList: multipleTaste.winesMultipleTaste);
              }
              // Lo comprueblo por si se ha quedado la variable en true antes
              multipleService.checkIsMultipleTasted(multipleName: multipleTaste.multipleTaste.name, user: authService.userUuid);
              multipleTaste.initUserTaste(multipleService.isMultipleTasted);
              // Como creo la cata es imposible que esta catada, por eso no pongo el overview global en true
              multipleTaste.autovalidateMode = AutovalidateMode.disabled;

              final routeList = MaterialPageRoute(
                builder: (context) => const MultipleTasteScreen()
              );
              if (context.mounted) Navigator.pushReplacement(context, routeList);
              taste.clearOptions();
            },
          ),

        ],
      ),
    );
  }
}

class AddHideWines extends StatelessWidget {
  const AddHideWines({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final winesService = Provider.of<WineServices>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: false);
    final styles = Theme.of(context).textTheme;

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Text('Añade y oculta vinos', style: styles.bodyMedium),
                                
          const Spacer(),
                    
          Transform.translate(
            offset: const Offset(5, 0),
            child: Row(
              children: [
                CustomIconButton(
                  onPressed: () async {
                    if (multipleTaste.winesMultipleTaste.length >= 12) {
                      NotificationServices.showSnackbar('No se permiten mas de 12 vinos', context);
                      return;
                    }

                    winesService.loadWines();

                    if (context.mounted) {
                      final wineSearched = await showSearch(context: context, delegate: SearchDelegateWines(
                        winesList: winesService.winesByName,
                        onPressed: () async {
                          // Cerrar ventana de creacion
                          Navigator.pop(context);
                          // Resetear wineFormProvider
                          wineForm.resetSettings();
                          // Navegar a la pagina de creacion
                          final newRoute = MaterialPageRoute(
                            builder: (context) => CreateEditWineScreen(
                              saveEndAction: () {
                                multipleTaste.addWine(wineForm.wine.copy());
                                Navigator.pop(context, true);
                              },
                            ),
                          );
                          final bool isSavedWine = await Navigator.push(context, newRoute);
                          // Capturo true o false para ver si he añadido vino
                          // final bool isSavedWine = await Navigator.push(context, newRoute);
                          // if (!isSavedWine) return;
                          // // Si hay vino mando verificar si es necesario el BottomSheet
                          if (isSavedWine && context.mounted && multipleTaste.winesMultipleTaste.length == 2) viewBottomMenu(context);
                        },  
                      ));
                      // Sino hay vino, salgo de la funcion
                      if (wineSearched == null) return;
                      // Compruebo si el vino ya esta añadido al listado
                      if (context.mounted && multipleTaste.winesMultipleTaste.any((element) => element.id == wineSearched.id)) {
                        NotificationServices.showSnackbar('Vino duplicado', context);
                        return;
                      }
                      // Añado vino al multipleTaste
                      multipleTaste.addWine(wineSearched);
                      // Miro si es necesario el bottomsheet
                      if (multipleTaste.winesMultipleTaste.length == 2 && context.mounted) viewBottomMenu(context);
                    }
                  },
                  icon: Icons.search,
                ),

                CustomIconButton(
                  onPressed: () async {
                    if (multipleTaste.winesMultipleTaste.length >= 12) {
                      NotificationServices.showSnackbar('No se permiten mas de 12 vinos', context);
                      return;
                    }

                    wineForm.resetSettings();

                    final newRoute = MaterialPageRoute(
                      builder: (context) => PopScope(
                        canPop: false,
                        child: CreateEditWineScreen(
                          saveEndAction: () {
                            multipleTaste.addWine(wineForm.wine.copy());
                            // Recibo true para saber que he añadido vino
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    );
                    // Capturo true o false para ver si he añadido vino
                    final bool isSavedWine = await Navigator.push(context, newRoute);
                    // Si hay vino mando verificar si es necesario el BottomSheet
                    if (isSavedWine && context.mounted && multipleTaste.winesMultipleTaste.length == 2) viewBottomMenu(context);
                  },
                  icon: Icons.add, 
                ),
           
                CustomIconButton(
                  onPressed: () => multipleTaste.hideAllWines(),
                  icon: multipleTaste.multipleTaste.hidden
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                ),
              ],
            ),
          ),
                    
        ],
      ),
    );
  }
}

class EnableTasteQuiz extends StatelessWidget {
  const EnableTasteQuiz({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 5, right: 5),
      height: 42,
      child: Row(
        children: [
          const Text('Cata Quiz', style: TextStyle(fontSize: 14)),
      
          const Spacer(),

          Checkbox(
            value: multipleTaste.tasteQuiz['simple'],
            onChanged: multipleTaste.isSimpleQuiz,
          ),

          const Text('Sencilla', style: TextStyle(fontSize: 14)),

          Checkbox(
            value: multipleTaste.tasteQuiz['advanced'],
            onChanged: multipleTaste.isAdvancedQuiz,
          ),      
          
          const Text('Avanzada', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
