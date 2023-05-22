import 'package:flutter/cupertino.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';

import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';

// ignore: must_be_immutable
class AddButton extends StatefulWidget {
  AddButton(this.isAllow,this.onTap,{Key? key}) : super(key: key);
 Function onTap;
 bool isAllow;
  @override
  // ignore: library_private_types_in_public_api
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        !widget.isAllow ? widget.onTap() : showToastMessage(context, "Please upadate your plane", false);
      },
      child: Container(
        margin:const EdgeInsets.only(right: 10,bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
                height: 20,
                width: 20,
                child: Image.asset("assets/add.png",)),
            const SizedBox(width: 5,),
            const Text("Add",style: TextStyle(fontSize: AppConstants.defaultFontSize,color: AppColors.primaryColor),)
          ],
        ),
      ),
    );
  }
}
