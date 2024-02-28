import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void _showSuccesModal(context) {
  AwesomeDialog(
    context: context,
    animType: AnimType.leftSlide,
    headerAnimationLoop: false,
    dialogType: DialogType.success,
    showCloseIcon: true,
    title: 'Succes',
    desc:
        'Dialog description here..................................................',
    btnOkOnPress: () {
      debugPrint('OnClcik');
    },
    btnOkIcon: Icons.check_circle,
    onDismissCallback: (type) {
      debugPrint('Dialog Dissmiss from callback $type');
    },
  ).show();
}
