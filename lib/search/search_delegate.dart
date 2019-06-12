import 'package:flutter/material.dart';
import 'package:s7_peliculas/models/pelicula_model.dart';
import 'package:s7_peliculas/providers/pelicula_provider.dart';
import 'package:flutter/services.dart';

class DataSearch extends SearchDelegate {
  final _peliculasProvider = PeliculasProvider();
  String seleccion = "";
  List listaPeliculas = [
    "IronMan",
    "Thor",
    "Spiderman",
    "Capitan America",
    "Batman",
    "Superman"
  ];
  List listaSugerencias = ["Spiderman", "Capitan America"];

  List<Pelicula> _listaPeliculasSugerencia = List();
  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro appbar (como cerrar o cancelar)
    return [
      IconButton(
        onPressed: () {
          query =
              ""; //este es un valor que viene de manera interna para la parte de las busquedas
        },
        icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono por ejemplo a la izquierda (una lupa o regresar)
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context,
            null); //este es un metodo interno que viene en el search delegate
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar

    return ListView.builder(
      itemCount: this._listaPeliculasSugerencia.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            close(context, null);
            this._listaPeliculasSugerencia[index].idTarjeta = '';

            Navigator.pushNamed(context, 'peliculaDetalle',
                arguments: {"pelicula": this._listaPeliculasSugerencia[index]});
          },
          leading: FadeInImage(
            height: 50.0,
            placeholder: AssetImage("assets/img/no-image.jpg"),
            image:
                NetworkImage(this._listaPeliculasSugerencia[index].getImage()),
          ),
          title: Text(this._listaPeliculasSugerencia[index].title),
          subtitle: Text(this._listaPeliculasSugerencia[index].originalTitle),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //query es valor a busqueda

    if (query.isEmpty) {
      return Container();
    } else {
      Widget peliculaLista = Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: this._peliculasProvider.buscarPelicula(query),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Pelicula>> snapshot) {
                if (snapshot.hasData) {
                  final peliculas = snapshot.data;
                  this._listaPeliculasSugerencia = peliculas;

                  return ListView.builder(
                    itemCount: peliculas.length,
                    itemBuilder: (BuildContext context, i) {
                      return ListTile(
                        leading: FadeInImage(
                          height: 50.0,
                          image: NetworkImage(peliculas[i].getImage()),
                          placeholder: AssetImage('assets/img/no-image.jpg'),
                          width: 50.0,
                          fit: BoxFit.contain,
                        ),
                        title: Text(peliculas[i].title),
                        subtitle: Text(peliculas[i].originalTitle),
                        onTap: () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          close(context, null);
                          peliculas[i].idTarjeta = '';

                          Navigator.pushNamed(context, 'peliculaDetalle',
                              arguments: {"pelicula": peliculas[i]});
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      );
      return peliculaLista;
    }
  }

  /*   @override
  Widget buildSuggestions(BuildContext context) {
  ;  //query es valor a busqueda
    var listabusqueda = (query.isEmpty)
  ;      ? this.listaSugerencias
        : this.listaPeliculas.where((pelicula) {
            return pelicula.toLowerCase().startsWith(query);
          }).toList();

    // Son las sugerencias  que aparecen cuando la persona escribe
    return ListView.builder(
      itemCount: listabusqueda.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(listabusqueda[i]),
          leading: Icon(Icons.movie),
          onTap: () {
            this.seleccion = listabusqueda[i];
            showResults(
                context); //este metodo se tiene que ejeutar para que muestre el buildresults
            //mas bien se ejecute
          },
        );
      },
    );
  } */
}
