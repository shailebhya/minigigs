// ignore_for_file: unnecessary_new

import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easily/models/gig_model.dart';
import 'package:easily/pages/add_job/add_job_ctrl.dart';
import 'package:easily/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddJob extends StatefulWidget {
  AddJob({Key? key}) : super(key: key);

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  final addJobCtrl = Get.put<AddJobCtrl>(AddJobCtrl());

  @override
  void initState() {
    super.initState();
    addJobCtrl.gigModel = GigModel(images: [], tags: []);
    addJobCtrl.isRemote = false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddJobCtrl>(
        id: addJobId,
        builder: (_) {
          return WillPopScope(
            onWillPop: () async {
              return !_.postingGig;
            },
            child: _.postingGig
                ? Scaffold(
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "i am sending your gig into the cloud🌥,\n please dont close the page🥹",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        CircularProgressIndicator(color: Colors.black)
                      ],
                    ),
                  )
                : Scaffold(
                    appBar: AppBar(
                      title: const Text("create a gig",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                      elevation: 0,
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView(children: [
                        if (_.imageList.isNotEmpty) ...[
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 200,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              reverse: false,
                              autoPlay: false,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              // onPageChanged: callbackFunction,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: _.imageList.map((file) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fitHeight,
                                              image: kIsWeb
                                                  ? NetworkImage(file.path)
                                                      as ImageProvider
                                                  : FileImage(File(file.path))),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 248, 246, 246),
                                                blurRadius: 4,
                                                offset: Offset(0, 3),
                                                spreadRadius: 5),
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          new ClipRect(
                                              child: new BackdropFilter(
                                            filter: new ImageFilter.blur(
                                                sigmaX: 10.0, sigmaY: 10.0),
                                            child: new Container(
                                              width: 40.0,
                                              height: 20.0,
                                              decoration: new BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.grey.shade200
                                                      .withOpacity(0.2)),
                                              child: new Center(
                                                child: new Text(
                                                    '${_.imageList.indexOf(file) + 1}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium),
                                              ),
                                            ),
                                          )),
                                          const SizedBox(
                                            height: 5,
                                          )
                                        ],
                                      ));
                                },
                              );
                            }).toList(),
                          )
                        ],
                        const SizedBox(
                          height: 15,
                        ),
                        _.imageList.isEmpty
                            ? InkWell(
                                onTap: () => _.selectImage(context),
                                child: const Icon(
                                  Icons.add_photo_alternate,
                                  size: 25,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (_.imageList.isNotEmpty) {
                                        _.imageList.removeLast();
                                        _.update([addJobId]);
                                      }
                                    },
                                    child: const Icon(
                                      Icons.remove,
                                      size: 25,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(_.imageList.length.toString()),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                    onTap: () => _.selectImage(context),
                                    child: const Icon(
                                      Icons.add,
                                      size: 25,
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _.titleCtrl,
                          maxLength: 100,
                          minLines: 1,
                          maxLines: 5,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'brief about the gig',
                              fillColor: Colors.red,
                              labelText: 'title\*',
                              labelStyle: TextStyle(color: Colors.black)),
                          onSaved: (String? value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String? value) {
                            return value!.contains('@')
                                ? 'Do not use the @ char.'
                                : null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _.descCtrl,
                          maxLength: 500,
                          minLines: 1,
                          maxLines: 15,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),borderRadius: BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'pls elaborate about the gig',
                              fillColor: Colors.red,
                              hintMaxLines: 2,
                              labelText: 'desc.\*',
                              labelStyle: TextStyle(color: Colors.black)),
                          onSaved: (String? value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String? value) {
                            return value!.contains('@')
                                ? 'Do not use the @ char.'
                                : null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _.locationCtrl,
                          maxLength: 100,
                          minLines: 1,
                          maxLines: 5,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),borderRadius: BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText:
                                  'pls mention your location or a landmark',
                              hintStyle: TextStyle(fontSize: 16),
                              fillColor: Colors.red,
                              hintMaxLines: 2,
                              labelText: 'location.\*',
                              labelStyle: TextStyle(color: Colors.black)),
                          onSaved: (String? value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String? value) {
                            return value!.contains('@')
                                ? 'Do not use the @ char.'
                                : null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _.baseAmtCtrl,
                          maxLength: 5,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'amount you are willing to pay',
                              fillColor: Colors.red,
                              labelText: "base amount in \u{20B9} \*",
                              labelStyle: TextStyle(color: Colors.black)),
                          onSaved: (String? value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String? value) {
                            if (double.tryParse(value ?? "") == null &&
                                value != '') {
                              return "invalid entry";
                            }
                            if (value != null && value.trim() != '') {
                              return double.tryParse(value)! > 10000
                                  ? " \u{20B9} amount should be less than 10000"
                                  : null;
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _.impDataCtrl,
                          maxLength: 300,
                          minLines: 1,
                          maxLines: 5,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),borderRadius: BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText:
                                  "note: this will be visible only to the person who accepts this gig. eg: phone number,etc.",
                              hintStyle: TextStyle(fontSize: 13),
                              fillColor: Colors.red,
                              hintMaxLines: 2,
                              labelText: 'imp data.',
                              labelStyle: TextStyle(color: Colors.black)),
                          onSaved: (String? value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String? value) {
                            return value!.contains('@')
                                ? 'Do not use the @ char.'
                                : null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GetBuilder<AddJobCtrl>(
                            id: deadlineSelectId,
                            builder: (_) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "set deadline\* :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black)),
                                      child: Text(
                                          '${_.dateTime.day}/${_.dateTime.month}/${_.dateTime.year} ${_.dateTime.hour}:${_.dateTime.minute}'),
                                      onPressed: () => _.pickDateTime(context)),
                                ],
                              );
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        GetBuilder<AddJobCtrl>(
                            id: selectCityId,
                            builder: (_) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "select city\* :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: DropdownSearch<String>(
                                        popupElevation: 5,
                                        mode: Mode.DIALOG,
                                        // showSelectedItem: true,
                                        items: _.cities,
                                        showSearchBox: true,
                                        dropdownSearchDecoration:
                                            const InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black))),
                                        // popupItemDisabled: (String s) => s.startsWith('I'),
                                        onChanged: (String? s) =>
                                            _.selectedCityIndex =
                                                _.cities.indexOf(s ?? ''),
                                        selectedItem: "Brazil"),
                                  ),
                                ],
                              );
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        GetBuilder<AddJobCtrl>(
                            id: selectCityId,
                            builder: (_) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "select type :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: DropdownSearch<String>(
                                        popupElevation: 5,
                                        mode: Mode.DIALOG,
                                        // showSelectedItem: true,
                                        items: _.typeWork,
                                        showSearchBox: true,
                                        dropdownSearchDecoration:
                                            const InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black))),
                                        // popupItemDisabled: (String s) => s.startsWith('I'),
                                        onChanged: (String? s) =>
                                            _.selectedTypeOfIndex =
                                                _.typeWork.indexOf(s ?? ''),
                                        selectedItem: "misscl."),
                                  ),
                                ],
                              );
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        GetBuilder<AddJobCtrl>(
                            id: selectCityId,
                            builder: (_) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "is remote :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Switch(
                                    activeColor: Colors.black,
                                    onChanged: ((value) {
                                      _.isRemote = !_.isRemote;
                                      debugPrint(_.isRemote.toString());
                                      _.update([selectCityId]);
                                    }),
                                    value: _.isRemote,
                                  ),
                                ],
                              );
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: true, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const SelectableText(
                                    'shall we post the gig? ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: const <Widget>[
                                        SelectableText(
                                            '"you wont be able to edit it later🙂"'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        style: TextButton.styleFrom(
                                          primary: const Color.fromARGB(
                                              255, 250, 168, 198),
                                        ),
                                        child: const Text(
                                          'yeah, post it😃',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 119, 190, 248)),
                                        ),
                                        onPressed: () async {
                                          Get.back();
                                          _.homeCtrl.authCtrl.user.id == null
                                              ? Get.snackbar(
                                                  "auth error",
                                                  "please login and try!",
                                                )
                                              : _.addJob();
                                        }),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Center(
                                    child: Text(
                                  "post gig",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )),
                              )),
                        ),
                      ]),
                    ),
                  ),
          );
        });
  }
}
