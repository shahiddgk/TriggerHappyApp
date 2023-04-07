import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../network/api_urls.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../utill/userConstants.dart';

class ImageScreen extends StatefulWidget {
   ImageScreen(this.responseScore,{Key? key}) : super(key: key);

   String responseScore;

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  late SharedPreferences _sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  late bool _isLoading;
  late bool isPhone;
  late String countNumber;
  String errorMessage = "";
  String url = "";

  @override
  void initState() {
    _getUserData();
    // TODO: implement initState
    super.initState();
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    print("Data getting called");
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();

    name = _sharedPreferences.getString(UserConstants().userName)!;
    id = _sharedPreferences.getString(UserConstants().userId)!;
    email = _sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = _sharedPreferences.getString(UserConstants().timeZone)!;
    userType = _sharedPreferences.getString(UserConstants().userType)!;
    _getTreeGrowth();
    setState(() {
      _isUserDataLoading = false;
    });
  }

  _getTreeGrowth() {

    setState(() {
      _isLoading = true;
    });

    // HTTPManager().treeGrowth(LogoutRequestModel(userId: id)).then((value) {
    //   int count = value["response_count"];
    //   countNumber = value["response_count"];

      // ignore: unrelated_type_equality_checks
      if(widget.responseScore == "0") {
        setState(() {
          countNumber = "1";
        });
        print(countNumber);
        if(!isPhone) {
          url = "${ApplicationURLs.BASE_URL_FOR_IPAD_IMAGES}$countNumber.png";
        } else {
          url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}$countNumber.png";
        }
        print(url);
      } else {
        setState(() {
            countNumber = widget.responseScore;
          print(countNumber);
          if(!isPhone) {
            url = "${ApplicationURLs.BASE_URL_FOR_IPAD_IMAGES}$countNumber.png";
          } else {
            url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}$countNumber.png";
          }
          print(url);
        });
      }

      setState(() {
        errorMessage = "";
        _isLoading = false;
      });
      //  showToastMessage(context, value['message'].toString(),true);
    // }).catchError((e) {
    //   setState(() {
    //     _isLoading = false;
    //     errorMessage = e.toString();
    //   });
    //   showToastMessage(context, e.toString(),false);
    // });

  }

  getScreenDetails() {
    setState(() {
      _isLoading = true;
    });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return Scaffold(
      appBar: _isUserDataLoading ? AppBarWidget().appBar(false,true,"","",false) : AppBar(
        centerTitle: true,
        title: Text(name),
        actions:  [
          PopMenuButton(false,false,id)
        ],
      ),
      body: Container(
        child: _isLoading ? Container(
          color: Colors.white,
          child:const Center(
            child: CircularProgressIndicator(),
          ),
        ) : errorMessage != "" ? Center(
          child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(errorMessage,style:const TextStyle(fontSize: 25),),
                  const SizedBox(height: 5,),
                  GestureDetector(
                    onTap: () {
                      _getTreeGrowth();
                    },
                    child: OptionMcqAnswer(
                        TextButton(onPressed: () {
                          _getTreeGrowth();
                        }, child: const Text("Reload",style: TextStyle(fontSize:25,color: AppColors.redColor)),)
                    ),
                  )
                ],
              )
          ),
        ) : Container(
          color: Colors.white,
          alignment: Alignment.bottomCenter,
          child:url == "" ? Container(
              color: Colors.white,
              child:const Center(
                child: CircularProgressIndicator(),
              ),
            ) : Center(
              child: CachedNetworkImage(
                imageUrl: url,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error,color: AppColors.redColor,),
              ),
            ),
          ),
        ),
    );
  }
}
