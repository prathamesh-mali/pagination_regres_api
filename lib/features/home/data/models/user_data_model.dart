class UserDataModel {
  int? page;
  int? perPage;
  int? total;
  int? totalPages;
  List<UserData>? data;
  Support? support;
  Meta? meta;

  UserDataModel({
    this.page,
    this.perPage,
    this.total,
    this.totalPages,
    this.data,
    this.support,
    this.meta,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
    page: json["page"],
    perPage: json["per_page"],
    total: json["total"],
    totalPages: json["total_pages"],
    data: json["data"] == null
        ? []
        : List<UserData>.from(json["data"]!.map((x) => UserData.fromJson(x))),
    support: json["support"] == null ? null : Support.fromJson(json["support"]),
    meta: json["_meta"] == null ? null : Meta.fromJson(json["_meta"]),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "per_page": perPage,
    "total": total,
    "total_pages": totalPages,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "support": support?.toJson(),
    "_meta": meta?.toJson(),
  };
}

class UserData {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;

  UserData({this.id, this.email, this.firstName, this.lastName, this.avatar});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "avatar": avatar,
  };
}

class Meta {
  String? poweredBy;
  String? upgradeUrl;
  String? docsUrl;
  String? templateGallery;
  String? message;
  List<String>? features;
  String? upgradeCta;

  Meta({
    this.poweredBy,
    this.upgradeUrl,
    this.docsUrl,
    this.templateGallery,
    this.message,
    this.features,
    this.upgradeCta,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    poweredBy: json["powered_by"],
    upgradeUrl: json["upgrade_url"],
    docsUrl: json["docs_url"],
    templateGallery: json["template_gallery"],
    message: json["message"],
    features: json["features"] == null
        ? []
        : List<String>.from(json["features"]!.map((x) => x)),
    upgradeCta: json["upgrade_cta"],
  );

  Map<String, dynamic> toJson() => {
    "powered_by": poweredBy,
    "upgrade_url": upgradeUrl,
    "docs_url": docsUrl,
    "template_gallery": templateGallery,
    "message": message,
    "features": features == null
        ? []
        : List<dynamic>.from(features!.map((x) => x)),
    "upgrade_cta": upgradeCta,
  };
}

class Support {
  String? url;
  String? text;

  Support({this.url, this.text});

  factory Support.fromJson(Map<String, dynamic> json) =>
      Support(url: json["url"], text: json["text"]);

  Map<String, dynamic> toJson() => {"url": url, "text": text};
}
