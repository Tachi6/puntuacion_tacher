// Image credit https://www.freepik.es/foto-gratis/copas-png-bebida-vino-aislada-sobre-fondo-blanco_314264077.htm?log-in=google#fromView=image_search_similar&page=1&position=1&uuid=bc65a2d4-8962-482e-9323-663bcedacd7d

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:puntuacion_tacher/presentation/providers/providers.dart';
import 'package:puntuacion_tacher/helpers/helpers.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/search/search.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class CreateMultipleScreen extends StatelessWidget {
  const CreateMultipleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        //TODO: alert dialog de confirmacion
      },
      child: ChangeNotifierProvider(
        create: (context) => MultipleFormProvider(),
        child: const CreateMultipleTaste(),
      ),
    );
  }
}

class CreateMultipleTaste extends StatelessWidget{
  const CreateMultipleTaste({super.key});

  @override
  Widget build(BuildContext context) {
  
    final double opacity = 0.8;

    return Stack(
      children: [
        BottomImageBackground(image: 'assets/initial-multiple-background.jpg', opacity: opacity, bottomFlex: 1),

        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 48,
            titleSpacing: 0,
            title: const _CustomAppBar(),
          ),
          body: const _CustomBody(),
        ),
      ],
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (context.read<MultipleFormProvider>().isBottomSheetOpen) {
              Navigator.pop(context);
            }
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded, color: colors.onSurface)
        ),
        

        SizedBox(
          width: size.width - 96,
          height: 48,
          child: TextField(
            minLines: 1,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, height: 1.1),
            decoration: InputDecoration(
              hintText: context.watch<MultipleFormProvider>().hintName,
              border: const UnderlineInputBorder(borderSide: BorderSide.none)
            ),
            onChanged: (value) => context.read<MultipleFormProvider>().name = value,
            onTap: () => context.read<MultipleFormProvider>().hintName = '',
          ),
        ),
        // Container(
        //   height: 48,
        //   alignment: Alignment.center,
        //   width: size.width - 96,
        //   child: Text(
        //     context.read<MultipleFormProvider>().name,
        //     textAlign: TextAlign.center,
        //     maxLines: 2,
        //     overflow: TextOverflow.ellipsis,
        //     style: const TextStyle(fontSize: 20, height: 1.1)
        //   ),
        // ),
              
        IconButton(
          onPressed: () {
            context.read<MultipleFormProvider>().clearMultipleWines(context);
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
        
            _CustomTextFormField(
              maxLines: null,
              label: 'Descripcion de la cata a realizar',
              onChanged: (value) {
                timer?.cancel();
                timer = Timer(const Duration(milliseconds: 500), () {
                  context.read<MultipleFormProvider>().description = value;
                });
              },
            ),

            const SizedBox(height: 20),

            _CustomTextFormField(
              maxLines: 1,
              label: 'Contraseña de la cata (opcional)',
              onChanged: (value) {
                final String encryptedPassword = EncryptionService().encryptData(value);
                context.read<MultipleFormProvider>().password = encryptedPassword;
              },
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
                height: context.watch<MultipleFormProvider>().wineSequence.length * 52 + 58 + 5,
                child: const ListViewMultipleWines(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTextFormField extends StatelessWidget {
  const _CustomTextFormField({
    required this.maxLines,
    required this.label,
    this.controller,
    this.onChanged,
    this.suffixIcon,
    this.onTap,
    this.readOnly,
    this.canRequestFocus,
  });

  final int? maxLines;
  final String label;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final bool? readOnly;
  final bool? canRequestFocus;

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme;

    return TextFormField(
      minLines: 1,   
      maxLines: maxLines,
      readOnly: readOnly ?? false,
      canRequestFocus: canRequestFocus ?? true,
      controller: controller,
      style: styles.bodySmall,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(16, 16, 12, 10),
        labelText: label,
        labelStyle: styles.bodySmall,
        floatingLabelStyle: styles.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 1)
        ),
        suffixIcon: suffixIcon,
      ),
      onChanged: onChanged,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onTap: onTap,
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
    dateController.addListener(() {
      if (dateController.value.text == '' || dateController.value.text.contains('de')) return;
      final String dateLimit = dateController.value.text; 
      context.read<MultipleFormProvider>().dateLimit = dateLimit;
      dateController.text = CustomDatetime().toPlainText(dateController.value.text);
    });
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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

    return _CustomTextFormField(
      maxLines: 1, 
      label: 'Fecha límite de cata (opcional)',
      controller: dateController,
      suffixIcon: const Icon(Icons.calendar_month_rounded),
      onTap: showCustomDialog,
      readOnly: true,
      canRequestFocus: false,
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
            dateController.text = dateEndDay;
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

    final multipleFormProvider = context.watch<MultipleFormProvider>();
    final colors = Theme.of(context).colorScheme;
    final List<Wines> wines = context.watch<WineServices>().winesByIndex;

    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            proxyDecorator: (child, index, animation) {
              return CustomMultipleWinesRow(
                key: Key('move_$index'),
                wine: wines.firstWhere((wine) => wine.id == multipleFormProvider.wineSequence[index]),
                index: index,
                color: colors.surfaceContainerLow,
                hiddenTaste: multipleFormProvider.hidden,
              );
            },  
            itemCount: multipleFormProvider.wineSequence.length, 
            itemBuilder: (context, index) {
              return CustomMultipleWinesRow(
                key: Key('main_$index'),
                wine: wines.firstWhere((wine) => wine.id == multipleFormProvider.wineSequence[index]),
                index: index,
                color: colors.surfaceContainerHigh,
                hiddenTaste: multipleFormProvider.hidden,
              );  
            }, 
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                context.read<MultipleFormProvider>().moveMultipleWine(oldIndex, newIndex);
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
    required this.color,
    required this.wine,
    required this.index,
    required this.hiddenTaste,
  });

  final Color color;
  final Wines wine;
  final int index;
  final bool hiddenTaste;

  @override
  Widget build(BuildContext context) {

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
            child: hiddenTaste
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vino a catar a ciegas ${index + 1}', 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis, 
                    style: styles.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
    
                  Text(
                    '${wine.vino} ${wine.anada}', 
                    maxLines: 1,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis, 
                    style: const TextStyle(fontSize: 10)
                  ),
                ],
              )
              : Text(
                wine.nombre, 
                maxLines: 2, 
                overflow: TextOverflow.ellipsis, 
                style: styles.bodySmall!.copyWith(fontWeight: FontWeight.bold),
              ),
          ),
      
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              context.read<MultipleFormProvider>().removeMultipleWine(wine.id!, context);
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
              // Valido que el multiple es correcto
              final String? isValidMultiple = context.read<MultipleFormProvider>().isValidMultiple();
              if (isValidMultiple != null) {
                NotificationServices.showSnackbar(isValidMultiple, context);
                return;
              } 
              // Creo nuevo multiple y lo subo al server
              final newMultipleTaste = await context.read<MultipleFormProvider>().createMultipleTaste();
              // Añado mi el nuevo multiple al listado
              if (context.mounted) context.read<MultipleListProvider>().addMultipleToList(newMultipleTaste);
              // Subir TasteQuiz si es necesario
              if (context.mounted && context.read<MultipleFormProvider>().tasteQuiz != null) {
                await context.read<QuizServices>().createQuiz(multipleId: newMultipleTaste.id!, wineIdList: newMultipleTaste.wineSequence);
              }
              if (context.mounted && context.read<MultipleFormProvider>().isBottomSheetOpen) {
                Navigator.pop(context);
              }
              if (context.mounted) Navigator.pop(context);
              // Limpiar las opciones de TasteScreen
              taste.clearOptions();
            },
          ),

          CustomElevatedButton(
            width: 120,
            label: 'Acceder',
            isSendingLabel: 'Accediendo',
            onPressed: () async {
              // Valido que el multiple es correcto
              final String? isValidMultiple = context.read<MultipleFormProvider>().isValidMultiple();
              if (isValidMultiple != null) {
                NotificationServices.showSnackbar(isValidMultiple, context);
                return;
              } 
              // Creo nuevo multiple y lo subo al server
              final newMultipleTaste = await context.read<MultipleFormProvider>().createMultipleTaste();
              // Añado mi el nuevo multiple al listado
              if (context.mounted) context.read<MultipleListProvider>().addMultipleToList(newMultipleTaste);
              // Subir TasteQuiz si es necesario
              if (context.mounted && context.read<MultipleFormProvider>().tasteQuiz != null) {
                await context.read<QuizServices>().createQuiz(multipleId: newMultipleTaste.id!, wineIdList: newMultipleTaste.wineSequence);
              }
              // Navego a la siguiente pantalla
              final routeList = MaterialPageRoute(
                builder: (context) => MultipleScreen(multipleTaste: newMultipleTaste)
              );
              if (context.mounted) Navigator.pushReplacement(context, routeList);
              // Limpiar las opciones de TasteScreen
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

    final winesService = Provider.of<WineServices>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: false);
    final styles = Theme.of(context).textTheme;

    final multipleFormProvider = context.watch<MultipleFormProvider>();

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
                    // No permito mas de 12 vinos en la cata
                    if (multipleFormProvider.wineSequence.length >= 12) {
                      NotificationServices.showSnackbar('No se permiten mas de 12 vinos', context);
                      return;
                    }
                    // Abro la ventana de busqueda
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
                              // Retorno true si he añadido el vino al wineForm
                              Navigator.pop(context, true);
                            },
                          ),
                        );
                        // Capturo true o false para ver si he añadido vino
                        final bool isSavedWine = await Navigator.push(context, newRoute);
                        // Agrego nuevo vino a la secuencia de vinos si se ha creado
                        if (context.mounted && isSavedWine) context.read<MultipleFormProvider>().addMultipleWine(wineForm.wine, context);
                      },  
                    ));
                    // Si no hay vino, salgo de la funcion
                    if (wineSearched == null) return;
                    // Compruebo si el vino ya esta añadido al listado y sino se añade
                    if (context.mounted) {
                      final bool isValidWine = context.read<MultipleFormProvider>().addMultipleWine(wineSearched, context);
                      if (!isValidWine) {
                        NotificationServices.showSnackbar('Vino duplicado', context);
                        return;
                      }
                    }
                  },
                  icon: Icons.search,
                ),

                CustomIconButton(
                  onPressed: () async {
                    // No permito mas de 12 vinos en la cata
                    if (multipleFormProvider.wineSequence.length >= 12) {
                      NotificationServices.showSnackbar('No se permiten mas de 12 vinos', context);
                      return;
                    }
                    // Resetear wineFormProvider
                    wineForm.resetSettings();

                    final newRoute = MaterialPageRoute(
                      builder: (context) => PopScope(
                        canPop: false,
                        child: CreateEditWineScreen(
                          saveEndAction: () {
                            // Retorno true si he añadido el vino al wineForm
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    );
                    // Capturo true o false si el vino se ha creado
                    final bool isSavedWine = await Navigator.push(context, newRoute);
                    // Agrego nuevo vino a la secuencia de vinos si se ha creado
                    if (context.mounted && isSavedWine) context.read<MultipleFormProvider>().addMultipleWine(wineForm.wine, context);
                  },
                  icon: Icons.add, 
                ),
           
                CustomIconButton(
                  onPressed: () => context.read<MultipleFormProvider>().hideTasteWines(),
                  icon: multipleFormProvider.hidden
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
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 5, right: 5),
      height: 42,
      child: Row(
        children: [
          const Text('Cata Quiz', style: TextStyle(fontSize: 14)),
      
          const Spacer(),

          Checkbox(
            value: context.watch<MultipleFormProvider>().tasteQuiz == 'simple',
            onChanged: (value) {
              context.read<MultipleFormProvider>().editTasteQuiz(simpleQuiz: value);
            },
          ),

          const Text('Sencilla', style: TextStyle(fontSize: 14)),

          Checkbox(
            value: context.watch<MultipleFormProvider>().tasteQuiz == 'advanced',
            onChanged: (value) {
              context.read<MultipleFormProvider>().editTasteQuiz(advancedQuiz: value);
            },
          ),
          
          const Text('Avanzada', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
