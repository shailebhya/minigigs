import 'package:dio/dio.dart';
import 'package:easily/models/gig_model.dart';
import 'package:easily/models/user_model.dart';
import 'package:easily/pages/homepage/home_ctrl.dart';
import 'package:easily/services/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddJobCtrl extends GetxController {
  //Text editing contrõller
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController impDataCtrl = TextEditingController();
  TextEditingController baseAmtCtrl = TextEditingController();
  TextEditingController locationCtrl = TextEditingController();
  bool isRemote = false;
  int selectedCityIndex = 0;
  int selectedTypeOfIndex = 0;
  FirebaseStorage storage = FirebaseStorage.instance;
  List<XFile> imageList = [];
  XFile? file;
  final homePageCtrl = Get.find<HomeCtrl>();

  List<String> typeWork = [
    "delivery",
    "misscl.",
    "print out",
    'online',
    "delivery",
    "missclenous",
    "print out",
    'online',
    "pickup",
    "quick",
    "urgent",
    '5min',
  ];
  bool postingGig = false;
  //text editing controller end here
  GigModel gigModel = GigModel(images: [], tags: []);
  final homeCtrl = Get.find<HomeCtrl>();
  DateTime dateTime = DateTime.now();
  final hours = DateTime.now().hour.toString().padLeft(2, '0');
  final minutes = DateTime.now().minute.toString().padLeft(2, '0');
  Dio dio = Dio();

  Future addJob() async {
    if (checkData()) {
      postingGig = true;
      update([addJobId]);
      await collectData();
      await getProductImagesUrl();
      await createGig();
      postingGig = false;
    }
  }

  createGig() async {
    debugPrint("in create Gig");
    String apiUrl = "$baseUrl/gigs/createGig";
    debugPrint(apiUrl);
    debugPrint(gigModel.toJson().toString());
    try {
      var response = await dio.post(apiUrl, data: gigModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('response status : 200');
        Get.back();
        Get.snackbar("success!!", 'your gig was successfully posted!,');
        homeCtrl.getGigs(homeCtrl.cities[selectedCityIndex]);
        // return response;
      } else {
        Get.back();
        Get.snackbar("sorryy!!", 'some error occured!😭, please try again');
      }
    } catch (e) {
      Get.back();
      Get.snackbar("sorryy!!", 'some error occured!😭, please try again');
      // debugPrint('error while creating user db: ${e.toString()}');
    }
  }

  bool checkData() {
    if (titleCtrl.text.isEmpty ||
        descCtrl.text.isEmpty ||
        !baseAmtCtrl.text.isNumericOnly ||int.parse(baseAmtCtrl.text)>10000||
        locationCtrl.text.isEmpty) {
      Get.snackbar(
        "hmmmm..",
        "please fill the required fields appropriately.",
      );
      return false;
    }
    return true;
  }

  collectData() {
    gigModel.paymentDone = false;
    gigModel.isRemote = isRemote;
    gigModel.title = titleCtrl.text;
    gigModel.description = descCtrl.text;
    gigModel.impData = impDataCtrl.text;
    gigModel.baseAmount = double.parse(baseAmtCtrl.text);
    gigModel.location = locationCtrl.text;
    gigModel.createdBy = homeCtrl.authCtrl.user;
    gigModel.createdAt = DateTime.now().toString();
    gigModel.deadline = dateTime.toString();
    gigModel.acceptedBy = UserModel();
    gigModel.city = homeCtrl.cities[selectedCityIndex];
    gigModel.type = typeWork[selectedTypeOfIndex];
  }

  handleTakePhoto() async {
    Get.back();
    final uploadedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (uploadedFile != null) {
      file = XFile(uploadedFile.path);
      addImages();
    }
  }

  handleChooseFromGallery() async {
    Get.back();
    final uploadedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (uploadedFile != null) {
      file = XFile(uploadedFile.path);
      addImages();
    }
  }

  addImages() {
    if (file != null) {
      imageList.add(file!);
      update([addJobId]);
    }
  }

  selectImage(parentContext) {
    print("inside select image");
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              'Upload Image',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.amber.shade200,
                ),
              ),
              SimpleDialogOption(
                child: const Text(
                  'Camera',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () => handleTakePhoto(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.amber.shade200,
                ),
              ),
              SimpleDialogOption(
                child: const Text(
                  'Gallery',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () => handleChooseFromGallery(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.amber.shade200,
                ),
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red.shade500, fontSize: 16),
                ),
                onPressed: () => Get.back(),
              )
            ],
          );
        });
  }

  Future getProductImagesUrl() async {
    String imgId = const Uuid().v4();
    gigModel.imagesId = imgId;
    for (int i = 0; i < imageList.length; i++) {
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': imageList[i].path},
      );
      if (!kIsWeb) {
        TaskSnapshot uploadImage = await storage
            .ref()
            .child("productImages/${homeCtrl.authCtrl.user.id}+$imgId+$i.png")
            .putData(await imageList[i].readAsBytes(), metadata);
        if (uploadImage.state == TaskState.success) {
          String downloadUrl = await uploadImage.ref.getDownloadURL();
          debugPrint(downloadUrl);
          gigModel.images!.add(downloadUrl);
        }
      } else {
        TaskSnapshot uploadImage = await storage
            .ref()
            .child("productImages/${homeCtrl.authCtrl.user.id}+$imgId+$i.png")
            .putData(await imageList[i].readAsBytes(), metadata);

        if (uploadImage.state == TaskState.success) {
          String downloadUrl = await uploadImage.ref.getDownloadURL();
          debugPrint(downloadUrl);
          gigModel.images!.add(downloadUrl);
        }
      }
    }
  }

  Future<DateTime?> pickDate(context) => showDatePicker(
      builder: ((context, child) =>
          Theme(data: ThemeData.dark(), child: child!)),
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime(context) => showTimePicker(
      builder: ((context, child) =>
          Theme(data: ThemeData.dark(), child: child!)),
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
  Future pickDateTime(context) async {
    DateTime? date = await pickDate(context);
    if (date == null) return;
    TimeOfDay? time = await pickTime(context);
    if (time == null) return;
    final dateTime1 =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    dateTime = dateTime1;
    print(dateTime);
    update([deadlineSelectId]);
  }
}
