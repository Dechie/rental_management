import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../models/property_model.dart';
import '../utils/colors.dart';
import '../utils/method_utils.dart';

class PropertyPost extends StatefulWidget {
  static const String routeName = '/property-post';
  PropertyModel? rentModel;
  PropertyPost({super.key});

  @override
  State<PropertyPost> createState() => _PropertyPostState();
}

class _PropertyPostState extends State<PropertyPost> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController bedroomController = TextEditingController();
  TextEditingController bathroomController = TextEditingController();
  TextEditingController balconyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  int selected = 0;
  List<String> _imageFilesList = [];
  var isUploadingPost = false;
  var isEditInitialized = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text("Rent Property"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildLabel("PROPERTY TYPE"),
                    _buildPropertyTypesWidget(),
                    _buildLabel("PROPERTY PHOTOS"),
                    _buildPropertyPhotosWidget(),
                    _buildLabel("PROPERTY ADDRESS"),
                    _buildPropertyLocationWidget(),
                    _buildLabel("PRICE"),
                    _buildPriceWidget(),
                    _buildLabel("PROPERTY DETAILS"),
                    _buildPropertyDetailsWidget(),
                    _buildLabel("CONTACT DETAILS"),
                    _buildContactDetailsWidget(),
                    _buildLabel("OTHER DETAILS"),
                    _buildOtherDetailsWidget(),
                  ],
                ),
              ),
            ),
          ),
          _buildSubmitPostWidget(),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (widget.rentModel != null) {
      if (isEditInitialized) {
        cityController.text = widget.rentModel?.city ?? "";
        regionController.text = widget.rentModel?.region ?? "";
        priceController.text = widget.rentModel?.price ?? "";
        descriptionController.text = widget.rentModel?.description ?? "";
        contactController.text = widget.rentModel?.contact ?? "";
        selected = widget.rentModel?.propertyType.index ?? 0;

        if (widget.rentModel?.images != null &&
            (widget.rentModel?.images?.length ?? 0) > 0) {
          _imageFilesList = widget.rentModel!.images ?? [];

          print("_imageFilesList : ${_imageFilesList.length}");
          print("_imageFilesList : $_imageFilesList");
        }

        isEditInitialized = false;
      }
    }

    super.didChangeDependencies();
  }

  Future<List<String>> uploadImage(List<String> imageFiles) async {
    List<String> filePaths = [];

    print("filePaths : $filePaths");
    for (int i = 0; i < imageFiles.length; i++) {
      if (checkForFileOrNetworkPath(imageFiles[i])) {
        filePaths.add(imageFiles[i]);
        continue;
      }
      final firebaseStorageRef = FirebaseStorage.instance

      .ref()
      .child("images/sell/${DateTime.now().toIso8601String()}");

      final uploadTask = firebaseStorageRef.putFile(File(imageFiles[i]));
      //
      final taskSnapshot = await uploadTask.whenComplete(() => null);
      String storagePath = await taskSnapshot.ref.getDownloadURL();
      filePaths.add(storagePath);
    }

    print("filePaths : $filePaths");
    return filePaths;
  }

  Widget _buildContactDetailsWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.only(top: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          validator: (String? contact) {
            if (contact?.isEmpty ?? false) {
              return "Contact field is required!!";
            }
            return null;
          },
          keyboardType: TextInputType.number,
          maxLength: 10,
          controller: contactController,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            counterText: "",
            labelText: "Contact",
            labelStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Text(
        label,
        style: TextStyle(color: textLabelColor, fontSize: 11.0),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildOtherDetailsWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.only(top: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          controller: descriptionController,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            labelText: "Additional Property Description",
            labelStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.only(top: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          validator: (String? price) {
            if (price?.isEmpty ?? false) {
              return "Price field is required!!";
            }
            return null;
          },
          keyboardType: TextInputType.number,
          controller: priceController,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            labelText: "Price",
            labelStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyDetailsWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              validator: (String? bedrooms) {
                if (bedrooms?.isEmpty ?? false) {
                  return "Bedroom field is required!!";
                }
                return null;
              },
              controller: bedroomController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: "BedRoom(s)",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              controller: bathroomController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: "BathRoom(s)",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              controller: balconyController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: "No. of Balconies",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyLocationWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _getLocation();
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Icon(
                    Icons.my_location,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 20.0),
                  child: Text("Detect Property Location"),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              controller: addressController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: "Address",
                labelStyle: TextStyle(color: Colors.grey),
              ),
              validator: (String? address) {
                if (address?.isEmpty ?? false) {
                  return "Address field is required!!";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              controller: cityController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: "City",
                labelStyle: TextStyle(color: Colors.grey),
              ),
              validator: (String? city) {
                if (city?.isEmpty ?? false) {
                  return "City field is required!!";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              controller: regionController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: "Region (Optional)",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              validator: (String? country) {
                if (country?.isEmpty ?? false) {
                  return "Country field is required!!";
                }
                return null;
              },
              controller: countryController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: "Country",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyPhotosWidget() {
    return Container(
      color: Colors.white,
      height: 120.0,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Column(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _openImagePicker(context);
                  },
                  icon: const Icon(Icons.camera_enhance),
                  color: Colors.grey,
                  iconSize: 65.0,
                ),
                const Text(
                  "Add Photos",
                  style: TextStyle(fontSize: 13.0),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: _imageFilesList.length,
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      height: 80.0,
                      width: 80.0,
                      child: Stack(
                        children: <Widget>[
                          ClipOval(
                            child: _imageFilesList[index].isNotEmpty
                                ? checkForFileOrNetworkPath(
                                        _imageFilesList[index])
                                    ? fetchImageWithPlaceHolderWithDims(
                                        80.0, 80.0, _imageFilesList[index])
                                    /*Image.network(
                                        _imageFilesList[index],
                                        fit: BoxFit.cover,
                                        height: 80.0,
                                        width: 80.0,
                                      )*/
                                    : Image.file(
                                        File(_imageFilesList[index]),
                                        fit: BoxFit.cover,
                                        height: 80.0,
                                        width: 80.0,
                                      )
                                : Image.asset(
                                    "assets/images/transparent_placeholder.png",
                                    fit: BoxFit.cover,
                                    height: 80.0,
                                    width: 80.0,
                                  ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _imageFilesList.removeAt(index);
                              });
                            },
                            child: Container(
                              alignment: Alignment.topRight,
                              child: Image.asset(
                                "assets/images/cancel.png",
                                fit: BoxFit.fitHeight,
                                height: 20.0,
                                width: 20.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyTypesWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                selected = selected == 1 ? 0 : 1;
              });
            },
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.business,
                  size: 70,
                  color: selected == 1 ? Colors.red : unselectedIconColor,
                ),
                const Text(
                  "Apartment",
                  style: TextStyle(fontSize: 13.0),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                selected = selected == 2 ? 0 : 2;
              });
            },
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.home,
                  size: 70,
                  color: selected == 2 ? Colors.green : unselectedIconColor,
                ),
                const Text(
                  "Flat",
                  style: TextStyle(fontSize: 13.0),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                selected = selected == 3 ? 0 : 3;
              });
            },
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.landscape,
                  size: 70,
                  color: selected == 3 ? Colors.blue : unselectedIconColor,
                ),
                const Text(
                  "Plot/Land",
                  style: TextStyle(fontSize: 13.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitPostWidget() {
    return GestureDetector(
      onTap: () {
        _submitPropertySellPost();
      },
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.only(top: 10.0),
        margin: const EdgeInsets.only(top: 10.0),
        width: double.infinity,
        height: 50.0,
        child: Center(
          child: Text(
            isUploadingPost ? "Uploading..." : "Submit Post",
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                letterSpacing: 2.0),
          ),
        ),
      ),
    );
  }

  _getImage(BuildContext context, ImageSource source) async {
    ImagePicker()
        .pickImage(
      source: source,
      maxWidth: 400.0,
      maxHeight: 400.0,
    )
        .then((XFile? image) async {
      if (image != null) {
        setState(() {
          _imageFilesList.add(image.path);
          print("_imageFile : $image");
          print("filePath : ${image.path}");
          //print("fileURI : ${image}");
          /*String filePath = image.path;
          Uri fileURI = image.uri;*/
        });
      }
    });
  }

  _getLocation() async {
    // try {
    //   Geolocator geolocator = Geolocator();
    //   Position currentLocation = await Geolocator.getCurrentPosition(
    //       desiredAccuracy: LocationAccuracy.best);
    //   final placemark = await placemarkFromCoordinates(
    //       currentLocation.latitude, currentLocation.longitude);

    //   print("country : ${placemark[0].country}");
    //   print("position : ${placemark[0]}");
    //   print("locality : ${placemark[0].locality}");
    //   print("administrativeArea : ${placemark[0].administrativeArea}");
    //   print("postalCode : ${placemark[0].postalCode}");
    //   print("name : ${placemark[0].name}");
    //   print("subAdministrativeArea : ${placemark[0].subAdministrativeArea}");
    //   print("isoCountryCode : ${placemark[0].isoCountryCode}");
    //   print("subLocality : ${placemark[0].subLocality}");
    //   print("subThoroughfare : ${placemark[0].subThoroughfare}");
    //   print("thoroughfare : ${placemark[0].thoroughfare}");

    //   if (placemark[0].country?.isNotEmpty ?? true) {
    //     countryController.text = placemark[0].country ?? "";
    //   }

    //   if (placemark[0].administrativeArea?.isNotEmpty ?? true) {
    //     regionController.text = placemark[0].administrativeArea ?? "";
    //   }

    //   if (placemark[0].subAdministrativeArea?.isNotEmpty ?? true) {
    //     cityController.text = placemark[0].subAdministrativeArea ?? "";
    //   }

    //   if (placemark[0].name?.isNotEmpty ?? true) {
    //     addressController.text = placemark[0].name ?? "";
    //   }

    //   setState(() {});
    // } on PlatformException catch (error) {
    //   print(error.message);
    // } catch (error) {
    //   print("Error: $error");
    // }
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    "Select Image",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    _getImage(context, ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera,
                        size: 30.0,
                        color: themeColor,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                      ),
                      Text(
                        "Use Camera",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: themeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    _getImage(context, ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.camera,
                        size: 30.0,
                        color: themeColor,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                      ),
                      Text(
                        "Use Gallery",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: themeColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  _submitPropertySellPost() async {
    if (selected == 0) {
      const snackBar = SnackBar(content: Text("Select property type!!"));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // NetworkCheck networkCheck = NetworkCheck();
    // networkCheck.checkInternet((isNetworkPresent) async {
    //   if (!isNetworkPresent) {
    //     const snackBar =
    //         SnackBar(content: Text("Please check your internet connection !!"));

    //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //     return;
    //   } else {
    //     setState(() {
    //       isUploadingPost = true;
    //     });
    //   }
    // });

    try {
      List<String> imagePaths = [];
      try {
        if (_imageFilesList.isNotEmpty) {
          imagePaths = await uploadImage(_imageFilesList);
          print("imagePaths : $imagePaths");
          print("imagePaths : ${imagePaths.length}");
        }
      } catch (error) {
        print("uploadError : ${error.toString()}");
      }

      final propertySellReference =
          FirebaseStorage.instance.ref().child("Property").child("Sell");

          print("_imageFilesList : ${_imageFilesList.length}");
      print("imagePaths : ${imagePaths.length}");

      // String resourceID = propertySellReference.push().key ?? "";

      // if (widget.rentModel == null || widget.rentModel?.id == null) {
      //   await propertySellReference.child(resourceID).set({
      //     "id": resourceID,
      //     "sellType": selected,
      //     "images": imagePaths.isNotEmpty ? imagePaths : "",
      //     "sellAddress": addressController.text,
      //     "sellCity": cityController.text,
      //     "sellRegion": regionController.text,
      //     "sellCountry": countryController.text,
      //     "sellPrice": priceController.text,
      //     "sellBathrooms": bathroomController.text,
      //     "bedrooms": bedroomController.text,
      //     "sellBalconies": balconyController.text,
      //     "sellContact": contactController.text,
      //     "sellDescription": descriptionController.text,
      //     "updatedAt": DateTime.now().toIso8601String(),
      //   });
      // } else {
      //   await propertySellReference.child(widget.rentModel?.id ?? "").update({
      //     "id": widget.rentModel?.id,
      //     "sellType": selected,
      //     "images": imagePaths.isNotEmpty ? imagePaths : "",
      //     "sellAddress": addressController.text,
      //     "sellCity": cityController.text,
      //     "sellRegion": regionController.text,
      //     "sellCountry": countryController.text,
      //     "sellPrice": priceController.text,
      //     "sellBathrooms": bathroomController.text,
      //     "bedrooms": bedroomController.text,
      //     "sellBalconies": balconyController.text,
      //     "sellContact": contactController.text,
      //     "sellDescription": descriptionController.text,
      //     "updatedAt": DateTime.now().toIso8601String(),
      //   });
      // }

      setState(() {
        isUploadingPost = false;
      });

      // var propertyName =
      //     "${bedroomController.text} BHK ${getPropertyTypeById(selected)} is for sale !!";
      var contact = "Contact : ${contactController.text}";
      //repeatNotification(propertyName, contact);

      Navigator.of(context).pop();
    } catch (error) {
      print("catch block : $error");

      setState(() {
        isUploadingPost = false;
      });
      const snackBar =
          SnackBar(content: Text("Something went wrong. please try again !!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
