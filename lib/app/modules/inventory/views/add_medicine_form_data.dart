import 'package:flutter/material.dart';

class AddUnitFormData {
  final int level;
  final TextEditingController nameController;
  final TextEditingController factorController;
  final TextEditingController buyPriceController;
  final TextEditingController sellPriceController;
  final TextEditingController oldPriceController;
  final TextEditingController quantityController;
  final TextEditingController minStockController;
  final TextEditingController discountController;
  bool allowSale = true;

  AddUnitFormData({
    required String name,
    required this.level,
    String factor = '10',
    String buyPrice = '0',
    String sellPrice = '0',
    String oldPrice = '',
    String quantity = '0',
    String minStock = '10',
    String discount = '',
  }) : nameController = TextEditingController(text: name),
       factorController = TextEditingController(text: factor),
       buyPriceController = TextEditingController(text: buyPrice),
       sellPriceController = TextEditingController(text: sellPrice),
       oldPriceController = TextEditingController(text: oldPrice),
       quantityController = TextEditingController(text: quantity),
       minStockController = TextEditingController(text: minStock),
       discountController = TextEditingController(text: discount);

  void dispose() {
    nameController.dispose();
    factorController.dispose();
    buyPriceController.dispose();
    sellPriceController.dispose();
    oldPriceController.dispose();
    quantityController.dispose();
    minStockController.dispose();
    discountController.dispose();
  }
}


