import 'package:flutter/material.dart';

import 'package:s7_peliculas/models/actores_model.dart';
import 'package:s7_peliculas/models/pelicula_model.dart';
import 'package:s7_peliculas/providers/pelicula_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  final _peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> argumentos =
        ModalRoute.of(context).settings.arguments;

    final Pelicula pelicula = argumentos["pelicula"];

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10.0,
              ),
              this._posterTitulo(context, pelicula),
              this._descripcion(pelicula),
              this._descripcion(pelicula),
              this._crearCasting(pelicula)
            ]),
          )
        ],
      ),
    );
  }

  Widget _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0, //como se ve hacia adentro  Z-INDEX VEAMOSLO ASI
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true, //se mantenga visibbe cuando se hace scroll
      flexibleSpace: FlexibleSpaceBar(
        //este widget es el que se adapta dentro de la cajita
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackground()),
          placeholder: AssetImage("assets/img/loading.gif"),
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 150),
        ),
      ),
    );
  }

  //este widget muestra lo que es la imagen chirris,la valoracion ,titulo y subtitulo de la pelicula
  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    print(pelicula.idTarjeta);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.idTarjeta,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                height: 150.0,
                image: NetworkImage(pelicula.getImage()),
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title,
                    style: Theme.of(context).textTheme.title,
                    overflow: TextOverflow.ellipsis),
                Text(
                  pelicula.originalTitle,
                  style: Theme.of(context).textTheme.subhead,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star_border,
                      color: Colors.yellow,
                    ),
                    Text(pelicula.voteAverage.toString(),
                        style: Theme.of(context).textTheme.subhead)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

/* ================================ACTORES====================================== */

//este metodo unicamente consume el future de el cast de actores
  _crearCasting(Pelicula pelicula) {
    return FutureBuilder(
      future: this._peliculasProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return this._crearActoresPageView(context, snapshot.data);
        } else {
          return Container(
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

//este es para poder crear el carrusel de actores
  Widget _crearActoresPageView(BuildContext context, List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        itemCount: actores.length,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemBuilder: (context, i) => this._tarjetaActor(actores[i]),
      ),
    );
  }

  Widget _tarjetaActor(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              height: 150.0,
              image: NetworkImage(actor.getPhoto()),
              placeholder: AssetImage("assets/img/no-image.jpg"),
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  //Este metodo unicamente le da la tarjettia de los actores
}
