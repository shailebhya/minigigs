import 'package:easily/pages/homepage/home_ctrl.dart';
import 'package:easily/pages/profile2/review_card.dart';
import 'package:easily/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class Profile2 extends StatefulWidget {
  String id;
  Profile2(this.id,{Key? key}) : super(key: key);

  @override
  State<Profile2> createState() => _Profile2State();
}

class _Profile2State extends State<Profile2> {
  @override
  void initState() {
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeCtrl>(
        id:profile2id ,
        builder: (_) {
          return ListView(children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 50,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "shailebhya",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Text(
                  "joined 6 months ago",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      '4.25/5',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "150 reviews",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "ratings & reviews",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              const  SizedBox(
                  height: 10,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 7.0),
                      child: ReviewCard(),
                    );
                  }),
            )
          ]);
        }
      ),
    );
  }
}
