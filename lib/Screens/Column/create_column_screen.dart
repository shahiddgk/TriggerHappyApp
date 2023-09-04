// ignore_for_file: override_on_non_overriding_member

import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quiz_app/Screens/Column/Widgets/date_picker_field_for_column.dart';
import 'package:flutter_quiz_app/Screens/Column/Widgets/text_field_widet.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/model/request_model/session_entry_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/logo_widget_for_all_screens.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../utill/userConstants.dart';

class CreateColumnScreen extends StatefulWidget {
  const CreateColumnScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
  late bool isPhone;

  int selectedRadio = 1;


  // final QuillController  _controller = QuillController.basic(
  // );


  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController takeAwaysController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


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

  getScreenDetails() {
    // setState(() {
    //   _isLoading = true;
    // });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
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
        width: 60.0,
        height: 60.0,
        margin:const EdgeInsets.only(right: 10,bottom: 10),
        child: FloatingActionButton(
          onPressed: (){
            _saveColumnData();
          },
          child: const Icon(Icons.save,color: AppColors.backgroundColor,size: 30,),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus( FocusNode());
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                        child:!isPhone ? Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 30,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    listTileTheme:const ListTileThemeData(
                                      horizontalTitleGap: 1,//here adjust based on your need
                                    ),
                                  ),
                                  child: RadioListTile(
                                    value: 1,
                                    groupValue: selectedRadio,
                                    title:const Text('Entry',style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                    onChanged: (int? val) {
                                      setSelectedRadio(val!);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 30,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    listTileTheme:const ListTileThemeData(
                                      horizontalTitleGap: 1,//here adjust based on your need
                                    ),
                                  ),
                                  child: RadioListTile(
                                    value: 2,
                                    groupValue: selectedRadio,
                                    title:const Text('Session',style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                    onChanged: (int? val) {
                                      setSelectedRadio(val!);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 30,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    listTileTheme:const ListTileThemeData(
                                      horizontalTitleGap: 1,//here adjust based on your need
                                    ),
                                  ),
                                  child: RadioListTile(
                                    value: 3,
                                    groupValue: selectedRadio,
                                    title:const Text('Meeting',style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                    onChanged: (int? val) {
                                      setSelectedRadio(val!);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],) : Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      listTileTheme:const ListTileThemeData(
                                        horizontalTitleGap: 1,//here adjust based on your need
                                      ),
                                    ),
                                    child: RadioListTile(
                                      value: 1,
                                      groupValue: selectedRadio,
                                      title:const Text('Entry',style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                      onChanged: (int? val) {
                                        setSelectedRadio(val!);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      listTileTheme:const ListTileThemeData(
                                        horizontalTitleGap: 1,//here adjust based on your need
                                      ),
                                    ),
                                    child: RadioListTile(
                                      value: 2,
                                      groupValue: selectedRadio,
                                      title:const Text('Session',style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                      onChanged: (int? val) {
                                        setSelectedRadio(val!);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width/2,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  listTileTheme:const ListTileThemeData(
                                    horizontalTitleGap: 1,//here adjust based on your need
                                  ),
                                ),
                                child: RadioListTile(
                                  value: 3,
                                  groupValue: selectedRadio,
                                  title:const Text('Meeting',style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                  onChanged: (int? val) {
                                    setSelectedRadio(val!);
                                  },
                                ),
                              ),
                            ),
                            // Add more RadioListTile widgets for additional options
                          ],
                        ),
                      ),
                      Container(
                          margin:const EdgeInsets.symmetric(horizontal: 5),
                          child: TextFieldWidgetForColumnScreen(titleController, 1, false, "Type your Entry/Session Title",)),

                      Container(
                          margin:const EdgeInsets.symmetric(horizontal: 5),
                          child: DatePickerFieldForColumn(dateController,"Select date",true)),
                      Container(
                          margin:const EdgeInsets.symmetric(horizontal: 5),
                          child: TextFieldWidgetForColumnScreen(descriptionController, 6, false, "Type your notes", )),
                      Container(
                          margin:const EdgeInsets.symmetric(horizontal: 5),
                          child: TextFieldWidgetForColumnScreen(takeAwaysController, 6, false, "add any take-a-ways  here", )),

                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: _isLoading ? const CircularProgressIndicator() : Container(),
              )
            ],
          )
        ),
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
    if(_formKey.currentState!.validate()) {
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

