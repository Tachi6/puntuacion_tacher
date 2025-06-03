import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:diacritic/diacritic.dart';

import 'package:puntuacion_tacher/domain/entities/entities.dart';
import 'package:puntuacion_tacher/helpers/helpers.dart';
import 'package:puntuacion_tacher/presentation/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class SearchDelegateMultiple extends SearchDelegate{
  SearchDelegateMultiple({required this.multipleList}) {
    _filtro = [...multipleList];
  }

  final List<Multiple> multipleList;

  late List<Multiple> _filtro;

  Future<bool?> enterPasswordBox(BuildContext context, Multiple multiple) { //TODO: refactor
    return showGeneralDialog(
      context: context,
      barrierDismissible: false, 
      pageBuilder: (context, animation, secondaryAnimation) {
        
        final styles = Theme.of(context).textTheme;
        String? password;

        return PopScope(
          canPop: false,
          child: CustomAlertDialog(
            title: 'Introduce Contraseña',
            saveText: 'Enviar',
            cancelText: 'Cancelar',
            content: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextField(
                style: styles.bodyLarge,
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(16, 16, 12, 10),               
                  labelText: 'Contraseña',
                  floatingLabelStyle: styles.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
                onChanged: (value) => password = value,
              ),
            ),
            onPressedSave: () {
              final String decryptedPassword = EncryptionService().decryptData(multiple.password!);

              if (decryptedPassword == password) {
                Navigator.pop(context, true);
                return;
              }
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.pop(context, false);
            }, 
            onPressedCancel: () => Navigator.pop(context),
          ),
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
  String? get searchFieldLabel => 'Buscar Cata Múltiple';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(fontSize: 18, decorationThickness: 0, decoration: TextDecoration.none);

  @override
  List<Widget>? buildActions(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return [
      IconButton(
        onPressed: () => query ='', 
        icon: Icon(Icons.clear, color: colors.onSurface)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: () {
        close(context, null);
      }, 
      icon: Icon(Icons.arrow_back, color: colors.onSurface),
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    if(_filtro.isEmpty) {
      return const NoResultsMultiple();
    } 

    return ListView.builder(
      itemCount: _filtro.length,
      itemBuilder: ( _ , index) {
        return ListTile(
          title: Text(_filtro[index].name),
          subtitle: Text(_filtro[index].description, maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () async {
            showResults(context);
            FocusManager.instance.primaryFocus?.unfocus();
            // Para cata con contraseña
            if (_filtro[index].password != null) {
              final bool? isCorrectPassword = await enterPasswordBox(context, _filtro[index]);
              if (isCorrectPassword == null) {
                return;
              }
              if (isCorrectPassword && context.mounted) {
                close(context, _filtro[index].copy());
                return;
              }
              if (!isCorrectPassword && context.mounted) {
                NotificationServices.showSnackbar('Contraseña incorrecta', context); 
                return;
              }
              return;
            }
            // Para cata sin contraseña
            close(context, _filtro[index].copy());
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final multipleListProvider = context.watch<MultipleListProvider>();

    if (query.isEmpty) {
      _filtro = multipleList;
    }
 
    _filtro = multipleListProvider.multipleList.where((multiple) {
      return removeDiacritics(multiple.name.toLowerCase()).contains(removeDiacritics(query.trim().toLowerCase()));
    }).toList();

    if(_filtro.isEmpty) {
      return const NoResultsMultiple();
    } 

    return ListView.builder(
      itemCount: _filtro.length,
      itemBuilder: ( _ , index) {
        return ListTile(
          title: Text(_filtro[index].name),
          subtitle: Text(_filtro[index].description, maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () async {
            showResults(context);
            FocusManager.instance.primaryFocus?.unfocus();
            // Para cata con contraseña
            if (_filtro[index].password != null) {
              final bool? isCorrectPassword = await enterPasswordBox(context, _filtro[index]);
              if (isCorrectPassword == null) return;
          
              if (isCorrectPassword && context.mounted) {
                if (_filtro[index].tasteQuiz != null) await context.read<QuizServices>().loadQuiz(_filtro[index].id!);
                if (context.mounted) close(context, _filtro[index].copy());
                return;
              }
              if (!isCorrectPassword && context.mounted) {
                NotificationServices.showSnackbar('Contraseña incorrecta', context);
                return;
              }
              return;
            }
            // Para cata sin contraseña
            if (_filtro[index].tasteQuiz != null) await context.read<QuizServices>().loadQuiz(_filtro[index].id!);
            if (context.mounted) close(context, _filtro[index].copy());
          },
        );
      },
    );
  }
}

class MultipleWineImage extends StatelessWidget {
  const MultipleWineImage({super.key});


  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    Widget wineIcon() {
      return AssetSvgPicture(
        assetBytesRoute: 'assets/wine_bar_full.svg.vec',
        height: 60,
        color: colors.onPrimaryFixedVariant,
      );
    }

    return SizedBox(
      width: 240,
      height: 210,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: wineIcon()
          ),

          Positioned(
            top: 20,
            left: 50,
            child: wineIcon()
          ),

          Positioned(
            top: 40,
            left: 100,
            child: wineIcon()
          ),

          Positioned(
            top: 60,
            left: 150,
            child: wineIcon()
          ),

          Positioned(
            top: 80,
            left: 200,
            child: wineIcon()
          ),

          Positioned(
            top: 70,
            left: 0,
            child: wineIcon()
          ),

          Positioned(
            top: 90,
            left: 50,
            child: wineIcon()
          ),

          Positioned(
            top: 110,
            left: 100,
            child: wineIcon()
          ),

          Positioned(
            top: 130,
            left: 150,
            child: wineIcon()
          ),

          Positioned(
            top: 150,
            left: 200,
            child: wineIcon()
          ),
        ],
      ),
    );
  }
}

class NoResultsMultiple extends StatelessWidget {
  const NoResultsMultiple({super.key});

  @override
  Widget build(BuildContext context) {   
    return SingleChildScrollView(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 40,
              child: const Text(
                'Cata múltiple no encontrada', 
                textAlign: TextAlign.center, 
                style: TextStyle(fontSize: 16)
              ),
            ),
            
            const SizedBox(height: 20),
        
            const MultipleWineImage(),
        
            const SizedBox(height: 20),
            
            //TODO: ver si se puede pedir nombre antes de entrar a crear cata
            // CustomElevatedButton(
            //   width: 160,
            //   height: 40, 
            //   onPressed: () async {
            //     Navigator.pop(context);
        
            //     final routeDetails = MaterialPageRoute(
            //       builder: (context) => const CreateMultipleTasteScreen(),
            //     );
            //     Navigator.push(context, routeDetails);
            //   },
            //   label: 'Crear cata múltiple',
            // ),
          ],
        ),
      ),
    );
  }
}
