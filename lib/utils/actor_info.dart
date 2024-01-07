class ActorInfo {
  String? birthDate;
  List<Filmography>? filmography;
  HeadShotImage? headShotImage;
  String? name;

  ActorInfo({this.birthDate, this.filmography, this.headShotImage, this.name});

  ActorInfo.fromJson(Map<String, dynamic> json) {
    birthDate = json['birthDate'];
    if (json['filmography'] != null) {
      filmography = <Filmography>[];
      json['filmography'].forEach((v) {
        filmography!.add(new Filmography.fromJson(v));
      });
    }
    headShotImage = json['headShotImage'] != null
        ? new HeadShotImage.fromJson(json['headShotImage'])
        : null;
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['birthDate'] = this.birthDate;
    if (this.filmography != null) {
      data['filmography'] = this.filmography!.map((v) => v.toJson()).toList();
    }
    if (this.headShotImage != null) {
      data['headShotImage'] = this.headShotImage!.toJson();
    }
    data['name'] = this.name;
    return data;
  }
}

class Filmography {
  String? emsId;
  String? emsVersionId;
  String? name;
  PosterImage? posterImage;
  String? releaseDate;
  TomatoRating? tomatoRating;
  UserRating? userRating;

  Filmography(
      {this.emsId,
      this.emsVersionId,
      this.name,
      this.posterImage,
      this.releaseDate,
      this.tomatoRating,
      this.userRating});

  Filmography.fromJson(Map<String, dynamic> json) {
    emsId = json['emsId'];
    emsVersionId = json['emsVersionId'];
    name = json['name'];
    posterImage = json['posterImage'] != null
        ? new PosterImage.fromJson(json['posterImage'])
        : null;
    releaseDate = json['releaseDate'];
    tomatoRating = json['tomatoRating'] != null
        ? new TomatoRating.fromJson(json['tomatoRating'])
        : null;
    userRating = json['userRating'] != null
        ? new UserRating.fromJson(json['userRating'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emsId'] = this.emsId;
    data['emsVersionId'] = this.emsVersionId;
    data['name'] = this.name;
    if (this.posterImage != null) {
      data['posterImage'] = this.posterImage!.toJson();
    }
    data['releaseDate'] = this.releaseDate;
    if (this.tomatoRating != null) {
      data['tomatoRating'] = this.tomatoRating!.toJson();
    }
    if (this.userRating != null) {
      data['userRating'] = this.userRating!.toJson();
    }
    return data;
  }
}

class PosterImage {
  Null? height;
  Null? type;
  String? url;
  Null? width;

  PosterImage({this.height, this.type, this.url, this.width});

  PosterImage.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    type = json['type'];
    url = json['url'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['type'] = this.type;
    data['url'] = this.url;
    data['width'] = this.width;
    return data;
  }
}

class TomatoRating {
  IconImage? iconImage;
  int? tomatometer;

  TomatoRating({this.iconImage, this.tomatometer});

  TomatoRating.fromJson(Map<String, dynamic> json) {
    iconImage = json['iconImage'] != null
        ? new IconImage.fromJson(json['iconImage'])
        : null;
    tomatometer = json['tomatometer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.iconImage != null) {
      data['iconImage'] = this.iconImage!.toJson();
    }
    data['tomatometer'] = this.tomatometer;
    return data;
  }
}

class IconImage {
  String? url;

  IconImage({this.url});

  IconImage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}

class UserRating {
  int? dtlLikedScore;
  int? dtlScoreCount;
  int? dtlWtsCount;
  Null? dtlWtsScore;
  IconImage? iconImage;

  UserRating(
      {this.dtlLikedScore,
      this.dtlScoreCount,
      this.dtlWtsCount,
      this.dtlWtsScore,
      this.iconImage});

  UserRating.fromJson(Map<String, dynamic> json) {
    dtlLikedScore = json['dtlLikedScore'];
    dtlScoreCount = json['dtlScoreCount'];
    dtlWtsCount = json['dtlWtsCount'];
    dtlWtsScore = json['dtlWtsScore'];
    iconImage = json['iconImage'] != null
        ? new IconImage.fromJson(json['iconImage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dtlLikedScore'] = this.dtlLikedScore;
    data['dtlScoreCount'] = this.dtlScoreCount;
    data['dtlWtsCount'] = this.dtlWtsCount;
    data['dtlWtsScore'] = this.dtlWtsScore;
    if (this.iconImage != null) {
      data['iconImage'] = this.iconImage!.toJson();
    }
    return data;
  }
}

class HeadShotImage {
  int? height;
  String? type;
  String? url;
  int? width;

  HeadShotImage({this.height, this.type, this.url, this.width});

  HeadShotImage.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    type = json['type'];
    url = json['url'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['type'] = this.type;
    data['url'] = this.url;
    data['width'] = this.width;
    return data;
  }
}
