class Currency {
  int? id;
  String? name;
  String? code;
  String? symbol;
  double? valueAgainstEuro;
  String? label;

  Currency({
    this.id,
    this.name,
    this.code,
    this.symbol,
    this.valueAgainstEuro,
    this.label,
  });

  Currency.fromJson(json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    symbol = json['symbol'];
    valueAgainstEuro = json['value_against_euro'] == null ? null : double.parse('${json['value_against_euro']}');
    label = '${json['name']} (${json['code']})';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    map['symbol'] = symbol;
    map['value_against_euro'] = valueAgainstEuro;
    map['label'] = label;
    return map;
  }
}
