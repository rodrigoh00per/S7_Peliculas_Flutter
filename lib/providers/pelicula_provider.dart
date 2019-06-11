import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:s7_peliculas/models/pelicula_model.dart';

class PeliculasProvider {
  String _url = "api.themoviedb.org";
  String _apikey = "6b282d3a39d81f9ef649c9c07ed15357";
  String _language = "es-ES";

  int numpag = 0;

  bool cargandoPopular = false;

  List<Pelicula> _peliculasPopulares = new List();

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void dispose() {
    _popularesStreamController?.close();
  }
//este es como en angluar regresar una suscripcion

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final respuestaDecode =
        json.decode(resp.body); //la respuesta recuerda que va en el body

    final peliculas = Peliculas.fromJSONlist(respuestaDecode['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final _url = Uri.https(this._url, "3/movie/now_playing",
        {"api_key": this._apikey, "language": this._language});
    return this._procesarRespuesta(_url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (this.cargandoPopular) {
      return [];
    }
    this.cargandoPopular = true;

    print("cargando peliculas populares");

    this.numpag++;

    final _url = Uri.https(this._url, "3/movie/popular", {
      "api_key": this._apikey,
      "language": this._language,
      "page": this.numpag.toString()
    });

    final resp = await this._procesarRespuesta(_url);
//estamos añadiendo todo a la lista poderosa
    this._peliculasPopulares.addAll(resp);
//aqui  se agrega la flujo de informacion
    this.popularesSink(this._peliculasPopulares);
    this.cargandoPopular = false;

    return resp;
  }
}
