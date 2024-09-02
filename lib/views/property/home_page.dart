import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_home/services/cloud/firestore_service.dart';
import 'package:easy_home/services/model/property_model.dart';
import 'package:easy_home/utilities/ui/clippers.dart';
import 'package:easy_home/utilities/ui/responsive_container.dart';
import 'package:easy_home/utilities/ui/screen_size.dart';
import 'package:easy_home/views/property/property_detail_view.dart';
import 'package:easy_home/views/property/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService.instance;

  int selectedIndex = 0;
  late final size = Screen(MediaQuery.of(context).size);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //     // title: const Text('Easy Home'),
      //     ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              upperPart(),

              const SizedBox(
                height: 10,
              ),
              // : const SizedBox(height: 0),
              const Text(
                'Trending Properties',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              _buildTrendingProperties(context),
              const SizedBox(height: 32.0),
              const Text(
                'New Properties',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              _buildNewProperties(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingProperties(BuildContext context) {
    return StreamBuilder<List<PropertyModel>>(
      stream: _firestoreService.getProperties(orderBy: 'views'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<PropertyModel> properties = snapshot.data!;

        return SizedBox(
          height: 600,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: const EdgeInsets.all(8),
                        borderOnForeground: true,
                        child: InkWell(
                          onTap: () {
                            // Navigate
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PropertyDetailsPage(
                                    propertyId: properties[index].id),
                              ),
                            );
                          },
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: properties[index].photos[0],
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  height: size.hp(35),
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              ResponsiveContainer(
                                //  maxWidth: 50,
                                // height: 100,
                                wrapHeight: true,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ResponsiveContainer(
                                          maxWidth: size.wp(15),
                                          // height: size.hp(10),
                                          wrapHeight: true,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10)),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                    // right: BorderSide(
                                                    //   // color: Colors.grey,
                                                    //   width: 1.0,
                                                    // ),
                                                    ),
                                              ),
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Vews: ${properties[index].views}')),
                                            ),
                                          ),
                                        ),
                                        ResponsiveContainer(
                                          maxWidth: size.wp(40),
                                          // height: size.hp(10),
                                          wrapHeight: true,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10)),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  'Price: #${properties[index].price} / year'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ResponsiveContainer(
                                          maxWidth: size.wp(65),
                                          wrapHeight: true,
                                          // height: size.hp(10),
                                          child: Align(
                                            child: Text(
                                                'Location: ${properties[index].location.values}'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            itemCount: properties.length,
            pagination: const SwiperPagination(),
            control: const SwiperControl(),
          ),
        );
      },
    );
  }

  Widget _buildNewProperties(BuildContext context) {
    return StreamBuilder<List<PropertyModel>>(
      stream: _firestoreService.getProperties(orderBy: 'createdAt'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<PropertyModel> properties = snapshot.data!;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: properties.length,
          itemBuilder: (context, index) {
            return InkWell(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PropertyDetailsPage(propertyId: properties[index].id),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.all(8),
                borderOnForeground: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: properties[index].photos[0],
                        fit: BoxFit.fill,
                        width: double.infinity,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            properties[index].title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          Text('#${properties[index].price}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget titleWidget() {
    return const Row(
      children: <Widget>[
        SizedBox(
          width: 70,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            children: <Widget>[
              Text(
                "Which type of house",
                style: TextStyle(
                    fontFamily: 'Exo2',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
              Text(
                "would you like to rent?",
                style: TextStyle(
                    fontFamily: 'Exo2',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget upperPart() {
    Screen size = Screen(MediaQuery.of(context).size);
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: UpperClipper(),
          child: Container(
            height: size.getWidthPx(140),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).secondaryHeaderColor
                ],
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: size.getWidthPx(6)),
              child: Column(
                children: <Widget>[
                  titleWidget(),
                  SizedBox(height: size.getWidthPx(1)),
                  upperBoxCard(),
                ],
              ),
            ),
            //searchResult(),
          ],
        ),
      ],
    );
  }

  Card upperBoxCard() {
    Screen size = Screen(MediaQuery.of(context).size);
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
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: PropertySearchDelegate(),
                  );
                },
                child: Center(
                  child: Hero(
                    tag: 'searcHero',
                    child: _searchWidget(),
                  ),
                ),
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
    Screen size = Screen(MediaQuery.of(context).size);
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    size = Screen(MediaQuery.of(context).size);
    return Container(
      padding: EdgeInsets.only(bottom: size.getWidthPx(8)),
      margin: EdgeInsets.only(
          top: size.getWidthPx(8),
          right: size.getWidthPx(8),
          left: size.getWidthPx(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
                margin: EdgeInsets.only(top: height / 400),
                padding: EdgeInsets.all(size.getWidthPx(0)),
                alignment: Alignment.center,
                height: size.getWidthPx(40),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade400, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: size.getWidthPx(10),
                    ),
                    Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                    const Text("Search for your new home...")
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Padding leftAlignText({text, leftPadding, textColor, fontSize, fontWeight}) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text ?? "",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Exo2',
                fontSize: fontSize,
                fontWeight: fontWeight ?? FontWeight.w500,
                color: textColor)),
      ),
    );
  }

  Padding buildChoiceChip(
    index,
    chipName,
  ) {
    Screen size = Screen(MediaQuery.of(context).size);
    return Padding(
      padding: EdgeInsets.only(left: size.getWidthPx(8)),
      child: ChoiceChip(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(
            fontFamily: 'Exo2',
            color: (selectedIndex == index)
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).primaryColor),
        elevation: 4.0,
        padding: EdgeInsets.symmetric(
            vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
        selected: (selectedIndex == index) ? true : false,
        label: Text(chipName),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
