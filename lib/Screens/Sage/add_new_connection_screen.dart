import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/model/request_model/Sage%20Request/invite_connection_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../model/reponse_model/Sage/sage_search_list_response.dart';
import '../../network/http_manager.dart';
import '../Column/Widgets/search_text_field.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../utill/userConstants.dart';

class AddNewConnection extends StatefulWidget {
  const AddNewConnection({Key? key}) : super(key: key);

  @override
  State<AddNewConnection> createState() => _AddNewConnectionState();
}

class _AddNewConnectionState extends State<AddNewConnection> {

  String name = "";
  String id = "";
  // bool _isUserDataLoading = true;
  final bool _isLoading = false;
  bool _isInviteDataLoading = false;
  String email = "";
  String timeZone = "";
  String userType = "";
  SearchConnectionListResponse searchConnectionListResponse = SearchConnectionListResponse(
      status: 200,
      message: "Success",
      usersData: []);
  TextEditingController searchController = TextEditingController();

  late bool isPhone;
  late bool isTable;
  late bool isDesktop;

  @override
  void initState() {
    // TODO: implement initState

    _getUserData();

    super.initState();
  }

  _getUserData() async {
    //showUpdatePopup(context);
    setState(() {
      // _isUserDataLoading = true;
    });
    //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;

    // getConnectionList();

    setState(() {
      // _isUserDataLoading = false;
    });
  }

  getScreenDetails() {
    setState(() {
    });
    if(MediaQuery.of(context).size.width< 650) {
      isPhone = true;
      isDesktop = false;
      isTable = false;
    } else if (MediaQuery.of(context).size.width >= 650 && MediaQuery.of(context).size.width < 1100) {
      isTable = true;
      isPhone = false;
      isDesktop = false;
    } else if(MediaQuery.of(context).size.width >= 1100) {
      isPhone = false;
      isDesktop = true;
      isTable = false;
    }
    setState(() {
    });
  }

  // searchResultsFromApi(String searchValue,String id1) {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   if(searchValue.isNotEmpty ) {
  //     HTTPManager().getSearchConnectionUserList(
  //         SearchConnectionUserRequestModel(senderId: id1)).then((
  //         value) {
  //       setState(() {
  //         searchConnectionListResponse = value;
  //
  //         _isLoading = false;
  //       });
  //     }).catchError((e) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   } else {
  //     setState(() {
  //       searchConnectionListResponse = SearchConnectionListResponse(
  //           status: 200,
  //           message: "Success",
  //           usersData: []);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return Scaffold(
      appBar: AppBarWidget().appBarGeneralButtons(
          context,
              () {
            Navigator.of(context).pop();
          }, true, true, true, id, true,true,0,false,0),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                LogoScreen("Sage"),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                  child: Row(
                    children: [
                      Expanded(
                        flex:4,
                        child: SearchTextField((value) {
                          if(value.isNotEmpty) {
                            // searchResultsFromApi(value,id);
                          } else {
                            setState(() {
                              searchConnectionListResponse = SearchConnectionListResponse(
                                  status: 200,
                                  message: "Success",
                                  usersData: []);
                            });
                          }
                        }, searchController, 1, false, "search here with name..."),
                      ),
                      // const SizedBox(width: 3,),
                      //  Expanded(
                      //    flex: 1,
                      //    child: ElevatedButton(
                      //      onPressed: (){
                      //
                      //      },
                      //      style:ElevatedButton.styleFrom(
                      //        padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 5),
                      //        shape: RoundedRectangleBorder(
                      //          borderRadius: BorderRadius.circular(5.0),
                      //        ),
                      //        backgroundColor: AppColors.primaryColor,
                      //      ),
                      //      child: const Text("Search",style: TextStyle(color: AppColors.backgroundColor),),
                      //    ),
                      //  ),
                    ],
                  ),
                ),
                _isLoading ? const Center(
                  child: CircularProgressIndicator(),
                ) : searchConnectionListResponse.usersData!.isEmpty ? const Center(
                  child: Text("Please Search User with their names"),
                ) : ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: searchConnectionListResponse.usersData!.length,
                    itemBuilder: (context,index) {
                      return Card(
                        child: Container(
                            margin:const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                ClipOval(
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      margin:const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      child: Image.network("https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"),
                                    )
                                ),
                                // searchConnectionListResponse.usersData![index].image ??
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(searchConnectionListResponse.usersData![index].name!,style:const TextStyle(
                                        color: AppColors.textWhiteColor,fontSize: AppConstants.columnDetailsScreenFontSize
                                    ),),
                                    const SizedBox(height: 5,),
                                    searchConnectionListResponse.usersData![index].connectionExist=="no" ? Row(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            sendConnectionInvite(searchConnectionListResponse.usersData![index].email!,searchConnectionListResponse.usersData![index].name!,"peer",index);
                                          },
                                          child: const Text("Peer",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.defaultFontSize),),
                                        ),
                                        const SizedBox(width: 10,),
                                        InkWell(
                                          onTap: (){
                                            sendConnectionInvite(searchConnectionListResponse.usersData![index].email!,searchConnectionListResponse.usersData![index].name!,"mentor",index);
                                          },
                                          child: const Text("Mentor",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.defaultFontSize),),
                                        ),
                                        // TextButton(onPressed: (){}, child:const Text("Peer",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.defaultFontSize),)),
                                        // TextButton(onPressed: (){}, child:const Text("Mentor",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.defaultFontSize),))
                                      ],
                                    ) : const Text("Already invited",style: TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.defaultFontSize),),
                                  ],
                                ),
                              ],
                            )
                        ),
                      );
                    })
              ],
            ),
          ),
          _isInviteDataLoading ? const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ) : Container()
        ],
      )
    );
  }

  sendConnectionInvite(String recieverEmail,String recieverName,String recieverRole,int index) {
    setState(() {
      _isInviteDataLoading = true;
    });

    HTTPManager().getInviteConnectionRequest(InviteConnectionRequestModel(userId: id,email: recieverEmail,role: recieverRole)).then((value) {
      setState(() {
        searchConnectionListResponse.usersData![index].connectionExist = "yes";
        _isInviteDataLoading = false;
      });

    }).catchError((e) {
      setState(() {
        _isInviteDataLoading = false;
      });
    });
  }

}
