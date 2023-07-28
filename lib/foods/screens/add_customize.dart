import 'package:flutter/material.dart';
import 'package:foodpanda_seller/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/foods/controllers/food_controller.dart';
import 'package:foodpanda_seller/foods/widgets/choice_price.dart';
import 'package:foodpanda_seller/foods/widgets/customize_preview.dart';
import 'package:foodpanda_seller/models/customize.dart';
import 'package:foodpanda_seller/widgets/custom_textfield.dart';
import 'package:foodpanda_seller/widgets/ficon_button.dart';
import 'package:foodpanda_seller/widgets/my_snack_bar.dart';

class AddCustomizationScreen extends StatefulWidget {
  final String categoryId;
  final String foodId;

  static const String routeName = '/add-customization-screen';

  const AddCustomizationScreen({
    super.key,
    required this.categoryId,
    required this.foodId,
  });

  @override
  State<AddCustomizationScreen> createState() => _AddCustomizationScreenState();
}

class _AddCustomizationScreenState extends State<AddCustomizationScreen> {
  FoodController foodController = FoodController();

  TextEditingController titleController = TextEditingController();

  List<TextEditingController> listChoiceController = [TextEditingController()];
  List<TextEditingController> listPriceController = [TextEditingController()];

  List<String> listChoiceText = [''];
  List<double> listPriceText = [0];

  String titleText = '';

  bool isRequired = true;
  bool isRadio = true;
  bool isVariation = false;

  int selectAmount = 1;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  handleAddCategory() async {
    List<Choice> choices = [];
    for (int i = 0; i < listChoiceController.length; i++) {
      if (listChoiceController[i].text.isEmpty) {
        openSnackbar(context, 'Please fill in the empty field or remove it.',
            scheme.primary);
        return;
      }
      Choice choice = Choice(
        choice: listChoiceController[i].text.trim().toString(),
        price: listPriceController[i].text != ''
            ? double.parse(listPriceController[i].text)
            : 0.0,
      );
      choices.add(choice);
    }
    Customize customize = Customize(
      title: titleController.text.trim().toString(),
      isRequired: isRequired,
      isRadio: isRadio,
      isVariation: isVariation,
      selectAmount: isRadio ? 1 : selectAmount,
      choices: choices,
    );

    await foodController.addCustomize(
      categoryId: widget.categoryId,
      foodId: widget.foodId,
      customize: customize,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Add Customize',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: titleText.isEmpty ||
                    listChoiceText.isEmpty ||
                    (listChoiceText.isNotEmpty && listChoiceText[0].isEmpty)
                ? null
                : handleAddCategory,
            icon: Icon(
              Icons.check,
              color: titleText.isEmpty ||
                      listChoiceText.isEmpty ||
                      (listChoiceText.isNotEmpty && listChoiceText[0].isEmpty)
                  ? Colors.grey[400]
                  : Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Add Customize',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Choice of ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Switch(
                          value: isVariation,
                          activeColor: scheme.primary,
                          onChanged: (value) {
                            setState(() {
                              isVariation = value;
                            });
                          },
                        ),
                        const Text(
                          'Variation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '* "Choice of" will use the price set before as the starting price and each choice price will be treat as additional.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '* "Variation" will use the price set for each choice as the starting price',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              CustomTextField(
                                controller: titleController,
                                labelText: 'Title',
                                onChanged: (value) {
                                  setState(
                                    () {
                                      titleText = value;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Switch(
                              value: isRequired,
                              activeColor: scheme.primary,
                              onChanged: (value) {
                                setState(() {
                                  isRequired = value;
                                });
                              },
                            ),
                            const Text(
                              'Required',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add choices',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              listChoiceController.add(TextEditingController());
                              listPriceController.add(TextEditingController());

                              listChoiceText.add('');
                              listPriceText.add(0);
                            });
                          },
                          icon: Icon(
                            Icons.add,
                            color: scheme.primary,
                          ),
                        )
                      ],
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listChoiceController.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ChoicePrice(
                            choiceController: listChoiceController[index],
                            priceController: listPriceController[index],
                            onDelete: () {
                              setState(() {
                                listChoiceController[index].clear();
                                listChoiceController[index].dispose();
                                listChoiceController.removeAt(index);

                                listChoiceText.removeAt(index);

                                listPriceController[index].clear();
                                listPriceController[index].dispose();
                                listPriceController.removeAt(index);

                                listPriceText.removeAt(index);
                              });
                            },
                            // isRequired: isRequired,
                            choiceFn: (value) {
                              setState(() {
                                listChoiceText[index] = value;
                              });
                            },
                            priceFn: (value) {
                              setState(() {
                                listPriceText[index] =
                                    value.isEmpty ? 0 : double.parse(value);
                              });
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Checkbox',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Switch(
                              value: isRadio,
                              activeColor: scheme.primary,
                              onChanged: (value) {
                                setState(() {
                                  isRadio = value;
                                });
                              },
                            ),
                            const Text(
                              'Radio',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        isRadio
                            ? const Text(
                                'Can select 1',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )
                            : Row(
                                children: [
                                  const Text(
                                    'Can select ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  FIconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      if (selectAmount > 0) {
                                        setState(() {
                                          selectAmount--;
                                        });
                                      }
                                    },
                                  ),
                                  Text(
                                    '$selectAmount',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  FIconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      if (selectAmount <
                                          listChoiceController.length) {
                                        setState(() {
                                          selectAmount++;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              )
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Preview',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomizePreview(
                      title: titleText,
                      isRequired: isRequired,
                      isRadio: isRadio,
                      isVariation: isVariation,
                      selectAmount: isRadio ? 0 : selectAmount,
                      listChoiceText: listChoiceText,
                      listPriceText: listPriceText,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            CustomTextButton(
              text: 'Add more',
              onPressed: handleAddCategory,
              isDisabled: titleText.isEmpty ||
                  listChoiceText.isEmpty ||
                  (listChoiceText.isNotEmpty && listChoiceText[0].isEmpty),
            ),
          ],
        ),
      ),
    );
  }
}
