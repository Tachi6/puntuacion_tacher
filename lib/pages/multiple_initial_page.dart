import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class MultipleInitialPage extends StatefulWidget {
  const MultipleInitialPage({
    super.key, 
  });

  @override
  State<MultipleInitialPage> createState() => _MultipleInitialPageState();
}

class _MultipleInitialPageState extends State<MultipleInitialPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);    

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final styles = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const CustomMultipleAppBar(
        allowActionButtons: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            
            _CustomField(
              label: 'Descripción', 
              text: multipleTaste.multipleTaste.description,
            ),

            const SizedBox(height: 20),

            _CustomField(
              label: 'Fecha límite de cata', 
              text: multipleTaste.multipleTaste.dateLimit != null 
                ? CustomDatetime().toPlainText(multipleTaste.multipleTaste.dateLimit!)
                : 'Sin fecha límite de cata',
            ),

            const SizedBox(height: 15),

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
  
  @override
  bool get wantKeepAlive => true;
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
        contentPadding: const EdgeInsets.fromLTRB(16, 16, 12, 10),
        labelStyle: styles.bodySmall,
        labelText: label,
        floatingLabelStyle: styles.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(12)
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
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleServices>(context);

    return ListView.builder(
      itemCount: winesMultipleTaste.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [   
            if (index == 0) const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
              ),
            ),

            if (multipleTaste.multipleTaste.hidden) const SizedBox(height: 4),
        
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 0, bottom: 6, left: 10, right: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                (multipleTaste.multipleTaste.hidden && !multipleService.isMultipleTasted) 
                  ? 'Vino a catar a ciegas ${index + 1}' 
                  : winesMultipleTaste[index].nombre,
                style: styles.bodyMedium
              ),
            ),

            if (!multipleTaste.multipleTaste.hidden) Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 0, bottom: 6, left: 10, right: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                winesMultipleTaste[index].tipo,
                style: styles.bodySmall
              ),
            ),

            if (!multipleTaste.multipleTaste.hidden) Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 0, bottom: 4, left: 10, right: 10),
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
