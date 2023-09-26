import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constant/constatnt.dart';

class PlaceSearchExample extends StatefulWidget {
  @override
  _PlaceSearchExampleState createState() => _PlaceSearchExampleState();
}

class _PlaceSearchExampleState extends State<PlaceSearchExample> {
  final TextEditingController _searchController = TextEditingController();
  List _suggestions = [];

  Future<void> _searchPlaces(String query) async {
    final apikey = apiKey;
    final baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    final response = await http
        .get(Uri.parse('$baseUrl?input=$query&key=$apikey&type=(cities)'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['predictions'];
      setState(() {
        _suggestions = predictions.map((prediction) {
          return prediction['description'];
        }).toList();
      });
    } else {
      // Handle the error here.
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Search for a place',
        ),
        onChanged: (value) {
          _suggestions.clear();
          final query = value.trim();
          if (query.isNotEmpty) {
            _searchPlaces(query);
          }
        },
      ),
      content: Container(
        height: 300,
        width: double.maxFinite,
        child: _suggestions.isEmpty
            ? Center(
                child: Text(
                  'Search a place',
                  style: TextStyle(color: Colors.black),
                ),
              )
            : ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    onTap: () async {
                      final selectedLocation = _suggestions[index];
                      final locationDetails =
                          await _getLocationDetails(selectedLocation);

                      if (locationDetails.isNotEmpty) {
                        Navigator.pop(context, {
                          'locationName': selectedLocation,
                          'latitude': locationDetails['latitude'],
                          'longitude': locationDetails['longitude'],
                        });
                      } else {
                        // Handle error
                      }
                    },
                  );
                },
              ),
      ),
    );
  }

  Future<Map<String, double>> _getLocationDetails(
      String selectedAddress) async {
    final apikey = apiKey;
    final baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';

    final response = await http.get(
      Uri.parse('$baseUrl?address=$selectedAddress&key=$apikey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        final latitude = location['lat'];
        final longitude = location['lng'];

        return {
          'latitude': latitude,
          'longitude': longitude,
        };
      }
    }

    return {};
  }
}
