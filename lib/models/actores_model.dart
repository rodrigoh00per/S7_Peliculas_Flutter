class Cast {
  Cast();
  List<Actor> actores = new List();
  Cast.fromJSONlist(List<dynamic> jsonList) {
    if (jsonList == null) {
      return;
    } else {
      jsonList.forEach((item) {
        final _actor = Actor.fromJsonMap(item);

        this.actores.add(_actor);
      });
    }
  }
}

class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  Actor.fromJsonMap(Map<String, dynamic> json) {
    this.castId = json["cast_id"];
    this.character = json["character"];
    this.creditId = json["credit_id"];
    this.gender = json["gender"];
    this.id = json["id"];
    this.name = json["name"];
    this.order = json["order"];
    this.profilePath = json["profile_path"];
  }

  getPhoto() {
    if (this.profilePath == null) {
      return "data:image/png;base64,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";
    } else {
      return "https://image.tmdb.org/t/p/w500/${this.profilePath}";
    }
  }
}
