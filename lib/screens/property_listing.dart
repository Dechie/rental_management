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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Property Listing"),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.list),
                text: "Properties",
              ),
              Tab(
                icon: Icon(Icons.request_page),
                text: "Requests",
              )
            ],
          ),
        ),
        body: TabBarView(children: [
          isFetching
              ? const Center(child: CircularProgressIndicator())
              : _buildPropertyList(),
          _buildRequestedList(),
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: () {
            try {
              //Navigator.pushNamed(context, PropertyPost.routeName);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PropertyPost()));
            } catch (e) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(e.toString())));
            }
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchPropertyList();
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

    //List subSubWidgets =
    var rrow = Row(
      children: rentModel.details!.entries
          .take(2)
          .map((entry) => Text("${entry.key}: ${entry.value}"))
          .toList(),
    );
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
      SizedBox(
        width: double.infinity,
        child: rrow,
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
      ),
    ];

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
                ),
              ),
            );
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
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
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

  _buildRequestedList() {
    if (requestedProps.isEmpty) {
      return const Center(
        child: Text(
          "No data found!!",
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      itemCount: requestedProps.length,
      itemBuilder: (BuildContext context, int index) {
        var rentModel = requestedProps[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PropertyDetails(
                  rentModel: rentModel,
                ),
              ),
            );
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
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    child: _buildImage(rentModel),
                  ),
                  Expanded(
                    child: _buildRequestedPropertyInfo(rentModel),
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

  _buildRequestedPropertyInfo(PropertyModel rentModel) {
    List<Widget> subWidgets = [];

    //List subSubWidgets =
    var rrow = Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Row(
        children: rentModel.details!.entries
            .take(2)
            .map((entry) => Text("${entry.key}: ${entry.value}"))
            .toList(),
      ),
    );
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
      SizedBox(
        width: double.infinity,
        child: rrow,
      ),
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.greenAccent),
              ),
              onPressed: () {},
              child: const Text("Approve"),
            ),
            const SizedBox(width: 10),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.redAccent),
              ),
              onPressed: () {},
              child: const Text("Decline"),
            ),
          ],
        ),
      ),
    ];

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

  void _fetchPropertyList() {
    propertyRentList =
        propertyRentList.where((prop) => prop.availability == true).toList();
  }
}
