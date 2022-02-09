import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MaterialApp(home: Calc()));

class Calc extends StatefulWidget {
  const Calc({Key? key}) : super(key: key);

  @override
  _CalcState createState() => _CalcState();
}

class _CalcState extends State<Calc> {
  double ergebnis = 0,
      fix = 0,
      variabel = 0,
      gesamtpreis = 0,
      verkaufspreis = 0,
      versandkosten = 0;

  final TextEditingController first = TextEditingController(text: "");
  final TextEditingController second = TextEditingController(text: "");

  bool checkNumbers() {
    try {
      verkaufspreis = double.parse(first.text.replaceAll(",", "."));
      versandkosten = double.parse(second.text.replaceAll(",", "."));
      return true;
    } on FormatException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ungültige Eingabe'),
        ),
      );
      setState(() {
        ergebnis = 0;
      });
      return false;
    }
  }

  void calculation() {
    if (checkNumbers()) {
      setState(() {
        gesamtpreis = verkaufspreis + versandkosten;
        if (gesamtpreis <= 1990) {
          variabel = gesamtpreis * (11 / 100);
        } else {
          variabel = gesamtpreis * (2 / 100);
        }
        if (gesamtpreis < 10) {
          fix = 0.05;
        } else {
          fix = 0.35;
        }
        ergebnis =
            double.parse((gesamtpreis - variabel - fix).toStringAsFixed(2));
      });
    }
  }

  void calculationminus() {
    if (checkNumbers()) {
      setState(() {
        gesamtpreis = verkaufspreis + versandkosten;
        if (gesamtpreis <= 1990) {
          variabel = gesamtpreis * (11 / 100);
        } else {
          variabel = gesamtpreis * (2 / 100);
        }
        if (gesamtpreis < 10) {
          fix = 0.05;
        } else {
          fix = 0.35;
        }
        ergebnis = double.parse(
            (gesamtpreis - variabel - fix - versandkosten).toStringAsFixed(2));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verkaufsgebühren - Rechner'),
        ),
        body: Center(
            child: ListView(padding: const EdgeInsets.all(8), children: [
          const SizedBox(height: 30),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Verkaufspreis in €'),
            controller: first,
          ),
          const SizedBox(height: 15),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Versandkosten in €'),
            controller: second,
          ),
          const SizedBox(height: 30),
          ElevatedButton(onPressed: calculation, child: const Text("Berechne")),
          const SizedBox(height: 15),
          ElevatedButton(
              onPressed: calculationminus,
              child: const Text("Berechne mit abgezogenen Versandkosten")),
          const SizedBox(height: 30),
          Text(
            "Sie erhalten: $ergebnis €",
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          const Card(
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text('Disclaimer'),
              subtitle: Text(
                  'Diese App dient nur zu Informationszwecken. Wir garantieren nicht die Genauigkeit der Angaben. "Verkaufsgebühren - Rechner" wird in keiner Weise von eBay unterstützt, sondern von einem unabhängigen Entwickler gepflegt.'),
            ),
          ),
          Card(
              elevation: 3,
              child: ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Weitere Informationen'),
                  subtitle: const Text(
                      'Diese App ist nur für Personen entwickelt, die die neue Zahlungsabwicklung von eBay nutzen. Weitere Informationen zur Berechnung der Gebühren finden Sie im Kundenservice-Portal von eBay. Tippe auf diese Kachel um zu dieser Website zu gelangen.'),
                  onTap: () => launch(
                      'https://www.ebay.de/help/selling/fees-credits-invoices/gebhren-fr-private-verkufer?id=4822')))
        ])));
  }
}
