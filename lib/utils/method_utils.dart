import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

fetchImageWithPlaceHolder(String imageUrl) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    placeholder: (context, url) => placeHolderAssetWidget(),
    errorWidget: (context, url, error) => placeHolderAssetWidget(),
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(
                Colors.transparent, BlendMode.colorBurn)),
      ),
    ),
  );
}

String getDateFromDateTimeInSpecificFormat(DateFormat dateFormat, String date) {
  DateTime mDateTime = DateTime.parse(date);
  return dateFormat.format(mDateTime);
}

Widget placeHolderAssetWidget() {
  return Image.asset(
    'assets/images/bg_placeholder.jpg',
    fit: BoxFit.cover,
  );
}
