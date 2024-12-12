import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:future_builder_example/data/madels/Currency.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late Future<List<Currency>> _currenciesFuture;
  final Dio _dio = Dio();

  Future<List<Currency>> getCurrencyFromApi() async {
    var response = await _dio.get('https://nbu.uz/uz/exchange-rates/json/');
    List data = response.data;
    List<Currency> correncies = data
        .map((current_currency) => Currency.fromJson(current_currency))
        .toList();
    return correncies;
  }

  @override
  void initState() {
    super.initState();
    _currenciesFuture =
        getCurrencyFromApi(); // Future ni faqat bir marta o'rnatish
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text("Valyutalar kurslari",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
        elevation: 6,
        shadowColor: Colors.amber,
        shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: Colors.black,width: 1)
        ),
      ),
        body: SafeArea(
      child: FutureBuilder(
          future: _currenciesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final currency = snapshot.data![index];
                    return Card(
                      margin:const EdgeInsets.all(10),
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.black,
                      shape:const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ListTile(
                        title: Text(currency.title, style:const TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text('Valyuta kursi: ${currency.cb_price}', style:const TextStyle(fontWeight: FontWeight.w300),),
                        trailing: Text("${currency.code}", style:const TextStyle(fontWeight: FontWeight.w500,fontSize: 20)),
                        
                      ),
                    );
                  });
            }
            return const Text('No data available');
          }
          ),
    ));
  }
}
