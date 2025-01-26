import 'package:auto_size_text/auto_size_text.dart';
import 'package:emonitor/utils/component.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 100),
          child: Container(
            decoration: BoxDecoration(
                color: white, 
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), color: blue),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 44,
                        vertical: 40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: ListTile(
                              leading: Icon(
                                Icons.check_box,
                                color: white,
                              ),
                              title: AutoSizeText(
                                "UnitNest",
                                style: TextStyle(
                                    fontSize: h2,
                                    fontWeight: FontWeight.w600,
                                    color: white),
                              ),
                            ),
                          ),
                          // const SizedBox(height: 38,),
                          Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    "Start your journey ",
                                    style: TextStyle(
                                      fontSize: h, 
                                      fontWeight: FontWeight.w600,
                                      color: white,
                                    ),
                                    maxLines: 1,
                                  ),
                                  AutoSizeText(
                                    "with us",
                                    style: TextStyle(
                                      fontSize: h, 
                                      fontWeight: FontWeight.w600,
                                      color: white,
                                    ),
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 10), // Add spacing between texts
                                  AutoSizeText(
                                    "Redefine Rental Management – Stress Less, Earn \nMore",
                                    style: TextStyle(
                                      fontSize: p1, // Smaller font size for this part
                                      color: grey, // Color for this part
                                    ),
                                    maxLines: 2,
                                  ),
                                ],
                              )),
                          // const SizedBox(height: 10,),

                          // const SizedBox(height: 100,),
                          Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(80, 244, 244, 244),
                                    borderRadius: BorderRadius.circular(8)),
                              ))
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(child: Container(
                    child: Padding(padding: EdgeInsets.symmetric(
                      horizontal: 72,
                      vertical: 40
                    ),child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [ 

                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          AutoSizeText(
                                    "Create an account ",
                                    style: TextStyle(
                                      fontSize: h, 
                                      fontWeight: FontWeight.w600,
                                      color: black,
                                    ),
                                    maxLines: 1,
                                  ),
                          Row(children: [
                             AutoSizeText(
                                    "Already have account?",
                                    style: TextStyle(
                                      fontSize: p1, 
                                      color: darkGrey,
                                    ),
                                    maxLines: 1,
                                  ),
                                  AutoSizeText(
                                    " Log in",
                                    style: TextStyle(
                                      fontSize: p1, 
                                      color: blue,
                                    ),
                                    maxLines: 1,
                                  ),
                          ],)
                        ],)
                      ],
                      ),
                    )
                  ))
                ],
              ),
            ),
          ),
        ));
  }
}
