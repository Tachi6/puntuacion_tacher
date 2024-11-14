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
            const SizedBox(height: 10),
            
            if (multipleTaste.multipleTaste.description != null) _CustomField(
              label: 'Descripción', 
              text: multipleTaste.multipleTaste.description!
            ),

            const SizedBox(height: 20),

            if (multipleTaste.multipleTaste.dateLimit != null) _CustomField(
              label: 'Fecha límite de cata', 
              text: CustomDatetime().toPlainText(multipleTaste.multipleTaste.dateLimit!),
            ),

            const SizedBox(height: 10),

            Text('Vinos a catar', textAlign: TextAlign.center, style: styles.titleMedium!.copyWith(fontWeight: FontWeight.bold)),

            const SizedBox(height: 5),

            Expanded(
              child: _WinesListView(
                winesMultipleTaste: multipleTaste.winesMultipleTaste,
              ),
            ),
          ],
        ),
      ),
      // bottomSheet: customMultipleBottomSheet,
    );
  }
}

class _CustomField extends StatelessWidget {
  const _CustomField({
    required this.text, 
    required this.label
  });

  final String text;
  final String label;

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme;
    final TextEditingController textEditingController = TextEditingController(
      text: text,
    );

    return TextField(
      autofocus: false,
      canRequestFocus: false,
      readOnly: true,
      style: styles.bodySmall,
      maxLines: null,
      controller: textEditingController,
      decoration: InputDecoration(
        labelStyle: styles.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        labelText: label,
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(15)
        )
      ),
    );
  }
}

class _WinesListView extends StatelessWidget {
  const _WinesListView({required this.winesMultipleTaste});

  final List<Wines> winesMultipleTaste;

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme;

    return ListView.builder(
      itemCount: winesMultipleTaste.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [   
            if (index == 0) const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
              ),
            ),
        
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 0, bottom: 8, left: 10, right: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                winesMultipleTaste[index].nombre,
                style: styles.bodyMedium
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 0, bottom: 8, left: 10, right: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                winesMultipleTaste[index].tipo,
                style: styles.bodySmall
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 0, bottom: 8, left: 10, right: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                '${winesMultipleTaste[index].bodega}, ${winesMultipleTaste[index].region}',
                style: styles.bodySmall
              ),
            ),
                             
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(),
            ),
          ],
        );
      }
    );
  }
}
