// ignore_for_file: use_build_context_synchronously

import 'package:easy_home/utilities/ui/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  final String? initialSearchValue;

  const SearchPage({super.key, this.initialSearchValue});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  // late final FirestoreService _firestore;

  List<DocumentSnapshot> _searchResults = [];
  bool _isLoading = false;
  late final Screen size;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // _firestore = FirestoreService.instance;
    if (widget.initialSearchValue != null) {
      _titleController.text = widget.initialSearchValue!;
      _performSearch();
    }
  }

  Future<void> _performSearch() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Query query = FirebaseFirestore.instance.collection('properties');

    if (_titleController.text.isNotEmpty) {
      query = query.where('title', isEqualTo: _titleController.text);
    }
    if (_minPriceController.text.isNotEmpty) {
      query = query.where('price',
          isGreaterThanOrEqualTo: double.parse(_minPriceController.text));
    }
    if (_maxPriceController.text.isNotEmpty) {
      query = query.where('price',
          isLessThanOrEqualTo: double.parse(_maxPriceController.text));
    }
    if (_addressController.text.isNotEmpty) {
      query = query.where('address', isEqualTo: _addressController.text);
    }
    if (_countryController.text.isNotEmpty) {
      query =
          query.where('location.country', isEqualTo: _countryController.text);
    }
    if (_stateController.text.isNotEmpty) {
      query = query.where('location.state', isEqualTo: _stateController.text);
    }
    if (_cityController.text.isNotEmpty) {
      query = query.where('location.city', isEqualTo: _cityController.text);
    }

    try {
      QuerySnapshot snapshot = await query.get();
      setState(() {
        _searchResults = snapshot.docs;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error performing search: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _minPriceController,
                      decoration: const InputDecoration(labelText: 'Min Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isNotEmpty &&
                            double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _maxPriceController,
                      decoration: const InputDecoration(labelText: 'Max Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isNotEmpty &&
                            double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Address'),
                      validator: (value) {
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _countryController,
                      decoration: const InputDecoration(labelText: 'Country'),
                      validator: (value) {
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(labelText: 'State'),
                      validator: (value) {
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                      validator: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _performSearch,
                      child: const Text('Search'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                      ? const Text('No results found.')
                      : Column(
                          children: _searchResults.map((doc) {
                            var property = doc.data() as Map<String, dynamic>;
                            return Card(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: ListTile(
                                title: Text(property['title']),
                                subtitle: Text(
                                  '${property['location']['city']}, ${property['location']['state']}, ${property['location']['country']}',
                                ),
                                trailing: Text('\$${property['price']}'),
                              ),
                            );
                          }).toList(),
                        ),
            ],
          ),
        ),
      ),
    );
  }
   Widget titleWidget() {
    return Row(
      children: <Widget>[
        IconButton(
          padding: const EdgeInsets.fromLTRB(1,0,0,0),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
          child: Column(
            children: <Widget>[
              Text("Which type of house",
                  style: TextStyle(
                      fontFamily: 'Exo2',
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white
                    ),
                  ),
              Text("would you like to rent?",
                style: TextStyle(
                    fontFamily: 'Exo2',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Card upperBoxCard() {
    return Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(
            horizontal: size.getWidthPx(20), vertical: size.getWidthPx(0)),
        borderOnForeground: true,
        child: SizedBox(
          height: size.getWidthPx(60),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Center(
                  child: Hero(
                    tag: 'searcHero',
                    child: _searchWidget(),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              // leftAlignText(
              //     text: "Top Cities :",
              //     leftPadding: size.getWidthPx(16),
              //     textColor: textPrimaryColor,
              //     fontSize: 16.0),
              // HorizontalList(
              //   children: <Widget>[
              //     for(int i=0;i<citiesList.length;i++)
              //       buildChoiceChip(i, citiesList[i])
              //   ],
              // ),
            ],
          ),
        ));
  }

Widget _searchWidget() {
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    size = Screen(MediaQuery.of(context).size);
    return Container(
        padding: EdgeInsets.only(bottom :size.getWidthPx(8)),
        margin: EdgeInsets.only(top: size.getWidthPx(8), right: size.getWidthPx(8), left:size.getWidthPx(8)),
        child:  Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: height / 400),
                  padding: EdgeInsets.all(size.getWidthPx(0)),
                  alignment: Alignment.center,
                  height: size.getWidthPx(40),
                  decoration:  BoxDecoration(
                      color: Colors.grey.shade100,
                      border:  Border.all(color: Colors.grey.shade400, width: 1.0),
                      borderRadius:  BorderRadius.circular(8.0)),
                  child: Row(children: <Widget>[
                    SizedBox(width: size.getWidthPx(10),),
                    Icon(Icons.search,color: Theme.of(context).primaryColor),
                    const Text("Customize you search...")
                  ],) 
              ),),
          ],
        ),
    );
  }

  Padding leftAlignText({text, leftPadding, textColor, fontSize, fontWeight}) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text??"",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Exo2',
                fontSize: fontSize,
                fontWeight: fontWeight ?? FontWeight.w500,
                color: textColor)),
      ),
    );
  }

  Padding buildChoiceChip(BuildContext context,index, chipName) {
    return Padding(
      padding: EdgeInsets.only(left: size.getWidthPx(8)),
      child: ChoiceChip(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(
            fontFamily: 'Exo2',
            color:
                (_selectedIndex == index) ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).canvasColor),
        elevation: 4.0,
        padding: EdgeInsets.symmetric(
            vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
        selected: (_selectedIndex == index) ? true : false,
        label: Text(chipName),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
