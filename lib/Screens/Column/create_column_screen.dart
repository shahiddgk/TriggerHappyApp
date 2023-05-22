import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quiz_app/Screens/Column/Widgets/date_picker_field_for_column.dart';
import 'package:flutter_quiz_app/Screens/Column/Widgets/text_field_widet.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/model/request_model/session_entry_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../utill/userConstants.dart';

class CreateColumnScreen extends StatefulWidget {
  const CreateColumnScreen({Key? key}) : super(key: key);

  @override
  _CreateColumnScreenState createState() => _CreateColumnScreenState();
}
class _CreateColumnScreenState extends State<CreateColumnScreen> {

  String name = "";
  String id = "";
  // ignore: prefer_final_fields
  bool _isUserDataLoading = true;
  String email = "";
  String timeZone = "";
  String userType = "";
  // ignore: prefer_final_fields
  bool _isLoading = false;
  // ignore: prefer_final_fields
  bool _isDataLoading = false;
  late bool isPhone;
  final FocusNode _focusNode = FocusNode();

  int selectedRadio = 1;


  // final QuillController  _controller = QuillController.basic(
  // );


  TextEditingController titleController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController takeAwaysController = new TextEditingController();

  String _prevText = '';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue
      ) {
    final lines = newValue.text.split('\n');
    final formatted = lines.map((line) {
      if (line.trim().isEmpty) {
        return line;
      }
      if (line.startsWith('• ')) {
        return line;
      }
      return '• $line';
    }).join('\n');
    _prevText = formatted;
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }

  @override
  TextEditingValue? formatEditUpdateWithSelection(
      TextEditingValue? oldValue,
      TextEditingValue newValue
      ) {
    return formatEditUpdate(oldValue!, newValue);
  }

  @override
  void initState() {
    // TODO: implement initState
    //_controller.formatSelection(Attribute.ul);
   // _controller.formatSelection(Attribute.clone(Attribute.ul, Attribute.ul));
    _getUserData();
    super.initState();
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // ignore: avoid_print
    print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;


    setState(() {
      _isUserDataLoading = false;
    });
  }

  setSelectedRadio(int val) {
    // print(val);
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Platform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios),
          onPressed: () {
            // if(nameController.text.isNotEmpty || descriptionController.text.isNotEmpty || purposeController.text.isNotEmpty || mentorNameController.text.isNotEmpty  || peerNameController.text.isNotEmpty || menteeNameController.text.isNotEmpty ) {
            //   _setTrellisData();
            // }
            Navigator.of(context).pop();
          },
        ),
        title: Text(_isUserDataLoading ? "" : name),
        actions:  [
          IconButton(onPressed: (){

          }, icon:const Icon(Icons.search,)),
          PopMenuButton(false,false,id)
        ],
      ),
      floatingActionButton: Container(
        width: 85.0,
        height: 85.0,
        margin:const EdgeInsets.only(right: 10,bottom: 10),
        child: FloatingActionButton(
          onPressed: (){
            _saveColumnData();
          },
          child: const Icon(Icons.save,color: AppColors.backgroundColor,size: 40,),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LogoScreen("Column"),
                    // SizedBox(width: 20,),
                    // IconButton(onPressed: (){
                    //   bottomSheet(context,"Trellis","Welcome to Trellis, the part of the Brugeon app designed to help you flourish and live life intentionally. Trellis is a light structure that provides structure and focus, and helps propel you towards your desired outcomes. Invest at least five minutes a day in reviewing and meditating on your Trellis. If you don't have any answers yet, spend your time meditating, praying, or journaling on the questions/sections. If you have partial answers, keep taking your time daily to consider the questions and your answers. By consistently returning to your Trellis, you will become more clear and focused on creating the outcomes you desire. Enjoy your Trellis!","");
                    // }, icon: const Icon(Icons.info_outline,size:20,color: AppColors.infoIconColor,))
                  ],
                ),

                Container(
                  padding:const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          value: 1,
                          groupValue: selectedRadio,
                          title:const Text('Entry'),
                          onChanged: (int? val) {
                            setSelectedRadio(val!);
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: 2,
                          groupValue: selectedRadio,
                          title:const Text('Session'),
                          onChanged: (int? val) {
                            setSelectedRadio(val!);
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: 3,
                          groupValue: selectedRadio,
                          title:const Text('Meeting'),
                          onChanged: (int? val) {
                            setSelectedRadio(val!);
                          },
                        ),
                      ),
                      // Add more RadioListTile widgets for additional options
                    ],
                  ),
                ),
                Container(
                    margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    child: TextFieldWidgetForColumnScreen(titleController, 1, true, "Type your Entry/Session Title",)),

                Container(
                    margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    child: DatePickerFieldForColumn(dateController,"Select date",true)),
                Container(
                    margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    child: TextFieldWidgetForColumnScreen(descriptionController, 6, false, "Type your notes", )),
                Container(
                    margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    child: TextFieldWidgetForColumnScreen(takeAwaysController, 6, false, "add any take-a-ways  here", )),
                  // Container(
                  //   padding:const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  //  // margin:const EdgeInsets.only(top: 10),
                  //   child: OptionMcqAnswer(
                  //      Container(
                  //        alignment: Alignment.topLeft,
                  //        padding:const EdgeInsets.symmetric(vertical: 5),
                  //        child: Column(
                  //          mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //          children: [
                  //          Row(
                  //            mainAxisAlignment: MainAxisAlignment.start,
                  //            crossAxisAlignment: CrossAxisAlignment.start,
                  //            children: [
                  //              Expanded(
                  //                child: QuillToolbar.basic(
                  //
                  //                  showListBullets: true,
                  //                  showDividers : false,
                  //                  showFontFamily : false,
                  //                  showFontSize : false,
                  //                  showBoldButton : false,
                  //                  showItalicButton : false,
                  //                  showSmallButton : false,
                  //                  showUnderLineButton : false,
                  //                  showStrikeThrough : false,
                  //                  showInlineCode : false,
                  //                  showColorButton : false,
                  //                  showBackgroundColorButton: false,
                  //                  showClearFormat : false,
                  //                  showAlignmentButtons : false,
                  //                  showLeftAlignment : false,
                  //                  showCenterAlignment : false,
                  //                  showRightAlignment : false,
                  //                  showJustifyAlignment : false,
                  //                  showHeaderStyle : false,
                  //                  showListNumbers : false,
                  //                  showListCheck : false,
                  //                  showCodeBlock : false,
                  //                  showQuote : false,
                  //                  showIndent : false,
                  //                  showLink : false,
                  //                  showUndo : false,
                  //                  showRedo : false,
                  //                  multiRowsDisplay : false,
                  //                  showDirection : false,
                  //                  showSearchButton : false,
                  //                  controller: _controller,
                  //
                  //                ),
                  //              ),
                  //              Expanded(
                  //                  flex: 6,
                  //                  child: Container())
                  //
                  //            ],
                  //          ),
                  //     SizedBox(height: 5,),
                  //     QuillEditor(
                  //       minHeight: 40,
                  //       placeholder: "please add take-a-ways",
                  //         controller: _controller,
                  //         focusNode: _focusNode,
                  //         scrollController: ScrollController(),
                  //         scrollable: true,
                  //         padding:const EdgeInsets.symmetric(horizontal: 5),
                  //         autoFocus: false,
                  //         readOnly: false,
                  //         expands: false),
                  //         ],
                  //     ),
                  //      ),
                  //   ),
                  // ),


              ],
            ),
            Align(
              alignment: Alignment.center,
              child: _isLoading ? const CircularProgressIndicator() : Container(),
            )
          ],
        )
      ),
    );
  }
  _saveColumnData() {
    String? radioOption;
  //  _focusNode.unfocus();
  if(selectedRadio == 1) {
    setState(() {
      radioOption = "entry";
    });
  }else if (selectedRadio == 2) {
    setState(() {
      radioOption = "session";
    });
  } else {
    setState(() {
      radioOption = "Meeting";
    });
  }
// Convert the Delta object to plain text
//     String takeAwayPoints = _controller.document.toPlainText();
//     takeAwayPoints = "\n" + takeAwayPoints;
//     String testingTakeAwayPoints = takeAwayPoints.substring(0,takeAwayPoints.length-1)+"";
//     String test2 = testingTakeAwayPoints.replaceAll('\n', '\n• ');
//     //testingTakeAwayPoints.trimRight();
//     List<String> items = test2.split(',');
//     print(items);

    //print(radioOption);
    if(titleController.text.isNotEmpty && dateController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
     setState(() {
       _isLoading = true;
     });
      HTTPManager().sessionEntry(ColumnAddRequestModel(entryType:radioOption,title: titleController.text,description: descriptionController.text,date: dateController.text,userId: id,takeAways: takeAwaysController.text)).then((value) {
      //  print(value);
        showToastMessage(context, "Data Added Successfully add", true);
        Navigator.of(context).pop();
       // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ColumnScreen()));
        setState(() {
          _isLoading = false;
        });
      }).catchError((e) {
       // print(e);
        setState(() {
          _isLoading = false;
        });
        showToastMessage(context, e.toString(), false);
      });
    } else {
      showToastMessage(context, "Please add some data", false);
    }
   }
}

