import 'package:flutter/widgets.dart';

class RowFocusNodes {
  final FocusNode nameNode = FocusNode();
  final FocusNode unitNode = FocusNode();
  final FocusNode quantityNode = FocusNode();
  final FocusNode deleteNode = FocusNode();
  final TextEditingController quantityController = TextEditingController();

  void dispose() {
    nameNode.dispose();
    unitNode.dispose();
    quantityNode.dispose();
    deleteNode.dispose();
    quantityController.dispose();
  }
}
