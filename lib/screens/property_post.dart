import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_management/models/dummy_data.dart';

import '../models/property_model.dart';
import '../utils/colors.dart';
import '../utils/method_utils.dart';

class PropertyPost extends StatefulWidget {
  static const String routeName = '/property-post';
  const PropertyPost({super.key});

  @override
  State<PropertyPost> createState() => _PropertyPostState();
}

class _PropertyPostState extends State<PropertyPost> {
  PropertyModel rentModel = PropertyModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();

  String _subcity = "",
      _city = "",
      _region = "",
      _description = "",
      _contact = "";
  double _price = 0.0;

  int selected = 0;
  final List<String> _imageFilesList = [];
  var isUploadingPost = false;
  var isEditInitialized = true;

  final List<TextEditingController> _detailControllers = [];
  //final Map<int, String> _detailTextValues = {};
  final Map<String, String> _detailTextValues = {};
  final List<Map<String, TextEditingController>> _dynamicFields = [];

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
            child: Form(
              key: _formKey,
              child: Expanded(
                child: ListView(
                  children: [
                    Column(
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
                        //_buildLabel("PROPERTY DETAILS"),
                        //_buildPropertyDetailsWidget(),
                        _buildLabel("CONTACT DETAILS"),
                        _buildContactDetailsWidget(),
                        _buildLabel("OTHER DETAILS"),
                        _buildDescription(),
                        _buildLabel("OTHER DETAILS"),
                      ],
                    ),
                    SizedBox(height: 300, child: _buildOtherDetails()),
                    GestureDetector(
                      onTap: () {
                        _addNewTextField();
                      },
                      child: const SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.red,
                          ),
                          child: Center(
                            child: Text("Add New Field"),
                          ),
                        ),
                      ),
                    )
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
  void dispose() {
    for (var field in _dynamicFields) {
      field['key']!.dispose();
      field['value']!.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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

  void _addNewTextField() {
    final keyController = TextEditingController();
    final valueController = TextEditingController();
    setState(() {
      _dynamicFields.add({
        'key': keyController,
        'value': valueController,
      });
    });

    valueController.addListener(() {
      final key = keyController.text;
      if (key.isNotEmpty) {
        _detailTextValues[key] = valueController.text;
      }
    });
  }

  Widget _buildContactDetailsWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.only(top: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Contact field is required!!";
            }
            return null;
          },
          onSaved: (String? value) {
            _contact = value!;
          },
          keyboardType: TextInputType.number,
          maxLength: 10,
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

  Widget _buildDescription() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.only(top: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "description is required!";
            }
            return null;
          },
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            labelText: "Additional Property Description",
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

  Widget _buildOtherDetails() {
    return Expanded(
      child: ListView.builder(
        itemCount: _dynamicFields.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: _dynamicFields[index]['key']!,
                decoration: InputDecoration(
                  labelText: "Detail Title ${index + 1}",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please enter text";
                  }
                  return null;
                },
                onSaved: (input) {
                  if (input!.isNotEmpty) {
                    _detailTextValues[input] =
                        _dynamicFields[index]['value']!.text;
                  }
                },
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _dynamicFields[index]['value']!,
                decoration: InputDecoration(
                  labelText: "Detail Field ${index + 1}",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please enter text";
                  }
                  return null;
                },
                onSaved: (input) {
                  final key = _dynamicFields[index]['key']!.text;
                  if (key.isNotEmpty) {
                    _detailTextValues[key] = input!;
                  }
                },
              ),
            ],
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
            if (price == null || price.isEmpty) {
              return "Price field is required!!";
            }
            return null;
          },
          onSaved: (value) {
            _price = double.tryParse(value!)!;
          },
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            labelText: "Price",
            labelStyle: TextStyle(color: Colors.grey),
          ),
        ),
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
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: "Region (Optional)",
                labelStyle: TextStyle(color: Colors.grey),
              ),
              onSaved: (value) {
                _region = value!;
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: "City",
                labelStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "City field is required!";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              validator: (String? value) {
                if (value?.isEmpty ?? false) {
                  return "sub-city field is required!!";
                }
                return null;
              },
              onSaved: (value) {
                _subcity = value!;
              },
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: "Sub City",
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

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 160.0,
            padding: const EdgeInsets.all(10.0),
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
    setState(() {
      isUploadingPost = true;
    });
    if (selected == 0) {
      const snackBar = SnackBar(content: Text("Select property type!!"));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    try {
      List<String> imagePaths = [];
      // try {
      //   if (_imageFilesList.isNotEmpty) {
      //     imagePaths = await uploadImage(_imageFilesList);
      //     print("imagePaths : $imagePaths");
      //     print("imagePaths : ${imagePaths.length}");
      //   }
      // } catch (error) {
      //   print("uploadError : ${error.toString()}");
      // }

      // final propertySellReference =
      //     FirebaseStorage.instance.ref().child("Property").child("Sell");

      print("_imageFilesList : ${_imageFilesList.length}");
      print("imagePaths : ${imagePaths.length}");

      // TODO: These lines below are for firebase posting.
      // String resourceID = propertySellReference.push().key ?? "";

      // if (rentModel == null || widget.rentModel.id == null) {
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
      //   await propertySellReference.child(rentModel.id ?? "").update({
      //     "id": rentModel.id,
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
      var x = Future.delayed(const Duration(seconds: 3), () {
        var newModel = PropertyModel(
          id: "--",
          userId: "1",
          availability: true,
          images: _imageFilesList,
          price: _price.toString(),
          region: _region,
          city: _city,
          subcity: _subcity,
          //details: {"bedrooms": 1, "bathrooms": 5},
          details: _detailTextValues,
          description: _description,
          contact: _contact,
          updatedAt: DateTime.now().toIso8601String(),
        );

        propertyRentList.insert(0, newModel);
      });

      await x;

      setState(() {
        isUploadingPost = false;
      });

      if (mounted) {
        Navigator.of(context).pop();
      }
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
