import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

RegExp regExp = RegExp(urlExpression);
// check for web url expression
String urlExpression =
    r'(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?';
bool checkForFileOrNetworkPath(String path) {
  print("path $path");
  bool value = regExp.hasMatch(path);
  print("value : $value");
  return value;
}

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

Widget fetchImageWithPlaceHolderWithDims(
    double width, double height, String imageUrl) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    height: height,
    width: width,
    placeholder: (context, url) => placeHolderAssetWithDims(width, height),
    errorWidget: (context, url, error) =>
        placeHolderAssetWithDims(width, height),
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

Widget placeHolderAssetWithDims(double Width, double Height) {
  return Image.asset(
    'assets/images/bg_placeholder.jpg',
    fit: BoxFit.cover,
    height: Height,
    width: Width,
  );
}
