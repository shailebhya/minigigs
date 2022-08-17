import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HistoryItemView extends StatelessWidget {
  const HistoryItemView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(
          "Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: ListView(children: [
            if (true) ...[
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  // onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                ),
                items: [1, 2, 3, 4, 5].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: NetworkImage(
                                      "https://images.sadhguru.org/d/46272/1643611785-sadhguru-mahabhart-74.jpg")),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(255, 248, 246, 246),
                                    blurRadius: 4,
                                    offset: Offset(0, 3),
                                    spreadRadius: 5),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              new ClipRect(
                                  child: new BackdropFilter(
                                filter: new ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: new Container(
                                  width: 40.0,
                                  height: 20.0,
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey.shade200
                                          .withOpacity(0.2)),
                                  child: new Center(
                                    child: new Text('$i',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ),
                                ),
                              )),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ));
                    },
                  );
                }).toList(),
              )
            ],
            SizedBox(
              height: 20,
            ),
            Text(
              "Brands.Cop Landing Page idea ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            SizedBox(
              height: 10,
            ),

            SizedBox(
              height: 15,
            ),
            //
            //
            //
            //
            //************show only if  this was the client************* */
            //
            //
            //
            //
            //
            //

            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 227, 224, 227),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("more info :",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Lorem ipsum dolor sit amet. Et quas quia qui nisi enim nam temporibus sequi et sunt eveniet ut saepe autem nam ducimus aperiam. Ab dolore laboriosam eos fugiat galisum qui necessitatibus molestiae est iste minima est galisum saepe aut consequuntur voluptate hic expedita eaque. Qui rerum reiciendis sit voluptatem veniam cum galisum porro quo iste perspiciatis qui asperiores animi est fuga aliquid.",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),

            //
            //
            //
            //
            //************dont show imp info if user didnt create the order ************* */
            //
            //
            //
            //
            //
            //
            true
                ? SizedBox()
                : Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 227, 224, 227),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("imp data :",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Lorem ipsum dolor sit amet. Et quas quia qui nisi enim nam temporibus sequi et sunt eveniet ut saepe autem nam ducimus aperiam. Ab dolore laboriosam eos fugiat galisum qui necessitatibus molestiae est iste minima est galisum saepe aut consequuntur voluptate hic expedita eaque. Qui rerum reiciendis sit voluptatem veniam cum galisum porro quo iste perspiciatis qui asperiores animi est fuga aliquid.",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        )),
                  ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text("created by: "),
                Text(
                  'username',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("you earned: "),
                Text(
                  '\u{20B9}' + "100",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("city: "),
                Text(
                  "jamshedpur",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("created at: "),
                Text(
                  "18th Dec 20:30",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("due at: "),
                Text(
                  "18th Dec 20:30",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("location: "),
                Expanded(
                    child: Text("Manipal Institute Of Technology",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("type: "),
                Text(
                  "misscleaneous",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ]),
        ),
      ),
    );
  }
}
