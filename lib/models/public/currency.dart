class Currency {
  int? id;
  int? countryId;
  String? name;
  String? code;
  String? symbol;
  int? decimalDigits;
  String? decimalSeparator;
  String? thousandsSeparator;
  int? rounding;
  int? isActive;
  String? description;
  double? valueAgainstEuro;
  String? label;

  Currency({
    this.id,
    this.countryId,
    this.name,
    this.code,
    this.symbol,
    this.decimalDigits,
    this.decimalSeparator,
    this.thousandsSeparator,
    this.rounding,
    this.isActive,
    this.description,
    this.valueAgainstEuro,
    this.label,
  });

  Currency.fromJson(json) {
    id = json['id'];
    countryId = json['country_id'];
    name = json['name'];
    code = json['code'];
    symbol = json['symbol'];
    decimalDigits = json['decimal_digits'];
    decimalSeparator = json['decimal_separator'];
    thousandsSeparator = json['thousands_separator'];
    rounding = json['rounding'];
    isActive = json['is_active'];
    description = json['description'];
    valueAgainstEuro = json['value_against_euro'] == null ? null : double.parse('${json['value_against_euro']}');
    label = '${json['name']} (${json['code']})';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['country_id'] = countryId;
    map['name'] = name;
    map['code'] = code;
    map['symbol'] = symbol;
    map['decimal_digits'] = decimalDigits;
    map['decimal_separator'] = decimalSeparator;
    map['thousands_separator'] = thousandsSeparator;
    map['rounding'] = rounding;
    map['is_active'] = isActive;
    map['description'] = description;
    map['value_against_euro'] = valueAgainstEuro;
    map['label'] = label;
    return map;
  }
}
