// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:credit_card_form/credit_card_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/dashboard_tiles.dart';
import 'package:flutter_quiz_app/model/reponse_model/stripe_keys_details.dart';
import 'package:flutter_quiz_app/model/request_model/Sage%20Request/sage_coaches_payment_request.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../model/request_model/logout_user_request.dart';
import '../../model/request_model/stripe_request_payment_model.dart';
import '../../network/http_manager.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Widgets/toast_message.dart';
import '../utill/UserState.dart';
import '../utill/userConstants.dart';

// ignore: must_be_immutable
class CardFormScreen extends StatefulWidget {
   CardFormScreen(this.packageDetails,this.isUpgrade,this.isSageCoachPayment,this.recieverId,this.entityId,this.shareType,{Key? key}) : super(key: key);
   String packageDetails;
   bool isUpgrade;

   bool isSageCoachPayment;
   String recieverId;
   String entityId;
   String shareType;

  @override
  State<CardFormScreen> createState() => _CardFormScreenState();
}

class _CardFormScreenState extends State<CardFormScreen> {

  String name = "";
  String id = "";
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";

  bool userLoggedIn = true;
  String allowEmail = "";
  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expMonthController = TextEditingController();
  final TextEditingController _expYearController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? paymentIntent;
  bool isLoading = false;

  late bool isPhone;

  bool isError = false;
  String errorMessage = "";
  String publishableKey = "";

  String cardNumber = "";
  String cardExpiryMonth = "";
  String cardExpiryYear = "";
  String cardCVC = "";
  late StripeKeysDetailsModelClass stripeKeysDetailsModelClass;


  int badgeCount1 = 0;
  int badgeCountShared = 0;
  // final CardFormEditController cardFormEditController = CardFormEditController();
  final CreditCardController creditCardController = CreditCardController();

  @override
  void initState() {
    _getUserData();
    _getSubscriptionData();
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    _cardNumberController.dispose();
    _expMonthController.dispose();
    _expYearController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  _getStripeKeys() {

    setState(() {
      isLoading = true;
      isError = false;
      errorMessage = "";
    });
    HTTPManager().getStripeKeysDetails(LogoutRequestModel(userId: id)).then((value) {

      stripeKeysDetailsModelClass = value;
      setState(() {
        publishableKey = stripeKeysDetailsModelClass.data!.stripeLiveKey!;
        print(publishableKey);
        isLoading = false;
      });
    }).catchError((e) {
      print(e);
      setState(() {

        isError = true;
        errorMessage = e.toString();

        isLoading = false;
      });
    });
  }

  _getSubscriptionData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    userPremium = sharedPreferences.getString(UserConstants().userPremium)!;
    userPremiumType = sharedPreferences.getString(UserConstants().userPremiumType)!;
    userCustomerId = sharedPreferences.getString(UserConstants().userCustomerId)!;
    userSubscriptionId = sharedPreferences.getString(UserConstants().userSubscriptionId)!;

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

  _getUserData() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    // badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;

    allowEmail = sharedPreferences.getString(UserConstants().allowEmail)!;
    userLoggedIn = sharedPreferences.getBool(UserConstants().userLoggedIn)!;
    _getStripeKeys();

  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return Scaffold(
      appBar: AppBarWidget().appBarGeneralButtons(
          context,
              () {
            Navigator.of(context).pop();
          }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 1),
            height: MediaQuery.of(context).size.height/6,
            width: MediaQuery.of(context).size.width/0.2,
            child: Image.asset("assets/primium_page_header.png",fit: BoxFit.fill,width: MediaQuery.of(context).size.width,),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/14,right: !isPhone ? MediaQuery.of(context).size.width/4 : 4,left: !isPhone ? MediaQuery.of(context).size.width/4 : 5 ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //LogoScreen("Premium"),
                  const Text(
                    'Burgeon',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 3,),
                  const SizedBox(height: 6.0),
                  isError ? Center(
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height/10),
                            Text(errorMessage,style:const TextStyle(fontSize: 25),),
                            const SizedBox(height: 5,),
                            GestureDetector(
                              onTap: () {
                                _getStripeKeys();
                              },
                              child: OptionMcqAnswer(
                                  TextButton(onPressed: () {
                                    _getStripeKeys();
                                  }, child: const Text("Reload",style: TextStyle(fontSize:25,color: AppColors.redColor)),)
                              ),
                            )
                          ],
                        )
                    ),
                  ) : widget.isSageCoachPayment ? Container(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.shareType == "pire"? "P.I.R.E" :
                        widget.shareType == "naq"? "NAQ" : widget.shareType == "ladder"? "Ladder" :
                        widget.shareType == "column"? "Column" : "Trellis",
                          style:const TextStyle(
                            fontSize: 20.0,
                            color: AppColors.backgroundColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height/25),
                        Visibility(
                            visible: widget.isSageCoachPayment,
                            child:widget.recieverId == "96" ? Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(150),
                                    border: Border.all(color: AppColors.primaryColor),
                                  ),
                                  width: 80,
                                  height: 80,
                                  margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                                  child: const CircleAvatar(
                                      backgroundImage: NetworkImage("https://trueincrease.com/wp-content/uploads/2023/02/Aaron-Brown-Bio-Headshot-2023-300x300.jpg")),
                                ),
                                const Text(
                                  "Aaron Brown",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: AppConstants.userActivityFontSize,
                                  ),
                                ),
                                const Text(
                                  "Coach",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: AppConstants.fontSizeForReminderSectionTimePicker,
                                  ),
                                ),
                              ],
                            ) : Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(150),
                                    border: Border.all(color: AppColors.primaryColor),
                                  ),
                                  width: 80,
                                  height: 80,
                                  margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                                  child: const CircleAvatar(
                                      backgroundImage: NetworkImage("https://trueincrease.com/wp-content/uploads/2023/02/Chris-Williams-Bio-Headshot-2023-300x300.jpg")),
                                ),
                                const Text(
                                  "Chris Williams",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: AppConstants.userActivityFontSize,
                                  ),
                                ),
                                const Text(
                                  "Coach",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: AppConstants.fontSizeForReminderSectionTimePicker,
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(height: 10,),
                        const Text(
                         "\$25",
                         style: TextStyle(
                           fontSize: AppConstants.logoFontSizeForMobile,
                           color: AppColors.primaryColor,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       const SizedBox(height: 10,),
                       const Text("Seeking your coach's opinion is like unlocking a treasure chest of wisdom; it's the pathway to improvement and success.",
                         textAlign: TextAlign.center,
                         style: TextStyle(
                           fontSize: 15.0,
                           color: AppColors.textWhiteColor,
                           fontWeight: FontWeight.normal,
                         ),
                       ),
                        const SizedBox(height: 10,),
                        Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: CreditCardForm(
                                  hideCardHolder: true,
                                  controller: creditCardController,

                                  theme: CustomCardTheme(),
                                  // ignore: avoid_types_as_parameter_names
                                  onChanged: (CreditCardResult ) {
                                    setState(() {
                                      cardNumber = CreditCardResult.cardNumber;
                                      cardExpiryMonth = CreditCardResult.expirationMonth;
                                      cardExpiryYear = CreditCardResult.expirationYear;
                                      cardCVC = CreditCardResult.cvc;
                                    });
                                    print(CreditCardResult.cardNumber);
                                    print(CreditCardResult.expirationMonth);
                                    print(CreditCardResult.expirationYear);
                                    print(CreditCardResult.cardType);
                                    print(CreditCardResult.cvc);
                                  },
                                ),
                              )
                          ),
                        ),
                        const SizedBox(height: 15,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 100),
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            if(cardNumber != "" && cardCVC != ""&& cardExpiryYear != ""&& cardExpiryMonth != "") {
                              _createCardToken(
                                    cardNumber,
                                    int.parse(cardExpiryMonth.toString()),
                                    int.parse(cardExpiryYear.toString()),
                                    cardCVC,
                                    publishableKey);

                            } else {
                              showToastMessage(context, "Field cannot be empty", false);
                            }
                          },
                          child:const Text('Pay Now',style: TextStyle(color: AppColors.backgroundColor),),
                        ),
                      ],
                    ),
                  ) : Column(
                     children: [
                       Text(
                         widget.packageDetails,
                         style:const TextStyle(
                           fontSize: 20.0,
                           color: AppColors.textWhiteColor,
                           fontWeight: FontWeight.normal,
                         ),
                       ),
                       SizedBox(height: MediaQuery.of(context).size.height/18),
                       Text(
                         widget.packageDetails == "Monthly" ? "\$8" : widget.packageDetails == "Day"  ? "\$20" : "\$60" ,
                         style: const TextStyle(
                           fontSize: 20.0,
                           color: AppColors.textWhiteColor,
                           fontWeight: FontWeight.normal,
                         ),
                       ),
                       SizedBox(height: MediaQuery.of(context).size.height/12),
                       Form(
                         key: _formKey,
                         child: SingleChildScrollView(
                             child: Container(
                               margin: const EdgeInsets.symmetric(horizontal: 10),
                               child: CreditCardForm(
                                 hideCardHolder: true,
                                 controller: creditCardController,

                                 theme: CustomCardTheme(),
                                 // ignore: avoid_types_as_parameter_names
                                 onChanged: (CreditCardResult ) {
                                   setState(() {
                                     cardNumber = CreditCardResult.cardNumber;
                                     cardExpiryMonth = CreditCardResult.expirationMonth;
                                     cardExpiryYear = CreditCardResult.expirationYear;
                                     cardCVC = CreditCardResult.cvc;
                                   });
                                   print(CreditCardResult.cardNumber);
                                   print(CreditCardResult.expirationMonth);
                                   print(CreditCardResult.expirationYear);
                                   print(CreditCardResult.cardType);
                                   print(CreditCardResult.cvc);
                                 },
                               ),
                             )
                         ),
                       ),
                       const  SizedBox(height: 16.0),
                       ElevatedButton(
                         style: ElevatedButton.styleFrom(
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(20)
                           ),
                           padding: const EdgeInsets.symmetric(horizontal: 100),
                           backgroundColor: AppColors.primaryColor,
                         ),
                         onPressed: () {
                                if(cardNumber != "" && cardCVC != ""&& cardExpiryYear != ""&& cardExpiryMonth != "") {
                                  if (widget.packageDetails == "Monthly") {
                                      _createCardToke(
                                          cardNumber,
                                          int.parse(cardExpiryMonth.toString()),
                                          int.parse(cardExpiryYear.toString()),
                                          cardCVC,
                                          publishableKey,
                                          "month",
                                          "8");

                                  } else if (widget.packageDetails == "Day") {

                                      _createCardToke(
                                          cardNumber,
                                          int.parse(cardExpiryMonth.toString()),
                                          int.parse(cardExpiryYear.toString()),
                                          cardCVC,
                                          publishableKey,
                                          "day",
                                          "8");

                                  } else {
                                      _createCardToke(
                                          cardNumber,
                                          int.parse(cardExpiryMonth.toString()),
                                          int.parse(cardExpiryYear.toString()),
                                          cardCVC,
                                          publishableKey,
                                          "year",
                                          "60");
                                  }
                                } else {
                                  showToastMessage(context, "Field cannot be empty", false);
                                }
                              },
                         child:const Text('Pay Now',style: TextStyle(color: AppColors.backgroundColor),),
                       ),
                     ],
                   )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: isLoading ? const CircularProgressIndicator() : Container(),
          )
        ],
      ),
    );
  }

  _cancelSubscription() {
      setState(() {
        isLoading = true;
      });

      HTTPManager()
          .cancelSubscription(
              StripeCancelRequestModel(subscriptionId: userSubscriptionId))
          .then((value) {
        // UserStatePrefrence().setAnswerText(
        //   true,
        //   userType,
        //   name,
        //   email,
        //   id,
        //   timeZone,
        //   allowEmail,
        //   "no",
        //   "",
        //   "",
        //   "",
        // );
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Dashboard()), (route) => false);
        setState(() {
          isLoading = false;
        });
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        print(e);
      });
  }

  _createCardToken(String cardNumber1,int expMonth1,int expYear1,String cvc1,String publishableKey1) {

    if(_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      HTTPManager().stripeTokenApi(cardNumber1, expMonth1, expYear1, cvc1, publishableKey).then((value) {

        print("Payment Token");
        print(value);

        _sendPaymentForCoaches(id,value.toString(),widget.shareType,widget.recieverId,email,widget.entityId);

      }).catchError((e) {
        final jsonData = jsonDecode(e.toString());

        final error = jsonData['error'];
        final errorMessage = error['message'];

        // Print the values
        print('Error Message: $errorMessage');

        showToastMessage(context, errorMessage.toString(), false);
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  _sendPaymentForCoaches(String userId1,String token1,String type1,String recieverId1, String email,String entityId1) {

   HTTPManager().sendSagePaymentForCoach(SageCoachesPayment(userId: userId1, token: token1, type: type1,recieverId: recieverId1, email: email  ,entityId: entityId1)).then((value) {

      setState(() {
        isLoading = false;
      });
      showToastMessage(context, "Payment Successful", true);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Dashboard()), (route) => false);

    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      print("Error Message1234123");
      print(e);
      showToastMessage(context, e.toString(), false);
    });
  }

  _createCardToke(String cardNumber1,int expMonth1,int expYear1,String cvc1,String publishableKey1,String interval,String amount) {

    if(_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      HTTPManager().stripeTokenApi(cardNumber1, expMonth1, expYear1, cvc1, publishableKey).then((value) {

        // User userObject = User(userid:int.parse(id),username:name.toString(),useremail:email.toString());
        // Package plan =  Package(text:"Premium".toString(), amount :200, interval:"year".toString());
        if(widget.packageDetails == "Monthly") {
          _sendPaymentRequest(id, value.toString(), "Premium", amount, interval);
        } else {
          _sendPaymentRequest(id, value.toString(), "Premium Annual", amount, interval);

        }
        // setState(() {
        //   isLoading = false;
        // });

      }).catchError((e) {
        final jsonData = jsonDecode(e.toString());

        final error = jsonData['error'];
        final errorMessage = error['message'];

        // Print the values
        print('Error Message: $errorMessage');

        showToastMessage(context, errorMessage.toString(), false);
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  _sendPaymentRequest (String usrId,String token1,String pkgText,String pkgAmount,String pkgInterval,) {
    print("Params For payment api");
    print(usrId);
    print(token1);
    print(pkgText);
    print(pkgAmount);
    print(pkgInterval);
    HTTPManager().stripePayment(StripePaymentRequestModel(userId: usrId,token: token1,packageAmount: pkgAmount,packageInterval: pkgInterval,packageText: pkgText)).then((value) {
      print(value);
      setState(() {
        isLoading = false;
      });
      UserStatePrefrence().setAnswerText(
        true,
        userType,
        name,
        email,
        id,
        timeZone,
        allowEmail,
        "yes",
        value['data']['plan_interval'].toString(),
        value['data']['stripe_customer_id'].toString(),
        value['data']['stripe_subscription_id'].toString(),
      );
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Dashboard()), (route) => false);
      // if (widget.isUpgrade) {
      //   _cancelSubscription();
      // } else {
      //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Dashboard()), (route) => false);
      // }
      showToastMessage(context, "Subscription successful", true);
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      showToastMessage(context, e.toString(), false);
    });
  }
}

class CustomCardTheme implements CreditCardTheme {
  @override
  Color backgroundColor = Colors.white;
  @override
  Color textColor = Colors.black;
  @override
  Color borderColor = Colors.black45;
  @override
  Color labelColor = Colors.black45;
}
