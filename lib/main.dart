import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BarberShopPage(),
    );
  }
}

class BarberShopPage extends StatefulWidget {
  @override
  _BarberShopPageState createState() => _BarberShopPageState();
}

class _BarberShopPageState extends State<BarberShopPage> {
  Map<String, dynamic> jsonData = {};
  bool showAllNearestBarbershops = false; // variabilă de stare pentru afișarea completă

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Încarcă fișierul JSON
    final String response = await rootBundle.loadString('lib/data.json');
    final data = await json.decode(response);
    setState(() {
      jsonData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (jsonData.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Barber Shop | Cantievschii Mihai'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Extragem datele din JSON
    var bannerData = jsonData['banner'];
    var nearestBarbershop = jsonData['nearest_barbershop'];
    var mostRecommended = jsonData['most_recommended'];

    // Limităm lista doar la primele 3 barbershop-uri dacă nu e selectat "Show all"
    var visibleNearestBarbershops = showAllNearestBarbershops
        ? nearestBarbershop
        : nearestBarbershop.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Barber Shop | Cantievschii Mihai'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          // Profil utilizator
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('lib/imagini/profile.png'),
            ),
            title: Text('Michael Bay'),
            subtitle: Text('Expert'),
          ),
          // Secțiunea bannerului promoțional din JSON
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      bannerData['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {}, // Fără acțiune la apăsare
                      child: Text(bannerData['button_title']),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Secțiunea pentru barbershop-urile cele mai apropiate
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Nearest Barbershop',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Afișăm doar primele 3 sau toate în funcție de starea butonului
          for (var shop in visibleNearestBarbershops)
            BarberShopCard(
              shop['name'],
              shop['location_with_distance'],
              shop['review_rate'],
              shop['image'],
            ),
          // Buton "Show all" / "Show less" pentru afișarea/restrângerea frizeriilor
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  showAllNearestBarbershops = !showAllNearestBarbershops; // Alternăm între afișare și restrângere
                });
              },
              child: Text(showAllNearestBarbershops ? 'Show less' : 'Show all'),
            ),
          ),
          // Secțiunea pentru cele mai recomandate barbershop-uri
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Most Recommended',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          for (var shop in mostRecommended)
            BarberShopCard(
              shop['name'],
              shop['location_with_distance'],
              shop['review_rate'],
              shop['image'],
            ),
        ],
      ),
    );
  }
}

// Widget pentru afișarea frizeriilor
class BarberShopCard extends StatelessWidget {
  final String name;
  final String location;
  final double rating;
  final String imageUrl;

  BarberShopCard(this.name, this.location, this.rating, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(name),
        subtitle: Text(location),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.yellow[700]),
            Text(rating.toString()),
          ],
        ),
      ),
    );
  }
}
