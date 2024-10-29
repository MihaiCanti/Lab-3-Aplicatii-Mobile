import 'package:flutter/material.dart';

class Barbershop {
  final String name;
  final String address;

  Barbershop({required this.name, required this.address});
}

class BarbershopList extends StatelessWidget {
  final List<Barbershop> barbershops = [
    Barbershop(name: 'Barbershop 1', address: 'Adresa 1'),
    Barbershop(name: 'Barbershop 2', address: 'Adresa 2'),
    Barbershop(name: 'Barbershop 3', address: 'Adresa 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: barbershops.length,
      itemBuilder: (context, index) {
        final barbershop = barbershops[index];
        return ListTile(
          title: Text(barbershop.name),
          subtitle: Text(barbershop.address),
          trailing: ElevatedButton(
            onPressed: () {
              // Logica de rezervare (încă neimplementată)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Rezervare pentru ${barbershop.name}')),
              );
            },
            child: Text('Rezervare'),
          ),
        );
      },
    );
  }
}
