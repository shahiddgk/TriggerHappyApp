
import 'package:flutter/cupertino.dart';

import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';
import '../../../Widgets/option_mcq_widget.dart';

// ignore: must_be_immutable
class SaveButtonWidgets extends StatefulWidget {
  SaveButtonWidgets(this.onTap,{Key? key}) : super(key: key);
  Function onTap;
  @override
  // ignore: library_private_types_in_public_api
  _SaveButtonWidgetsState createState() => _SaveButtonWidgetsState();
}

class _SaveButtonWidgetsState extends State<SaveButtonWidgets> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

       widget.onTap();

      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10),
        child: OptionMcqAnswer(
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                // SizedBox(
                //     height: 40,
                //     width: 40,
                //     child: Image.asset("assets/add.png",)),
                Text("Save",style: TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.headingFontSize),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
