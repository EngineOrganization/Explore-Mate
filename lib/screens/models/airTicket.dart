class AirTicker {
  double total_amount;
  String total_currency;
  String id;
  Slices slices;
  AirTicker(this.total_amount, this.total_currency, this.id, this.slices);
}


class Owner {
  String iata_code;
  String id;
  String logo_symbol_url;
  String name;
  Owner(this.iata_code, this.id, this.logo_symbol_url, this.name);
}


class Slices {
  List<Slice> slices;
  Slices(this.slices);
}


class Slice {
  OriginSlice originSlice;
  DestinationSlice destinationSlice;
  Segments segments;
  Slice(this.originSlice, this.destinationSlice, this.segments);
}


class OriginSlice {
  String city_name;
  String iata_city_code;
  String iata_country_code;
  String id;
  String name;
  String type;
  OriginSlice(this.city_name, this.iata_city_code, this.iata_country_code, this.id, this.name, this.type);
}


class DestinationSlice {
  String city_name;
  String iata_city_code;
  String iata_country_code;
  String id;
  String name;
  String type;
  DestinationSlice(this.city_name, this.iata_city_code, this.iata_country_code, this.id, this.name, this.type);
}


class Segments {
  List<Segment> segments;
  Segments(this.segments);
}


class Segment {
  String arriving_at;
  String departing_at;
  String id;
  Aircraft aircraft;
  OriginSegment originSegment;
  DestinationSegment destinationSegment;
  Segment(this.arriving_at, this.departing_at, this.id, this.aircraft, this.originSegment, this.destinationSegment);
}


class Aircraft {
  String iata_code;
  String id;
  String name;
  Aircraft(this.iata_code, this.id, this.name);
}


class OriginSegment {
  String iata_code;
  String iata_country_code;
  String id;
  String latitude;
  String longitude;
  String name;
  String time_zone;
  OriginSegment(this.iata_code, this.iata_country_code, this.id, this.latitude, this.longitude, this.name, this.time_zone);
}


class DestinationSegment {
  String iata_code;
  String iata_country_code;
  String id;
  String latitude;
  String longitude;
  String name;
  String time_zone;
  DestinationSegment(this.iata_code, this.iata_country_code, this.id, this.latitude, this.longitude, this.name, this.time_zone);
}