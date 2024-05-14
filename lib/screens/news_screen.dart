import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
   
  const NewsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(),
          SliverList(
            delegate: SliverChildListDelegate([
              _NewsPoster()
            ]
              
              ))
        ],
      )
    );
  }
}

class _CustomAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color.fromARGB(255, 114, 47, 55),
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          color: Colors.black38,
          alignment: Alignment.bottomCenter,
          child: const Text('SECRETOS Y CLAVES DEL MARIDAJE', style: TextStyle(fontSize: 16))),
        background: const FadeInImage(
          placeholder: AssetImage('assets/no_image.jpg'), 
          image: AssetImage('assets/cabecera.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _NewsPoster extends StatelessWidget {

  final String description = 'Durante mis años trabajando como sumiller siempre tuve algo muy claro: “el mejor maridaje es el que más disfrutas tú”. Esto, para mí, es indiscutible. Sin embargo, si tienes la gran suerte de ser un foodie que ama el vino, puedes divertirte descubriendo las infinitas conexiones que existen entre el vino y la comida.|Aunque cada paladar es un mundo, existen guías que te ayudarán a crear matrimonios gustativos infalibles. En este artículo vamos a revelar los secretos que debes conocer para que puedas sacar al sumiller que llevas dentro.|Antes de pensar en hacer de celestina y crear parejas, debes conocer muy bien tanto el vino como la receta que vas a cocinar para lograr que surja la magia.|En el plato debes localizar los sabores principales. Para ello, es importante realizar, entre otras, estas preguntas: ¿es dulce, salado, ácido, amargo o se percibe con intensidad el sabor umami?, ¿graso o ligero?, ¿tiene una salsa picante, especiada, herbácea, cremosa o afrutada?, ¿es un producto ahumado, encurtido o en salazón?, ¿está cocinado al horno, a la parrilla, a la plancha o de otra forma? |Y en el vino, ¿qué tipo es?, ¿fresco, ligero y con una alta acidez o más concentrado, potente y estructurado?, ¿cómo son sus taninos: finos, suaves, firmes o pulidos? ¿qué tipo de aromas predominan?, ¿predominan las notas especiadas, ahumadas, afrutadas, salinas o minerales?|Ahora que ya conoces a fondo las dos partes de la pareja, sólo tienes que interiorizar estas reglas:|- La comida y el vino deben tener la misma intensidad.|- El vino debe tener siempre una mayor acidez que la comida.|- Si el vino es tánico, busca platos con grasa para suavizar su efecto.|- Si vas a disfrutar de un postre dulce, asegúrate de que el vino sea aún más dulce.|- La clave para un gran maridaje a menudo se encuentra en el tipo de salsa de la receta.|A partir de estas 5 guías puedes escoger entre dos estrategias básicas de maridaje: buscar combinaciones congruentes, es decir, con características similares, o buscar el contraste entre el vino y la comida con conexiones opuestas. Mientras que la primera opción maximiza los sabores que destacan en el plato, la segunda busca encontrar un perfecto equilibrio entre los distintos elementos.|Por ejemplo, un maridaje congruente sería un guiso de carne especiado con un vino tinto en el que el carácter de las especias se percibe con intensidad. Mientras que un maridaje de contraste sería un asado de cerdo ibérico con alto contenido graso con un riesling seco, cítrico y con una alta acidez para “cortar” la grasa, limpiar la boca y hacer el trago más agradable.|Aquí te presento mis maridajes estrella, unos clásicos y otros más sorprendentes:';
  
  String get newDescription {
    return description.replaceAll("|", "\n");
  }

  final String description2 = 'Champagne y pollo frito|En el mundo del maridaje hay un rey indiscutible: el champagne. Su perfil fresco, nítido, cítrico y su complejidad hacen que estas deliciosas burbujas mariden muy bien con infinidad de platos. Con ostras, con caviar, con marisco, con jamón ibérico, con salsas cremosas… con los mejores manjares siempre aparece un gran champagne para hacernos felices. |Pero el rey de los espumosos no solo intensifica el placer de degustar productos de lujo. De hecho, uno de los mejores maridajes lo forma con el pollo frito al estilo Kentucky. Jugoso y crujiente, hay pocos que nos resistamos a esta delicia tan americana. Pruébalo con Champagne Brimoncourt Blanc De Blancs para vivir una auténtica experiencia.';
  
  String get newDescription2 {
    return description2.replaceAll("|", "\n");
  }    
 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top:20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(newDescription),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: const FadeInImage(
                    placeholder: AssetImage('assets/no_image.jpg'),
                    image: AssetImage('assets/cava1.jpg'),
                    fit: BoxFit.cover, 
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.67,
                  child: Text(newDescription2)
                  )
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: const FadeInImage(
                    placeholder: AssetImage('assets/no_image.jpg'),
                    image: AssetImage('assets/cava1.jpg'),
                    fit: BoxFit.cover, 
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.67,
                  child: Text(newDescription2)
                  )
                
              ],
            ),
          )
        ],
      ),
    );
  }
}