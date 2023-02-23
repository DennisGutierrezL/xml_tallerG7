import 'dart:core';

class MentalGames {
  String _module, _description, _image;

  MentalGames(this._module, this._description, this._image);

  static MentalGames? fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    } else {
      return MentalGames(json["module"], json["description"], json["image"]);
    }
  }

  get module => this._module;
  get description => this._description;
  get image => this._image;
}
