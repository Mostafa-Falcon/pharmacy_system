import 'package:flutter/widgets.dart';

class RowFocusNodes {
  final FocusNode nameNode;
  final FocusNode unitNode;
  final FocusNode quantityNode;
  final FocusNode discountNode;
  final FocusNode priceNode;
  final FocusNode deleteNode;

  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController discountController;

  RowFocusNodes()
      : nameNode = FocusNode(),
        unitNode = FocusNode(),
        quantityNode = FocusNode(),
        discountNode = FocusNode(),
        priceNode = FocusNode(),
        deleteNode = FocusNode(),
        quantityController = TextEditingController(text: '1'),
        priceController = TextEditingController(text: '0.0'),
        discountController = TextEditingController(text: '0.0');

  void dispose() {
    nameNode.dispose();
    unitNode.dispose();
    quantityNode.dispose();
    discountNode.dispose();
    priceNode.dispose();
    deleteNode.dispose();
    quantityController.dispose();
    priceController.dispose();
    discountController.dispose();
  }
}
