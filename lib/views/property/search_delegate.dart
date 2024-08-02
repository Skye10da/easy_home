import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_home/services/model/property_model.dart';
import 'package:easy_home/views/property/property_detail_view.dart';
import 'package:flutter/material.dart';

class PropertySearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('properties').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('No properties found.'));
        }

        List<PropertyModel> properties = snapshot.data!.docs.map((doc) {
          return PropertyModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        List<PropertyModel> filteredProperties = properties.where((property) {
          return property.title.toLowerCase().contains(query.toLowerCase());
        }).toList();

        if (filteredProperties.isEmpty) {
          return const Center(child: Text('No properties found.'));
        }

        return ListView.builder(
          itemCount: filteredProperties.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(filteredProperties[index].title),
              subtitle: Text('\$${filteredProperties[index].price}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PropertyDetailsPage(propertyId: filteredProperties[index].id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
