import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_home/services/model/property_model.dart';
import 'package:easy_home/utilities/ui/multi_select_chip.dart';
import 'package:easy_home/views/property/property_detail_view.dart';
import 'package:flutter/material.dart';

class AdvancedSearchPage extends StatefulWidget {
  const AdvancedSearchPage({super.key});

  @override
  AdvancedSearchPageState createState() => AdvancedSearchPageState();
}

class AdvancedSearchPageState extends State<AdvancedSearchPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  String? selectedType;
  RangeValues _priceRange = const RangeValues(0, 1000000);
  bool _isFurnished = false;
  List<String> selectedAmenities = [""];
  List<String> selectedUtilities = [""];
  List<String> propertyTypes = ['Apartment', 'House', 'Condo', 'Land'];
  List<String> amenities = [
    'Pool',
    'Gym',
    'Garden',
    'Parking',
    'Elevator',
    'Security'
  ];
  List<String> utilities = [
    'Water',
    'Electricity',
    'Internet',
    'Gas',
  ];
  bool _isExpanded = false;

  Future<List<PropertyModel>> performSearch() async {
    try {
      // Initialize Firestore query for `arrayContains`
      Query query1 = FirebaseFirestore.instance
          .collection('properties')
          .where('title', isEqualTo: _searchController.text)
          .where('type', isEqualTo: selectedType)
          .where('price', isGreaterThanOrEqualTo: _priceRange.start)
          .where('price', isLessThanOrEqualTo: _priceRange.end)
          .where('isFurnished', isEqualTo: _isFurnished);

      // Initialize Firestore query for `arrayContainsAny`
      Query query2 = FirebaseFirestore.instance
          .collection('properties')
          .where('title', isEqualTo: _searchController.text)
          .where('type', isEqualTo: selectedType)
          .where('price', isGreaterThanOrEqualTo: _priceRange.start)
          .where('price', isLessThanOrEqualTo: _priceRange.end)
          .where('isFurnished', isEqualTo: _isFurnished);

      // Apply arrayContains to query1
      if (selectedUtilities.isNotEmpty) {
        query1 = query1.where('utilities', arrayContainsAny: selectedUtilities);
      }

      // Apply arrayContainsAny to query2
      if (selectedAmenities.isNotEmpty) {
        query2 = query2.where('amenities', arrayContainsAny: selectedAmenities);
      }

      // Fetch results from both queries
      QuerySnapshot querySnapshot1 = await query1.get();
      QuerySnapshot querySnapshot2 = await query2.get();

      // Convert results to PropertyModel lists
      List<PropertyModel> properties1 = querySnapshot1.docs.map((doc) {
        return PropertyModel.fromJson(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      List<PropertyModel> properties2 = querySnapshot2.docs.map((doc) {
        return PropertyModel.fromJson(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Combine the two lists, ensuring no duplicates
      Map<String, PropertyModel> combinedMap = {};
      for (var property in properties1) {
        combinedMap[property.id] = property;
      }
      for (var property in properties2) {
        combinedMap[property.id] = property;
      }

      return combinedMap.values.toList();
    } catch (e) {
      // Handle errors appropriately (e.g., logging, showing a message)
      print("Error during search: $e");
      return [];
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Search Input Field
              Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your search query';
                    }
                    return null;
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    hintText: 'Enter search terms',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Advanced Search Options
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isExpanded = isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return const ListTile(
                        title: Text('Advanced Search Options'),
                      );
                    },
                    body: Column(
                      children: [
                        // Property Type Dropdown
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Property Type',
                            border: OutlineInputBorder(),
                          ),
                          value: selectedType,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedType = newValue;
                            });
                          },
                          items: propertyTypes
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16.0),

                        // Price Range Slider
                        const Text(
                          'Price Range',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        RangeSlider(
                          values: _priceRange,
                          min: 0,
                          max: 2000000,
                          divisions: 40,
                          labels: RangeLabels(
                            '\$${_priceRange.start.round()}',
                            '\$${_priceRange.end.round()}',
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _priceRange = values;
                            });
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Furnished Checkbox
                        CheckboxListTile(
                          title: const Text('Furnished'),
                          value: _isFurnished,
                          onChanged: (bool? value) {
                            setState(() {
                              _isFurnished = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 16.0),

                        // Amenities MultiSelectChip
                        const Text(
                          'Amenities',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        MultiSelectChip(
                          options: amenities,
                          selectedOptions: selectedAmenities,
                          onSelectionChanged: (selectedList) {
                            setState(() {
                              selectedAmenities = selectedList;
                            });
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Utilities MultiSelectChip
                        const Text(
                          'Utilities',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        MultiSelectChip(
                          options: utilities,
                          selectedOptions: selectedUtilities,
                          onSelectionChanged: (selectedList) {
                            setState(() {
                              selectedUtilities = selectedList;
                            });
                          },
                        ),
                      ],
                    ),
                    isExpanded: _isExpanded,
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              // Search Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    performSearch();
                  }
                },
                child: const Text('Search'),
              ),
              const SizedBox(
                height: 16,
              ),
              FutureBuilder(
                future: performSearch(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var properties = snapshot.data;
                    print(properties);
                    if (properties!.isEmpty) {
                      return const Center(child: Text('No properties found.'));
                    }
                    return ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(properties[index].title),
                          subtitle: Text('\$${properties[index].price}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PropertyDetailsPage(
                                    propertyId: properties[index].id),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return const Text(
                      "Search results",
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
