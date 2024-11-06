import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class MultipleInitialPage extends StatelessWidget {
  const MultipleInitialPage({
    super.key, 
  });

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final styles = Theme.of(context).textTheme;

    String dateLimit() {
      if (multipleTaste.multipleTaste.dateLimit == null) {
        return 'Sin limite';
      }
      else {
        final DateTime dateLimit = CustomDatetime().toDateTime(multipleTaste.multipleTaste.dateLimit!);
        return '${dateLimit.day}-${dateLimit.month}-${dateLimit.year}';
      }          
    }

    return Scaffold(
      appBar: const CustomMultipleAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            Text(multipleTaste.multipleTaste.name, textAlign: TextAlign.center, style: styles.titleLarge!.copyWith(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),
            
            if (multipleTaste.multipleTaste.description != null) Text(multipleTaste.multipleTaste.description!),

            const SizedBox(height: 10),

            Text('Fecha límite para realizar la cata', textAlign: TextAlign.center, style: styles.titleMedium),

            Text(
              dateLimit(),
            ),

            Text('Vinos a catar', textAlign: TextAlign.center, style: styles.titleMedium!.copyWith(fontWeight: FontWeight.bold)),

            Expanded(
              child: ListView.builder(
                itemCount: multipleTaste.winesMultipleTaste.length,
                itemBuilder: (context, index) {
                  return Text(multipleTaste.winesMultipleTaste[index].nombre);
                },
              ),
            ),
          ],
        ),
      ),
      // bottomSheet: customMultipleBottomSheet,
    );
  }
}
