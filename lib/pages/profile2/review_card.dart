import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container( decoration: BoxDecoration(boxShadow:const [
        BoxShadow(
            color: Color.fromARGB(255, 248, 246, 246),
            blurRadius: 4,
            offset: Offset(0, 3),
            spreadRadius: 5),
      ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 15,
                  ),
                  SizedBox(width:4,),
                  Text(
                    "shailebhya",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
                                          Text('reviewed on 22.09.2001',style: TextStyle(fontSize: 10),),

            ],
          ),
        RatingBarIndicator(
    rating: 2.5,
    itemBuilder: (context, index) => Icon(
           Icons.star,
           color: Colors.amber,
    ),
    itemCount: 5,
    itemSize: 20.0,
    direction: Axis.horizontal,
),
          SizedBox(height: 3,)
,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:5.0),
            child: Text("well yoyu wont pity becouse you coud",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:5.0),
            child: Text(
              "closer inspection, the mouse had been misaligned at the factory and the top and bottom pieces of the mouse body were not aligned correctly. I watched a video on YouTube for this mouse as to how to disassemble and reassemble",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
          SizedBox(height: 3,)
,        Padding(
            padding: const EdgeInsets.symmetric(horizontal:5.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Row(
                children: [
                  Icon(Icons.favorite,color: Colors.red,size: 17,),
                        SizedBox(width: 2,),
                              Text('229+ people like this',style: TextStyle(fontSize: 10),),
                ],
              ),
                          Row(
                            children: [
                                                          Text('report',style: TextStyle(fontSize: 10),),
SizedBox(width: 2,),
                              Icon(Icons.report_gmailerrorred,color: Colors.red,size: 15,),
                            ],
                          )

                    ],),
          ),
          SizedBox(height: 10,)
        ]),
      ),

    );
  }
}
