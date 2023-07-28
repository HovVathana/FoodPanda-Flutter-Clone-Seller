import 'package:flutter/material.dart';
import 'package:foodpanda_seller/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/widgets/custom_textfield.dart';
import 'package:foodpanda_seller/widgets/ficon_button.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address-screen';
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => AddressScreenState();
}

class AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.678,
              width: double.infinity,
              color: Colors.amber,
              alignment: Alignment.bottomCenter,
              child: Text('map'),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          height: 3,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[300],
                          ),
                          alignment: Alignment.center,
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 25),
                                  const Text(
                                    'Add a new address',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color: scheme.primary,
                                              size: 30,
                                            ),
                                            const SizedBox(width: 20),
                                            const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '320 St 320',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text('Phnom Penh')
                                              ],
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.edit_outlined,
                                          color: scheme.primary,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                15,
                                        padding:
                                            const EdgeInsets.only(right: 7),
                                        child: CustomTextField(
                                          controller: null,
                                          labelText: 'House Number',
                                          // onChanged: (value) {
                                          //   setState(() {
                                          //     firstNameText = value;
                                          //   });
                                          // },
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                15,
                                        padding: const EdgeInsets.only(left: 7),
                                        child: CustomTextField(
                                          controller: null,
                                          labelText: 'Street',
                                          // onChanged: (value) {
                                          //   setState(() {
                                          //     lastNameText = value;
                                          //   });
                                          // },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  CustomTextField(
                                    controller: null,
                                    labelText: 'Area',
                                    // onChanged: (value) {
                                    //   setState(() {
                                    //     emailText = value;
                                    //   });
                                    // },
                                    // errorText: errorEmailText,
                                  ),
                                  const SizedBox(height: 20),
                                  CustomTextField(
                                    controller: null,
                                    labelText: 'Floor/Unit #',
                                    // onChanged: (value) {
                                    //   setState(() {
                                    //     emailText = value;
                                    //   });
                                    // },
                                    // errorText: errorEmailText,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300],
                        ),
                        CustomTextButton(
                          text: 'Continue',
                          onPressed: () {},
                          isDisabled: false,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 20,
              left: 10,
              child: FIconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
