import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';

// ignore: must_be_immutable
class PriviousNextButtonWidget extends StatefulWidget {
   PriviousNextButtonWidget(this.onTapNext,this.onTapPrivious,this.visibility,{Key? key}) : super(key: key);

  Function onTapNext;
   Function onTapPrivious;
  bool visibility;

  @override
  _PriviousNextButtonWidgetState createState() => _PriviousNextButtonWidgetState();
}

class _PriviousNextButtonWidgetState extends State<PriviousNextButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height/10,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const Divider(color: AppColors.PrimaryColor,thickness: 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Visibility(
                  visible: widget.visibility,
                  child: Expanded(child: Container(
                    margin:const EdgeInsets.symmetric(horizontal: 3),
                    child: OptionMcqAnswer(
                        TextButton(
                          onPressed: () {
                            widget.onTapPrivious();
                        }, child: const Text("Previous",style: TextStyle(color: AppColors.textWhiteColor)),)
                    ),
                  )),
                ),
                Expanded(
                    child: Container(
                      margin:const EdgeInsets.symmetric(horizontal: 3),
                      child: OptionMcqAnswer(
                      TextButton(onPressed: () { widget.onTapNext(); }, child: const Text("Next",style: TextStyle(color: AppColors.textWhiteColor)),)
                ),
                    )),
              ],
            )
          ],
        )
    );
  }
}
