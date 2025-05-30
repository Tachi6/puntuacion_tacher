import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/domain/entities/entities.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/pages/pages.dart';
import 'package:puntuacion_tacher/presentation/providers/providers.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class MultipleMainPage extends StatefulWidget {
  const MultipleMainPage({
    super.key, 
  });

  @override
  State<MultipleMainPage> createState() => _MultipleMainPageState();
}

class _MultipleMainPageState extends State<MultipleMainPage> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final multipleProvider = context.watch<MultipleProvider>();
    final wineForm = context.watch<CreateEditWineFormProvider>();
    final styles = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomMultipleAppBar(
        onPressedBackButton: () {
          if (context.read<QuizProvider>().isBottomSheetOpen) Navigator.pop(context);
          Navigator.pop(context);
          wineForm.resetSettings();
        }
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            
            _CustomField(
              label: 'Descripción', 
              text: multipleProvider.multipleSelected.description,
            ),
        
            const SizedBox(height: 20),
        
            _CustomField(
              label: 'Fecha límite de cata', 
              text: multipleProvider.multipleSelected.dateLimit != null 
                ? CustomDatetime().toPlainText(multipleProvider.multipleSelected.dateLimit!)
                : 'Sin fecha límite de cata',
            ),
        
            const SizedBox(height: 15),
        
            Text('Vinos a catar', textAlign: TextAlign.center, style: styles.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
        
            const SizedBox(height: 10),
                  
            _WinesListView(),
        
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class _CustomField extends StatefulWidget {
  const _CustomField({
    required this.text, 
    required this.label
  });

  final String text;
  final String label;

  @override
  State<_CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<_CustomField> {

  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(
      text: widget.text,
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return TextField(
      autofocus: false,
      canRequestFocus: false,
      readOnly: true,
      style: styles.bodySmall,
      maxLines: null,
      controller: textEditingController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(16, 16, 12, 10),
        filled: true,
        fillColor: colors.surfaceContainerHigh,
        label: Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1),
            color: colors.primary,
          ),
          child: Text(widget.label),
        ),
        floatingLabelStyle: styles.bodyLarge!.copyWith(fontWeight: FontWeight.bold, color: colors.onInverseSurface),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          borderRadius: BorderRadius.circular(12)
        ),
      ),
    );
  }
}

class _WinesListView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final multipleProvider = context.watch<MultipleProvider>();
    final colors = Theme.of(context).colorScheme;
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);
    final quizProvider = context.watch<QuizProvider>();
    final bool isQuizValidated = quizProvider.isValidatedQuiz();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: multipleProvider.multipleWines.length + (multipleProvider.multipleSelected.tasteQuiz != null ? 2 : 1),
      itemBuilder: (context, index) {
        late final Wines wine;
        if (index < multipleProvider.multipleWines.length) wine = multipleProvider.multipleWines[index];
        
        if (index == multipleProvider.multipleSelected.wineSequence.length + 1) {
          return CustomMultipleWineRow(
            index: index,
            title: 'Taste Quiz',
            primaryColor: colors.surfaceContainerHigh,
            checkedIcon: isQuizValidated,
            trailingIcon: Icons.arrow_forward,
            backgroundIcon: Icons.list_alt_outlined,
            onPressed: () {
              if (!multipleProvider.isMultipleTasted && !multipleProvider.isMultipleInTime()) {
                NotificationServices.showSnackbar('La cata esta finalizada', context);
                return;
              }
              if (quizProvider.isValidQuiz()) quizProvider.openBottomSheet(context); // TODO!!!
              multipleProvider.setandMoveToPage(const MultipleQuizPage());
            } 
          );
        }

        if (index == multipleProvider.multipleSelected.wineSequence.length) {
          return CustomMultipleWineRow(
            index: index,
            title: 'Resultados de cata',
            primaryColor: colors.surfaceContainerHigh,
            checkedIcon: multipleProvider.isMultipleTasted,
            trailingIcon: Icons.arrow_forward,
            backgroundIcon: Icons.leaderboard_outlined,
            onPressed: () {
              if (!multipleProvider.isMultipleTasted && !multipleProvider.isMultipleInTime()) {
                NotificationServices.showSnackbar('La cata esta finalizada', context);
                return;
              }
              if (!multipleProvider.isMultipleTasted) {
                NotificationServices.showSnackbar('Realiza todas las catas para ver el resultado', context);
                return;
              }
              if (multipleProvider.isMultipleTasted && multipleProvider.multipleSelected.tasteQuiz != null && !isQuizValidated) {
                NotificationServices.showSnackbar('Valida el quiz para ver el resultado', context);
                return;
              }
              multipleProvider.setandMoveToPage(const MultipleResultsPage());
            },
          );
        }

        return CustomMultipleWineRow(
          index: index,
          checkedIcon: multipleProvider.isWineTasted(wine.id!),
          title: multipleProvider.multipleSelected.hidden && !multipleProvider.isMultipleTasted
            ? 'Vino a catar a ciegas ${index + 1}'
            : wine.nombre,
          primaryColor: colors.surfaceContainerHigh,
          trailingIcon: Icons.arrow_forward,
          onPressed: () {
            if (!multipleProvider.isMultipleTasted && !multipleProvider.isMultipleInTime()) {
              NotificationServices.showSnackbar('La cata esta finalizada', context);
              return;
            }

            final WineTaste? selectedWineTaste = multipleProvider.getSelectedWineTaste(wine.id!);

            if (selectedWineTaste == null) {
              wineForm.setEditSearchedWine(wine);
              wineForm.setDefaultRatings();
            }

            multipleProvider.setandMoveToPage(MultipleTacherPage(
              appBarTitle: multipleProvider.multipleSelected.hidden && !multipleProvider.isMultipleTasted
                ? 'Vino a catar a ciegas ${index + 1}'
                : wine.nombre,
              selectedWineTaste: selectedWineTaste,
            ));
          }
        );
      }
    );
  }
}

class CustomMultipleWineRow extends StatelessWidget {
  const CustomMultipleWineRow({
    super.key,
    this.checkedIcon,
    required this.title,
    this.subTitle,
    required this.index,
    required this.primaryColor,
    this.secundaryColor,
    required this.trailingIcon,
    this.backgroundIcon,
    this.onPressed,
  });

  final int index;
  final bool? checkedIcon;
  final String title;
  final String? subTitle;
  final Color primaryColor;
  final Color? secundaryColor;
  final IconData trailingIcon;
  final IconData? backgroundIcon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {

    final multipleProvider = context.watch<MultipleProvider>();
    final styles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    late final AnimationController animationController;

    late Widget leadingIcon;
    switch (checkedIcon) {
      case null: 
        leadingIcon = const _CustomTileIcon(icon: Icons.menu);
        break;
      case true: 
        leadingIcon = ZoomIn(
          delay: const Duration(milliseconds: 200),
          controller: (p0) => animationController = p0,
          onFinish: (direction) => animationController.stop(),
          child: const _CustomTileIcon(icon: Icons.check),
        );
        break;
      case false: 
        leadingIcon = multipleProvider.isMultipleInTime() 
          ? const _CustomTileIcon(icon: Icons.schedule)
          : const _CustomTileIcon(icon: Icons.block);
        break;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                colors.secondaryFixedDim,
                colors.primaryFixedDim,
              ]
            ),
            borderRadius: BorderRadius.circular(20)
          ),
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.only(right: 18, left: 24),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (secundaryColor != null) const Icon(Icons.menu),
        
              Align(
                alignment: Alignment.centerLeft,
                child: leadingIcon,
              ),
                 
              Positioned(
                right: backgroundIcon != null ? 36 : 26,
                child: Transform.rotate(
                  angle: -0.33,
                  child: FaIcon(
                    backgroundIcon ?? Icons.wine_bar,
                    size: 100,
                    color: colors.surface.withAlpha(128),
                  ),
                ),
              ),
        
              const Align(
                alignment: Alignment.centerRight,
                child: _CustomTileIcon(icon: Icons.chevron_right),
              ),

              Positioned(
                left: 56,
                right: 62,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title, 
                      maxLines: 2, 
                      overflow: TextOverflow.ellipsis, 
                      style: styles.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  
                    if (subTitle != null) Text(
                      subTitle!,
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis, 
                      style: styles.bodySmall!.copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        MaterialButton(
          padding: const EdgeInsets.only(top: 10),
          height: 80,
          minWidth: double.infinity,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          onPressed: onPressed
        )
      ],
    );
  }
}

class _CustomTileIcon extends StatelessWidget {
  const _CustomTileIcon({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: Colors.white, size: 36);
  }
}