import 'package:flutter/material.dart';
import 'package:rental_management/utils/method_utils.dart';

import '../models/dummy_data.dart';
import '../models/property_model.dart';
import 'property_details.dart';
import 'property_post.dart';

class PropertyListing extends StatefulWidget {
  const PropertyListing({super.key});

  @override
  State<PropertyListing> createState() => _PropertyListingState();
}

class _PropertyListingState extends State<PropertyListing> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isFetching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Property Listing"),
      ),
      body: isFetching
          ? const Center(child: CircularProgressIndicator())
          : _buildPropertyList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, PropertyPost.routeName);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchRentPropertyData();
  }

  Widget _buildImage(PropertyModel rentModel) {
    return Hero(
      tag: rentModel.id ?? "tag",
      child: SizedBox(
        height: 120,
        width: 120,
        child: rentModel.images == null ||
                rentModel.images!.isEmpty ||
                rentModel.images![0].isEmpty
            ? placeHolderAssetWidget()
            : fetchImageWithPlaceHolder(rentModel.images![0]),
      ),
    );
  }

  _buildPropertyInfo(PropertyModel rentModel) {
    List<Widget> subWidgets = [];

    switch (rentModel.propertyType) {
      case PropertyType.house:
        subWidgets = [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
            child: Text(
              "ETB ${rentModel.price}",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
              child: Text(
                  "${rentModel.details!['bedrooms']} Bedrooms, ${rentModel.details!['houseType']}")),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
            child: Text(rentModel.city ?? ""),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.phone,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(rentModel.contact ?? ""),
                ),
              ],
            ),
          )
        ];
        break;
      case PropertyType.car:
        subWidgets = [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
            child: Text(
              "ETB ${rentModel.price}",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
            child: Text(
              "${rentModel.details!['model']}, Mileage ${rentModel.details?['mileage']} km",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
            child: Text(rentModel.city ?? ""),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.phone,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(rentModel.contact ?? ""),
                ),
              ],
            ),
          )
        ];
        break;
      case PropertyType.garment:
        subWidgets = [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
            child: Text(
              "ETB ${rentModel.price}",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
            child: Text(
              "${rentModel.details!['male_or_female']}, ${rentModel.details?['fabric_type']}",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
            child: Text(rentModel.city ?? ""),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.phone,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(rentModel.contact ?? ""),
                ),
              ],
            ),
          )
        ];
      default:
        break;
    }

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: subWidgets,
        ),
        Positioned(
          right: 0.0,
          top: 0.0,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  _buildPropertyList() {
    if (propertyRentList.isEmpty) {
      return const Center(
        child: Text(
          "No data found!!",
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      itemCount: propertyRentList.length,
      itemBuilder: (BuildContext context, int index) {
        var rentModel = propertyRentList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PropertyDetails(
                          rentModel: rentModel,
                        )));
          },
          child: Card(
            margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
            elevation: 5,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: SizedBox(
              height: 120,
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                    ),
                    child: _buildImage(rentModel),
                  ),
                  Expanded(
                    child: _buildPropertyInfo(rentModel),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }

  _fetchRentPropertyData() {}
}
