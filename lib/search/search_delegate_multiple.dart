import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puntuacion_tacher/helpers/helpers.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class SearchDelegateMultiple extends SearchDelegate{
  SearchDelegateMultiple();

  late List<Multiple> _filtro;

  Future<bool?> enterPasswordBox(BuildContext context, Multiple multiple) {
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
  String? get searchFieldLabel => 'Buscar vino';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(fontSize: 18, decorationThickness: 0, decoration: TextDecoration.none);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query ='', 
        icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    if(_filtro.isEmpty) {
      return const NoResultsMultiple(
        titleLabel: 'Cata múltiple no encontrada',
      ); //noResultsMultiple(context);
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
                NotificationsService.showSnackbar('Contraseña incorrecta', context); 
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

    final multipleService = Provider.of<MultipleService>(context);

    if (query.isEmpty) {
      return const NoResultsMultiple();
    }
 
    _filtro = multipleService.multipleTasteList.where((multiple) {
      return multiple.name.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();

    if(_filtro.isEmpty) {
      return const NoResultsMultiple(
        titleLabel: 'Cata múltiple no encontrada',
      ); //noResultsMultiple(context);
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
                NotificationsService.showSnackbar('Contraseña incorrecta', context);
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
}

class MultipleWineImage extends StatelessWidget {
  const MultipleWineImage({super.key});

  SvgPicture wineIcon(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SvgPicture.asset(
      'assets/wine_bar_full.svg',
      height: 60,
      colorFilter: ColorFilter.mode(colors.onPrimaryFixedVariant, BlendMode.srcIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 210,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: wineIcon(context)
          ),

          Positioned(
            top: 20,
            left: 50,
            child: wineIcon(context)
          ),

          Positioned(
            top: 40,
            left: 100,
            child: wineIcon(context)
          ),

          Positioned(
            top: 60,
            left: 150,
            child: wineIcon(context)
          ),

          Positioned(
            top: 80,
            left: 200,
            child: wineIcon(context)
          ),

          Positioned(
            top: 70,
            left: 0,
            child: wineIcon(context)
          ),

          Positioned(
            top: 90,
            left: 50,
            child: wineIcon(context)
          ),

          Positioned(
            top: 110,
            left: 100,
            child: wineIcon(context)
          ),

          Positioned(
            top: 130,
            left: 150,
            child: wineIcon(context)
          ),

          Positioned(
            top: 150,
            left: 200,
            child: wineIcon(context)
          ),
        ],
      ),
    );
  }
}

class NoResultsMultiple extends StatelessWidget {
  const NoResultsMultiple({
    super.key, 
    this.titleLabel, 
    this.buttonLabel
  });

  final String? titleLabel;
  final String? buttonLabel;

  @override
  Widget build(BuildContext context) {   
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
      
          Container(
            alignment: Alignment.center,
            height: 40,
            child: titleLabel != null 
              ? Text(titleLabel!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16))
              : null
          ),
          
          const SizedBox(height: 20),
      
          const MultipleWineImage(),
      
          const SizedBox(height: 20),
          
          buttonLabel != null 
            ? CustomElevatedButton(
              width: 170,
              height: 35, 
              onPressed: () {
                // TODO hacer la funcion del boton
              },
              child: const Text('Crear cata múltiple'),
            )
            : const SizedBox(
              height: 35,
            )
        ],
      ),
    );
  }
}