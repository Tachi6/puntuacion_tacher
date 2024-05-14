
enum Tipos {
    blancoBlanco,
    tintoConCrianza,
    tintoCrianza,
    tintoGranReserva,
    tintoJoven,
    tintoReserva,
    tintoRoble
}

final tipoValues = EnumValues({
    "Blanco, Blanco": Tipos.blancoBlanco,
    "Tinto, con Crianza": Tipos.tintoConCrianza,
    "Tinto, Crianza": Tipos.tintoCrianza,
    "Tinto, Gran Reserva": Tipos.tintoGranReserva,
    "Tinto, Joven": Tipos.tintoJoven,
    "Tinto, Reserva": Tipos.tintoReserva,
    "Tinto, Roble": Tipos.tintoRoble
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
