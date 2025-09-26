import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common_widget/common_button.dart';
import '../../../core/res/colors.dart';

class EbadgeMemberScreen extends StatefulWidget {
  const EbadgeMemberScreen({super.key});

  @override
  State<EbadgeMemberScreen> createState() => _EbadgeMemberScreenState();
}

class _EbadgeMemberScreenState extends State<EbadgeMemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("E-Badge", style: TextStyle(color: AppColor.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xffFFD66A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          "https://img.freepik.com/premium-photo/happy-man-ai-generated-portrait-user-profile_1119669-1.jpg",
                          height: 145,
                          width: 145,
                        ),
                        SizedBox(width: 10,),
                        Expanded (
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(color: Color(0xffC4FFC6),borderRadius: BorderRadius.circular(50)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Approved",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Container(
                                decoration: BoxDecoration(color: Color(0xffFFC000),borderRadius: BorderRadius.circular(50)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("GF25-TV20097",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                                ),
                              ),
                              SizedBox(height: 8,),
                              CommonButton(
                                text: "Download",
                                onPressed: () {
                                  print("CLICKED E-BADGE");
                                },
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 2,horizontal: 0),
                                prefixIcon: Image.asset('assets/downloadIcon.png',scale: 2,color: AppColor.white,),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text("Jonathan Emmanuel Rodriguez",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 24),),
                    SizedBox(height: 8,),
                    Text("WEB TEST, Chairman",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                    SizedBox(height: 8,),
                    Text("GSTN 44AAAAA0000A1Z1",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 10,),
                        Text("+91 955 123 5689 / 044 1234 1234",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                      ],
                    ),

                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.mail),
                        SizedBox(width: 10,),
                        Text("mohanguru.ue@gmail.com",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                      ],
                    ),


                    SizedBox(height: 8,),
                    Row(
                      children: [
                        Icon(Icons.location_on_sharp),
                        SizedBox(width: 10,),
                        Expanded (child: Text("Rajendra complex ( opposite to Jain temple ) Mandapala street, Nellore",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Text(
              "Call us for immediate assistance",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xff151515),
              ),
            ),
            SizedBox(height: 16,),
            Row(
              children: [
                Expanded(
                  child: CommonButton(
                    text: "Contact Us",
                    onPressed: () {},
                    fillColor: Color(0xff9ABFE4),
                    textColor: Color(0xff183362),
                    prefixIcon: SvgPicture.asset("assets/call.svg"),
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: CommonButton(
                    text: "Whatsapp",
                    onPressed: () {},
                    fillColor: Color(0xff9AE4A0),
                    textColor: Color(0xff0D5F14),
                    prefixIcon: SvgPicture.asset("assets/whatsapp.svg"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
