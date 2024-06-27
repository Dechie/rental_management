import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_management/models/property_model.dart';

import '../utils/method_utils.dart';

class PropertyDetails extends StatefulWidget {
  static const routeName = "/property-details";
  final PropertyModel rentModel;

  const PropertyDetails({
    super.key,
    required this.rentModel,
  });

  @override
  State<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
  int currentView = 1;
  var dateFormat = DateFormat("dd MM, yyyy");
  @override
  Widget build(BuildContext context) {
    final postedDate = getDateFromDateTimeInSpecificFormat(
        dateFormat, widget.rentModel.updatedAt ?? "yyyy-MM-dd");
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          _buildSliverListBody(postedDate),
        ],
      ),
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    return SizedBox(
      child: imageUrl.isEmpty || imageUrl.isEmpty
          ? placeHolderAssetWidget()
          : fetchImageWithPlaceHolder(imageUrl),
    );
  }

  List<Widget> _buildPropertyDetails() {
    var modell = widget.rentModel;

    List<Widget> subWidgets = modell.details!.entries
        .map(
          (entry) => Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "${entry.value}",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
    // return Padding(
    //   //   padding: const EdgeInsets.symmetric(vertical: 10),
    //   child: SizedBox(
    //     height: MediaQuery.of(context).size.width * .45,
    //     child: ListView(children: subWidgets),
    //   ),
    // );
    return subWidgets;
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      //backgroundColor: themeColor,
      pinned: true,
      titleSpacing: 0.0,
      expandedHeight: MediaQuery.of(context).size.height * 0.3,
      flexibleSpace: FlexibleSpaceBar(
        title: Text("ETB. ${widget.rentModel.price}"),
        background: Hero(
          tag: widget.rentModel.id ?? "selected",
          child: widget.rentModel.images != null &&
                  (widget.rentModel.images?.length ?? 0) > 0
              ? Stack(
                  children: <Widget>[
                    PageView.builder(
                      onPageChanged: (view) {
                        setState(() {
                          currentView = view + 1;
                        });
                      },
                      itemCount: widget.rentModel.images?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildImageWidget(
                            widget.rentModel.images![index]);
                      },
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: Container(
                        color: Colors.black,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 3.0, left: 5.0, bottom: 3.0, right: 3.0),
                              child: Text(
                                "$currentView/${widget.rentModel.images?.length}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 17.0),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  top: 3.0, right: 5.0, bottom: 3.0),
                              child: Icon(
                                Icons.wallpaper,
                                color: Colors.white,
                                size: 18.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : placeHolderAssetWidget(),
        ),
      ),
    );
  }

  Widget _buildSliverListBody(String postedDate) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Request Rent"),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              "Posted on $postedDate",
              textAlign: TextAlign.center,
              softWrap: true,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        ..._buildPropertyDetails(),
        _propertyAddressView("Region", widget.rentModel.region!),
        _propertyAddressView("City", widget.rentModel.city!),
        _propertyAddressView("Subcity", widget.rentModel.subcity!),
        _propertyAddressView("Contact", widget.rentModel.contact!),
      ]),
    );
  }

  Widget _propertyAddressView(String label, String Value) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.5),
            child: Text(
              label,
              style:
                  const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.5),
            child: Text(
              Value,
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showPieceOfInfo(IconData iconData, String text) {
    return Column(
      children: [
        Icon(
          iconData,
          size: 20,
        ),
        Text(text),
      ],
    );
  }
}
