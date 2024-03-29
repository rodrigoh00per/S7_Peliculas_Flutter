import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:s7_peliculas/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          this.peliculas[index].idTarjeta =
              "${this.peliculas[index].id}-Swiper";
          return Hero(
            tag: peliculas[index].idTarjeta,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "peliculaDetalle",
                        arguments: <String, dynamic>{
                          "pelicula": peliculas[index]
                        });
                  },
                  child: FadeInImage(
                    image: NetworkImage(this.peliculas[index].getImage()),
                    placeholder: AssetImage("assets/img/no-image.jpg"),
                    fit: BoxFit.cover,
                  ),
                )),
          );
        },
        itemCount: this.peliculas.length,

        /* pagination: new SwiperPagination(),
        control: new SwiperControl(), */
      ),
    );
  }
}
