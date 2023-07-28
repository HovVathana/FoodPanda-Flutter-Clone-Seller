import 'package:flutter/material.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/widgets/custom_textfield.dart';

class ChoicePrice extends StatelessWidget {
  final TextEditingController choiceController;
  final TextEditingController priceController;
  final VoidCallback onDelete;
  // final bool isRequired;
  final Function(String) choiceFn;
  final Function(String) priceFn;

  const ChoicePrice({
    super.key,
    required this.choiceController,
    required this.priceController,
    required this.onDelete,
    // required this.isRequired,
    required this.choiceFn,
    required this.priceFn,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(right: 7),
            child: CustomTextField(
              controller: choiceController,
              labelText: 'Choice',
              onChanged: choiceFn,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3 - 15,
          padding: const EdgeInsets.only(left: 7),
          child: CustomTextField(
            controller: priceController,
            labelText: 'Price',
            isNumPad: true,
            onChanged: priceFn,
          ),
        ),
        IconButton(
          onPressed: onDelete,
          icon: Icon(
            Icons.delete_outline,
            color: scheme.primary,
          ),
        )
      ],
    );
  }
}
