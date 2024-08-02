// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker_2/country_state_city_picker.dart';
import 'package:easy_home/services/auth/auth_service.dart';
import 'package:easy_home/services/cloud/firestore_service.dart';
import 'package:easy_home/utilities/ui/flushbar_notifications.dart';
import 'package:easy_home/utilities/ui/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({super.key});

  @override
  AddPropertyPageState createState() => AddPropertyPageState();
}

class AddPropertyPageState extends State<AddPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _typeController = TextEditingController();
  String? country;
  String? state;
  String? city;
  final _ownerId = AuthService.firebase().currentUser!.id;
  final FirestoreService _firestoreService = FirestoreService.instance;

  final List<String> _amenities = [];
  final List<String> _utilities = [];
  List<String> propertyTypes = [
    'Apartment',
    'House',
    'Condo',
    'Land',
    'Self Contained',
    'Single room'
  ];
  String? selectedType;
  final List<String> _allAmenities = [
    'Pool',
    'Gym',
    'Parking',
    'WiFi',
    'Air Conditioning',
    'Heating',
    'Balcony',
    'Garden',
    'Elevator',
    'Security',
    'Laundry',
    'Fireplace',
    'Sauna',
    'Jacuzzi',
  ];

  final List<String> _allUtilities = [
    'Electricity',
    'Water',
    'Gas',
    'Internet',
    'Trash Collection',
    'Sewage',
    'Cable TV',
    'Telephone',
  ];

  bool _isLoading = false;
  String? _errorMessage;
  // String? _successMessage;

  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();

    setState(() {
      _images.addAll(pickedFiles);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Property'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(_titleController, 'Title', 'Enter title'),
                _buildTextField(
                    _descriptionController, 'Description', 'Enter description'),
                _buildTextField(_priceController, 'Price', 'Enter price',
                    isNumeric: true),
                SelectState(
                  selectedCityLabel: 'Select City',
                  selectedCountryLabel: 'Select Country',
                  selectedStateLabel: 'Select State',
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  dropdownColor: Colors.grey[200],
                  style: Theme.of(context).textTheme.titleMedium,
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  spacing: 10.0,
                  onCountryChanged: (value) {
                    setState(() {
                      country = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      state = value;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      city = value;
                    });
                  },
                ),
                _buildTextField(_addressController, 'Address', 'Enter address'),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Property Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
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
                _buildMultiSelectChips('Amenities', _allAmenities, _amenities),
                const SizedBox(height: 16.0),
                _buildMultiSelectChips('Utilities', _allUtilities, _utilities),
                const SizedBox(height: 16.0),
                const Text('Photos',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                _buildImagePicker(),
                const SizedBox(height: 16.0),
                const SizedBox(height: 16.0),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ButtonStyle(
                          elevation: const WidgetStatePropertyAll(5.0),
                          animationDuration: const Duration(seconds: 2),
                          enableFeedback: true,
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(
                              vertical: size.getWidthPx(10),
                              horizontal: size.getWidthPx(130),
                            ),
                          ),
                        ),
                        onPressed: _submitForm,
                        child: const Text('Add Property'),
                      ),
                const SizedBox(height: 26.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildMultiSelectChips(
      String label, List<String> options, List<String> selectedOptions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8.0,
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: selectedOptions.contains(option),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedOptions.add(option);
                  } else {
                    selectedOptions.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        Wrap(
          spacing: 8.0,
          children: _images.map((image) {
            return Stack(
              children: [
                Image.file(
                  File(image.path),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _images.remove(image);
                      });
                    },
                    child: const Icon(Icons.remove_circle, color: Colors.red),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        IconButton(
          icon: const Icon(Icons.add_a_photo),
          onPressed: _pickImages,
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<String> imageUrls =
          await _firestoreService.uploadImages(images: _images);

      Map<String, dynamic> propertyData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'address': _addressController.text,
        'location': {
          'country': country,
          'state': state,
          'city': city,
        },
        'photos': imageUrls,
        'ownerId': _ownerId,
        'amenities': _amenities,
        'utilities': _utilities,
        'type': _typeController.text,
        'views': 0,
        'createdAt': Timestamp.now(),
      };

      String result =
          await _firestoreService.addProperty(propertyData: propertyData);

      if (result == "Success") {
        showSuccessNotification(context, "Property added successfully!");
        setState(() {
          _formKey.currentState!.reset();
          _images.clear();
          _amenities.clear();
          _utilities.clear();
        });
        Future.delayed(
            const Duration(
              seconds: 1,
            ), () {
          Navigator.of(context).pop();
        });
      } else {
        showErrorNotification(context, result);
        Future.delayed(
            const Duration(
              seconds: 1,
            ), () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to add property: $e';
      });
      showErrorNotification(context, _errorMessage!);
    } finally {
      setState(() {
        _isLoading = false;
      });
      Future.delayed(
          const Duration(
            seconds: 1,
          ), () {
        Navigator.of(context).pop();
      });
    }
  }
}
