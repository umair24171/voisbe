import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/resources/navigation.dart';

class PaymentDetailsScreen extends StatelessWidget {
  const PaymentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          leading: IconButton(
            onPressed: () {
              navPop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: blackColor,
              size: 30,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Payment Details',
            style: TextStyle(
                color: blackColor,
                fontSize: 18,
                fontFamily: khulaBold,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    'assets/icons/Credit card (1).svg',
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Credit Card Details',
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 18,
                        fontFamily: khulaBold,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Card Number*',
                hintStyle: TextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontFamily: khulaRegular,
                    fontWeight: FontWeight.w600),
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.9,
                ),
                contentPadding: const EdgeInsets.all(0).copyWith(left: 14),
                fillColor: whiteColor,
                filled: true,
                border: const OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffC8C8C8)),
                ),
                enabledBorder: const OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffC8C8C8)),
                ),
                focusedBorder: const OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffC8C8C8)),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'MM/YY*',
                    hintStyle: TextStyle(
                        color: blackColor,
                        fontSize: 16,
                        fontFamily: khulaRegular,
                        fontWeight: FontWeight.w600),
                    constraints: BoxConstraints(
                      maxWidth: size.width * 0.3,
                    ),
                    contentPadding: const EdgeInsets.all(0).copyWith(left: 14),
                    fillColor: whiteColor,
                    filled: true,
                    border: const OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffC8C8C8)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffC8C8C8)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffC8C8C8)),
                    ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Security Code*',
                    hintStyle: TextStyle(
                        color: blackColor,
                        fontSize: 16,
                        fontFamily: khulaRegular,
                        fontWeight: FontWeight.w600),
                    constraints: BoxConstraints(
                      maxWidth: size.width * 0.5,
                    ),
                    contentPadding: const EdgeInsets.all(0).copyWith(left: 14),
                    fillColor: whiteColor,
                    filled: true,
                    border: const OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffC8C8C8)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffC8C8C8)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffC8C8C8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    'assets/icons/paypal 1.svg',
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'PayPal Details',
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 18,
                        fontFamily: khulaBold,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Email Address*',
                hintStyle: TextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontFamily: khulaRegular,
                    fontWeight: FontWeight.w600),
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.9,
                ),
                contentPadding: const EdgeInsets.all(0).copyWith(left: 14),
                fillColor: whiteColor,
                filled: true,
                border: const OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffC8C8C8)),
                ),
                enabledBorder: const OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffC8C8C8)),
                ),
                focusedBorder: const OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffC8C8C8)),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontFamily: khulaRegular,
                    fontWeight: FontWeight.w600),
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.9,
                ),
                contentPadding: const EdgeInsets.all(0).copyWith(left: 14),
                fillColor: whiteColor,
                filled: true,
                border: const OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffC8C8C8)),
                ),
                enabledBorder: const OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffC8C8C8)),
                ),
                focusedBorder: const OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffC8C8C8)),
                ),
              ),
            ),
          ],
        ));
  }
}
