import 'package:flutter/material.dart';
import 'package:s7_peliculas/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function
      siguientePagina; //se define para poder acceder a la funcion que esta en el provider
  //aparte estya funcion es la hija del home page

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController =
      PageController(initialPage: 1, viewportFraction: 0.30);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    this._pageController.addListener(() {
      if (this._pageController.position.pixels >=
          this._pageController.position.maxScrollExtent - 200) {
        print("ejecute la siguiente pagina");
        this.siguientePagina();
      }
    });

    return Container(
      height: screenSize.height * 0.25,
      child: PageView.builder(
        itemCount: this.peliculas.length,
        pageSnapping: false,
        controller: this._pageController,
        itemBuilder: (context, i) {
          return this._tarjeta(context, this.peliculas[i]);
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    pelicula.idTarjeta = "${pelicula.id}-Tarjetita";
    final _tarjeta = Container(
      child: Column(
        children: <Widget>[
          Hero(
            tag: pelicula.idTarjeta,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                fit: BoxFit.cover,
                height: 160.0,
                placeholder: AssetImage("assets/img/no-image.jpg"),
                image: NetworkImage(pelicula.getImage()),
              ),
            ),
          ),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      child: _tarjeta,
      onTap: () {
        Navigator.pushNamed(context, "peliculaDetalle",
            arguments: <String, dynamic>{
              "pelicula": pelicula,
              "valor_prueba": "1"
            });
      },
    );
  }

  /* List<Widget> _mostrarTarjetas(BuildContext context) {
    return this.peliculas.map((pelicula) {
      return Container(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                fit: BoxFit.cover,
                height: 160.0,
                placeholder: AssetImage("assets/img/no-image.jpg"),
                image: NetworkImage(pelicula.getImage()),
              ),
            ),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  } */
}
