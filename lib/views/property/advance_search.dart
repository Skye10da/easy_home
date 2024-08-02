import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_home/utilities/ui/multi_select_chip.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdvancedSearchPage extends StatefulWidget {
  const AdvancedSearchPage({super.key});

  @override
  AdvancedSearchPageState createState() => AdvancedSearchPageState();
}

class AdvancedSearchPageState extends State<AdvancedSearchPage> {
  final _formKey = GlobalKey<FormState>();

  // final TextEditingController _titleController = TextEditingController();
  String? selectedType;
  RangeValues _priceRange = const RangeValues(0, 1000000);
  bool _isFurnished = false;
  List<String> selectedAmenities = [];
  List<String> selectedUtilities = [];
  List<String> propertyTypes = ['Apartment', 'House', 'Condo', 'Land'];
  List<String> amenities = [
    'Pool',
    'Gym',
    'Garden',
    'Parking',
    'Elevator',
    'Security'
  ];
  List<String> utilities = ['Water', 'Electricity', 'Internet', 'Gas'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
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
                items:
                    propertyTypes.map<DropdownMenuItem<String>>((String value) {
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              const SizedBox(height: 16.0),

              // Search Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _performSearch();
                  }
                },
                child: const Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch() {
    // Perform search logic here
    // Use the selected values to query the database
    if (kDebugMode) {
      print('Selected Type: $selectedType');
      print('Price Range: ${_priceRange.start} - ${_priceRange.end}');
      print('Is Furnished: $_isFurnished');
      print('Selected Amenities: $selectedAmenities');
      print('Selected Utilities: $selectedUtilities');
    }

    // Example Firestore query (adjust based on your schema)
    FirebaseFirestore.instance
        .collection('properties')
        .where('type', isEqualTo: selectedType)
        .where('price', isGreaterThanOrEqualTo: _priceRange.start)
        .where('price', isLessThanOrEqualTo: _priceRange.end)
        .where('isFurnished', isEqualTo: _isFurnished)
        .where('amenities', arrayContainsAny: selectedAmenities)
        .where('utilities', arrayContainsAny: selectedUtilities)
        .get()
        .then((QuerySnapshot querySnapshot) {
      // Handle search results
      for (var doc in querySnapshot.docs) {
        if (kDebugMode) {
          print(doc.data());
        }
      }
    });
  }
}
