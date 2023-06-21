import 'package:flutter/material.dart';

import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';
import '../../Payment/payment_screen.dart';

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
        // ignore: avoid_print
        print(widget.isAllow);
        !widget.isAllow ? widget.onTap() : Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
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
