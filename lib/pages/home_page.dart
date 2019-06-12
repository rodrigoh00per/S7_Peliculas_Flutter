import 'package:flutter/material.dart';
import 'package:s7_peliculas/providers/pelicula_provider.dart';
import 'package:s7_peliculas/search/search_delegate.dart';
import 'package:s7_peliculas/widgets/card_swiper_widget.dart';
import 'package:s7_peliculas/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
//este es el servicio que nos sirve para poder traer las pelis

  final _peliculasProvider = PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    this._peliculasProvider.getPopulares();
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.indigoAccent,
          title: Row(children: [
            Icon(Icons.movie),
            SizedBox(width: 10),
            Text("Peliculas en cines")
          ]),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                //ESTE ES EL METODO QUE OFRECE FLUTTER PARA LAS BUSQUEDAS DE INFO
                showSearch(context: context, delegate: DataSearch());
              },
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[_swiperTarjetas(), _footer(context)],
        ));
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: _peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            peliculas: snapshot.data,
          );
        } else {
          return Container(
            height: 300.0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              "Peliculas Populares",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          StreamBuilder(
            stream: this._peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: this._peliculasProvider.getPopulares,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
