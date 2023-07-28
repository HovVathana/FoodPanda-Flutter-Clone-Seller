import 'package:flutter/material.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/foods/widgets/text_tag.dart';

class CustomizePreview extends StatefulWidget {
  final String title;
  final bool isRequired;
  final bool isRadio;
  final bool isVariation;
  final int selectAmount;
  final List<String> listChoiceText;
  final List<double> listPriceText;
  const CustomizePreview({
    super.key,
    required this.title,
    required this.isRequired,
    required this.listChoiceText,
    required this.listPriceText,
    required this.isRadio,
    required this.selectAmount,
    required this.isVariation,
  });

  @override
  State<CustomizePreview> createState() => _CustomizePreviewState();
}

class _CustomizePreviewState extends State<CustomizePreview> {
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            widget.isRequired ? scheme.primary.withOpacity(0.05) : Colors.white,
        border: Border.all(
            color: widget.isRequired ? Colors.grey[300]! : Colors.transparent),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 20, horizontal: widget.isRequired ? 15 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.isVariation
                      ? 'Variation'
                      : 'Choice of ${widget.title}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                widget.isRequired
                    ? TextTag(
                        text: 'Required',
                        backgroundColor: scheme.primary,
                        textColor: Colors.white,
                      )
                    : TextTag(
                        text: 'Optional',
                        backgroundColor: Colors.grey[300]!,
                        textColor: Colors.grey[600]!,
                      ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              widget.isRequired
                  ? 'Select one'
                  : 'Select ${widget.selectAmount}',
              style: TextStyle(
                fontSize: 14,
                color: widget.isRequired ? scheme.primary : Colors.grey[500],
                fontWeight: FontWeight.w700,
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.listChoiceText.length,
              itemBuilder: (context, index) {
                bool isSelected = true;
                return widget.isRadio
                    ? ListTile(
                        title: Text(widget.listChoiceText[index]),
                        leading: Radio(
                          activeColor: scheme.primary,
                          value: index,
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = index;
                            });
                          },
                        ),
                        trailing: Text(
                          widget.listPriceText[index] != 0.0
                              ? widget.isVariation
                                  ? '\$ ${widget.listPriceText[index]}'
                                  : '+ \$ ${widget.listPriceText[index]}'
                              : 'Free',
                        ),
                      )
                    : ListTile(
                        title: Text(widget.listChoiceText[index]),
                        leading: Checkbox(
                          activeColor: scheme.primary,
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isSelected = !isSelected;
                            });
                          },
                        ),
                        trailing: Text(
                          widget.listPriceText[index] != 0.0
                              ? widget.isVariation
                                  ? '\$ ${widget.listPriceText[index]}'
                                  : '+ \$ ${widget.listPriceText[index]}'
                              : 'Free',
                        ),
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
