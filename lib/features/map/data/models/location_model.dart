import 'dart:developer';

class LocationModel {
  Response? response;

  LocationModel({this.response});

  LocationModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null ? Response.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class Response {
  GeoObjectCollection? geoObjectCollection;

  Response({this.geoObjectCollection});

  Response.fromJson(Map<String, dynamic> json) {
    geoObjectCollection =
        json['GeoObjectCollection'] != null ? GeoObjectCollection.fromJson(json['GeoObjectCollection']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (geoObjectCollection != null) {
      data['GeoObjectCollection'] = geoObjectCollection!.toJson();
    }
    return data;
  }
}

class GeoObjectCollection {
  MetaDataProperty? metaDataProperty;
  List<FeatureMember>? featureMember;

  GeoObjectCollection({this.metaDataProperty, this.featureMember});

  GeoObjectCollection.fromJson(Map<String, dynamic> json) {
    metaDataProperty = json['metaDataProperty'] != null ? MetaDataProperty.fromJson(json['metaDataProperty']) : null;
    if (json['featureMember'] != null) {
      featureMember = <FeatureMember>[];
      json['featureMember'].forEach((v) {
        featureMember!.add(FeatureMember.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (metaDataProperty != null) {
      data['metaDataProperty'] = metaDataProperty!.toJson();
    }
    if (featureMember != null) {
      data['featureMember'] = featureMember!.map((v) => v.toJson()).toList();
    }
    log('data: $data');

    return data;
  }
}

// class MetaDataProperty {
//   GeocoderResponseMetaData? geocoderResponseMetaData;

//   MetaDataProperty({this.geocoderResponseMetaData});

//   MetaDataProperty.fromJson(Map<String, dynamic> json) {
//     geocoderResponseMetaData = json['GeocoderResponseMetaData'] != null
//         ? GeocoderResponseMetaData.fromJson(json['GeocoderResponseMetaData'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (geocoderResponseMetaData != null) {
//       data['GeocoderResponseMetaData'] = geocoderResponseMetaData!.toJson();
//     }
//     return data;
//   }
// }

class GeocoderResponseMetaData {
  Points? point;
  String? request;
  String? results;
  String? found;

  GeocoderResponseMetaData({this.point, this.request, this.results, this.found});

  GeocoderResponseMetaData.fromJson(Map<String, dynamic> json) {
    point = json['Point'] != null ? Points.fromJson(json['Point']) : null;
    request = json['request'];
    results = json['results'];
    found = json['found'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (point != null) {
      data['Point'] = point!.toJson();
    }
    data['request'] = request;
    data['results'] = results;
    data['found'] = found;
    return data;
  }
}

class Points {
  String? pos;

  Points({this.pos});

  Points.fromJson(Map<String, dynamic> json) {
    pos = json['pos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pos'] = pos;
    return data;
  }
}

class FeatureMember {
  GeoObject? geoObject;

  FeatureMember({this.geoObject});

  FeatureMember.fromJson(Map<String, dynamic> json) {
    geoObject = json['GeoObject'] != null ? GeoObject.fromJson(json['GeoObject']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (geoObject != null) {
      data['GeoObject'] = geoObject!.toJson();
    }
    return data;
  }
}

class GeoObject {
  MetaDataProperty? metaDataProperty;
  String? name;
  String? description;
  BoundedBy? boundedBy;
  String? uri;
  Points? point;

  GeoObject({this.metaDataProperty, this.name, this.description, this.boundedBy, this.uri, this.point});

  GeoObject.fromJson(Map<String, dynamic> json) {
    metaDataProperty = json['metaDataProperty'] != null ? MetaDataProperty.fromJson(json['metaDataProperty']) : null;
    name = json['name'];
    description = json['description'];
    boundedBy = json['boundedBy'] != null ? BoundedBy.fromJson(json['boundedBy']) : null;
    uri = json['uri'];
    point = json['Point'] != null ? Points.fromJson(json['Point']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (metaDataProperty != null) {
      data['metaDataProperty'] = metaDataProperty!.toJson();
    }
    data['name'] = name;
    data['description'] = description;
    if (boundedBy != null) {
      data['boundedBy'] = boundedBy!.toJson();
    }
    data['uri'] = uri;
    if (point != null) {
      data['Point'] = point!.toJson();
    }
    return data;
  }
}

class MetaDataProperty {
  GeocoderMetaData? geocoderMetaData;

  MetaDataProperty({this.geocoderMetaData});

  MetaDataProperty.fromJson(Map<String, dynamic> json) {
    geocoderMetaData = json['GeocoderMetaData'] != null ? GeocoderMetaData.fromJson(json['GeocoderMetaData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (geocoderMetaData != null) {
      data['GeocoderMetaData'] = geocoderMetaData!.toJson();
    }
    return data;
  }
}

class GeocoderMetaData {
  String? precision;
  String? text;
  String? kind;
  Address? address;
  AddressDetails? addressDetails;

  GeocoderMetaData({this.precision, this.text, this.kind, this.address, this.addressDetails});

  GeocoderMetaData.fromJson(Map<String, dynamic> json) {
    precision = json['precision'];
    text = json['text'];
    kind = json['kind'];
    address = json['Address'] != null ? Address.fromJson(json['Address']) : null;
    addressDetails = json['AddressDetails'] != null ? AddressDetails.fromJson(json['AddressDetails']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['precision'] = precision;
    data['text'] = text;
    data['kind'] = kind;
    if (address != null) {
      data['Address'] = address!.toJson();
    }
    if (addressDetails != null) {
      data['AddressDetails'] = addressDetails!.toJson();
    }
    return data;
  }
}

class Address {
  String? countryCode;
  String? formatted;
  List<Components>? components;

  Address({this.countryCode, this.formatted, this.components});

  Address.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    formatted = json['formatted'];
    if (json['Components'] != null) {
      components = <Components>[];
      json['Components'].forEach((v) {
        components!.add(Components.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_code'] = countryCode;
    data['formatted'] = formatted;
    if (components != null) {
      data['Components'] = components!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Components {
  String? kind;
  String? name;

  Components({this.kind, this.name});

  Components.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kind'] = kind;
    data['name'] = name;
    return data;
  }
}

class AddressDetails {
  Country? country;

  AddressDetails({this.country});

  AddressDetails.fromJson(Map<String, dynamic> json) {
    country = json['Country'] != null ? Country.fromJson(json['Country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (country != null) {
      data['Country'] = country!.toJson();
    }
    return data;
  }
}

class Country {
  String? addressLine;
  String? countryNameCode;
  String? countryName;
  AdministrativeArea? administrativeArea;

  Country({this.addressLine, this.countryNameCode, this.countryName, this.administrativeArea});

  Country.fromJson(Map<String, dynamic> json) {
    addressLine = json['AddressLine'];
    countryNameCode = json['CountryNameCode'];
    countryName = json['CountryName'];
    administrativeArea =
        json['AdministrativeArea'] != null ? AdministrativeArea.fromJson(json['AdministrativeArea']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AddressLine'] = addressLine;
    data['CountryNameCode'] = countryNameCode;
    data['CountryName'] = countryName;
    if (administrativeArea != null) {
      data['AdministrativeArea'] = administrativeArea!.toJson();
    }
    return data;
  }
}

class AdministrativeArea {
  String? administrativeAreaName;
  SubAdministrativeArea? subAdministrativeArea;

  AdministrativeArea({this.administrativeAreaName, this.subAdministrativeArea});

  AdministrativeArea.fromJson(Map<String, dynamic> json) {
    administrativeAreaName = json['AdministrativeAreaName'];
    subAdministrativeArea =
        json['SubAdministrativeArea'] != null ? SubAdministrativeArea.fromJson(json['SubAdministrativeArea']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AdministrativeAreaName'] = administrativeAreaName;
    if (subAdministrativeArea != null) {
      data['SubAdministrativeArea'] = subAdministrativeArea!.toJson();
    }
    return data;
  }
}

class SubAdministrativeArea {
  String? subAdministrativeAreaName;
  Locality? locality;

  SubAdministrativeArea({this.subAdministrativeAreaName, this.locality});

  SubAdministrativeArea.fromJson(Map<String, dynamic> json) {
    subAdministrativeAreaName = json['SubAdministrativeAreaName'];
    locality = json['Locality'] != null ? Locality.fromJson(json['Locality']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SubAdministrativeAreaName'] = subAdministrativeAreaName;
    if (locality != null) {
      data['Locality'] = locality!.toJson();
    }
    return data;
  }
}

class Locality {
  Premise? premise;

  Locality({this.premise});

  Locality.fromJson(Map<String, dynamic> json) {
    premise = json['Premise'] != null ? Premise.fromJson(json['Premise']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (premise != null) {
      data['Premise'] = premise!.toJson();
    }
    return data;
  }
}

class Premise {
  String? premiseName;

  Premise({this.premiseName});

  Premise.fromJson(Map<String, dynamic> json) {
    premiseName = json['PremiseName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PremiseName'] = premiseName;
    return data;
  }
}

class BoundedBy {
  Envelope? envelope;

  BoundedBy({this.envelope});

  BoundedBy.fromJson(Map<String, dynamic> json) {
    envelope = json['Envelope'] != null ? Envelope.fromJson(json['Envelope']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (envelope != null) {
      data['Envelope'] = envelope!.toJson();
    }
    return data;
  }
}

class Envelope {
  String? lowerCorner;
  String? upperCorner;

  Envelope({this.lowerCorner, this.upperCorner});

  Envelope.fromJson(Map<String, dynamic> json) {
    lowerCorner = json['lowerCorner'];
    upperCorner = json['upperCorner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lowerCorner'] = lowerCorner;
    data['upperCorner'] = upperCorner;
    return data;
  }
}
