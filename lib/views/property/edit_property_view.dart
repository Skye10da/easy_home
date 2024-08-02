// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:easy_home/services/auth/auth_service.dart';
import 'package:easy_home/utilities/ui/flushbar_notifications.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_home/services/cloud/firestore_service.dart';

class EditPropertyPage extends StatefulWidget {
  final String propertyId;

  const EditPropertyPage({required this.propertyId, super.key});

  @override
  EditPropertyPageState createState() => EditPropertyPageState();
}

class EditPropertyPageState extends State<EditPropertyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _addressController;
  late final TextEditingController _countryController;
  late final TextEditingController _stateController;
  late final TextEditingController _cityController;
  late final FirestoreService _firestoreService;
  final userId = AuthService.firebase().currentUser!.id;

  bool _isLoading = false;

  List<String> _selectedAmenities = [];
  List<String> _selectedUtilities = [];
  List<String> _currentImageUrls = [];
  final List<String> _allAmenities = [
    'Pool',
    'Gym',
    'Parking',
    'WiFi',
  ];
  final List<String> _allUtilities = [
    'Electricity',
    'Water',
    'Gas',
    'Internet'
  ];

  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();

    setState(() {
      _images.addAll(pickedFiles);
    });
  }

  Future<void> _fetchPropertyData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var propertyData =
          await _firestoreService.getProperty(propertyId: widget.propertyId);
      setState(() {
        _titleController.text = propertyData!.title;
        _descriptionController.text = propertyData.description;
        _priceController.text = propertyData.price.toString();
        _addressController.text = propertyData.address;
        _countryController.text = propertyData.location['country'].toString();
        _stateController.text = propertyData.location['state'].toString();
        _cityController.text = propertyData.location['city'].toString();
        _selectedAmenities = List<String>.from(propertyData.amenities);
        _selectedUtilities = List<String>.from(propertyData.utilities);
        _currentImageUrls = List<String>.from(propertyData.photos);
      });
    } catch (e) {
      showErrorNotification(context, 'Error fetching property data');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      showErrorNotification(
          context, 'Please fill all fields and upload images');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var newImageUrls = await _firestoreService.uploadImages(images: _images);

      var allImageUrls = [..._currentImageUrls, ...newImageUrls];

      var propertyData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'address': _addressController.text,
        'location': {
          'country': _countryController.text,
          'state': _stateController.text,
          'city': _cityController.text,
        },
        'photos': allImageUrls,
        'ownerId': userId,
        'amenities': _selectedAmenities,
        'utilities': _selectedUtilities,
      };

      var response = await _firestoreService.updateProperty(
          propertyId: widget.propertyId, propertyData: propertyData);
      if (response == "Success") {
        showSuccessNotification(context, 'Property updated successfully');
        Future.delayed(
            const Duration(
              seconds: 1,
            ), () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      showErrorNotification(
        context,
        'An error occurred while updating property',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _addressController = TextEditingController();
    _countryController = TextEditingController();
    _stateController = TextEditingController();
    _cityController = TextEditingController();
    _firestoreService = FirestoreService.instance;

    _fetchPropertyData();

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Property'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the country';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'State'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the state';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              _buildMultiSelectChips(
                  'Amenities', _allAmenities, _selectedAmenities),
              const SizedBox(height: 16.0),
              _buildMultiSelectChips(
                  'Utilities', _allUtilities, _selectedUtilities),
              const SizedBox(height: 16.0),
              _buildImagePicker(),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : const Text('Update Property'),
              ),
            ],
          ),
        ),
      ),
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
              onSelected: (isSelected) {
                setState(() {
                  if (isSelected) {
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
}
