class Currency{
  String title;
  String code;
  String cb_price;
  String date;

  Currency({
    required this.title,
    required this.code,
    required this.cb_price,
    required this.date,
  });

  factory Currency.fromJson(Map<String,dynamic> json){
    return Currency(
      title: json['title'] ?? "No title" ,
      code: json['code'] ?? "No code",
      cb_price: json['cb_price'] ?? "No price",
      date: json['date'] ?? "No date",
    );
  }

}
