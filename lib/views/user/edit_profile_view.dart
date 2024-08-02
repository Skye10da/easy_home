// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:country_state_city_picker_2/country_state_city_picker.dart';
import 'package:easy_home/services/auth/auth_service.dart';
import 'package:easy_home/services/cloud/firestore_service.dart';
import 'package:easy_home/utilities/ui/flushbar_notifications.dart';
import 'package:easy_home/utilities/ui/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController fName;
  late final TextEditingController lName;
  late final TextEditingController bio;
  late final TextEditingController phoneNo;

  final userId = AuthService.firebase().currentUser!.id;
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  String? selectedGender;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  String? phoneNumberValue;
  final List<String> genders = ['Male', 'Female', 'Other'];
  late final FirestoreService _firestore;
  File? _image;
  final picker = ImagePicker();

  bool _isLoading = false;
  @override
  void initState() {
    fName = TextEditingController();
    lName = TextEditingController();
    bio = TextEditingController();
    phoneNo = TextEditingController();
    _firestore = FirestoreService.instance;
    readInfo();
    super.initState();
  }

  @override
  void dispose() {
    fName.dispose();
    lName.dispose();
    bio.dispose();
    phoneNo.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> saveDetails(String docId, Map<String, String> data) async {
    try {
      await _firestore.updateUser(userId: docId, userData: data);

      return "success";
    } on Exception catch (e) {
      return "error $e";
    }
  }

  void readInfo() async {
    setState(() {
      _isLoading = true;
    });
    var info = await _firestore.getUser(userId: userId);
    setState(() {
      lName.text = info!.lastName;
      fName.text = info.firstName;
      selectedGender = info.gender;
      bio.text = info.bio;
      countryValue = info.country;
      stateValue = info.state;
      cityValue = info.city;

      phoneNo.text = info.phoneNo;
      _isLoading = false;
    });
  }

  Future<void> getPhoneNumber(String phoneNumber) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(
        phoneNumber, initialCountry);
    setState(() {
      phoneNumberValue = number.phoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: _buildForm(
          context,
          size,
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, Screen size) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 80,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? const Icon(Icons.camera_alt, size: 50)
                  : null,
            ),
          ),
          const SizedBox(height: 50),
          _buildTextField(
              controller: fName,
              hintText: 'Enter First Name',
              label: 'First Name'),
          const SizedBox(height: 10),
          _buildTextField(
              controller: lName,
              hintText: 'Enter Last Name',
              label: 'Last Name'),
          const SizedBox(height: 10),
          _buildPhoneInput(),
          const SizedBox(height: 10),
          _buildTextField(
              controller: bio,
              hintText: 'Enter Bio information',
              label: 'Bio',
              maxLines: 3),
          const SizedBox(height: 10),
          _buildGenderDropdown(),
          const SizedBox(height: 10),
          _buildLocationPicker(),
          const SizedBox(height: 50),
          _buildSaveButton(context, size),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.name,
      autocorrect: true,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        label: Text(label),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {},
      onInputValidated: (bool value) {},
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        useBottomSheetSafeArea: true,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      selectorTextStyle: const TextStyle(color: Colors.black),
      initialValue: number,
      textFieldController: phoneNo,
      formatInput: true,
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      inputBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      value: selectedGender,
      items: genders.map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedGender = newValue;
        });
      },
    );
  }

  Widget _buildLocationPicker() {
    return SelectState(
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
          countryValue = value;
        });
      },
      onStateChanged: (value) {
        setState(() {
          stateValue = value;
        });
      },
      onCityChanged: (value) {
        setState(() {
          cityValue = value;
        });
      },
    );
  }

  Widget _buildSaveButton(BuildContext context, Screen size) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(5.0),
        animationDuration: const Duration(seconds: 2),
        enableFeedback: true,
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            vertical: size.getWidthPx(10),
            horizontal: size.getWidthPx(120),
          ),
        ),
      ),
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        try {
          await getPhoneNumber(phoneNo.text);
          var response = await saveDetails(userId, {
            'id': userId,
            'firstName': fName.text,
            'lastName': lName.text,
            'gender': selectedGender!,
            'country': countryValue!,
            'state': stateValue!,
            'city': cityValue!,
            'bio': bio.text,
            'phoneNo': phoneNumberValue!,
            'profilePicture': _image != null
                ? await _firestore.uploadProfilePicture(
                    file: _image!, docId: userId)
                : '',
          });
          if (response == 'success') {
            showSuccessNotification(context, "Details updated successfully!");
          }

          // print(response);
        } on Exception catch (_) {
          showErrorNotification(context, "Error while updating details!");
        } finally {
          setState(() {
            _isLoading = false;
            Future.delayed(
                const Duration(
                  seconds: 3,
                ), () {
              Navigator.of(context).pop();
            });
          });
        }
      },
      child:
          _isLoading ? const CircularProgressIndicator() : const Text('Save'),
    );
  }
}
