// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:credit_card_form/credit_card_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/dashboard_tiles.dart';
import 'package:flutter_quiz_app/model/reponse_model/stripe_keys_details.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
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
   CardFormScreen(this.packageDetails,this.isUpgrade,{Key? key}) : super(key: key);
   String packageDetails;
   bool isUpgrade;

  @override
  State<CardFormScreen> createState() => _CardFormScreenState();
}

class _CardFormScreenState extends State<CardFormScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
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

  bool isError = false;
  String errorMessage = "";
  String publishableKey = "";

  String cardNumber = "";
  String cardExpiryMonth = "";
  String cardExpiryYear = "";
  String cardCVC = "";
  late StripeKeysDetailsModelClass stripeKeysDetailsModelClass;

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

  _getUserData() async {
    //showUpdatePopup(context);
    setState(() {
      _isUserDataLoading = true;
    });
    //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;

    allowEmail = sharedPreferences.getString(UserConstants().allowEmail)!;
    userLoggedIn = sharedPreferences.getBool(UserConstants().userLoggedIn)!;
    _getStripeKeys();
    setState(() {
      _isUserDataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isUserDataLoading ? AppBarWidget().appBar(context,false,true,"","",false) : AppBar(
        centerTitle: true,
        title: Text(name),
        leading: IconButton(onPressed: (){Navigator.of(context).pop();}, icon:Platform.isAndroid ? const Icon(Icons.arrow_back) : const Icon(Icons.arrow_back_ios)),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height/6,
            width: MediaQuery.of(context).size.width/0.2,
            child: Image.asset("assets/primium_page_header.png",fit: BoxFit.fill,width: MediaQuery.of(context).size.width,),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/12),
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
                  const SizedBox(height: 8.0),
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
      if (widget.isUpgrade) {
        _cancelSubscription();
      } else {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Dashboard()), (route) => false);
      }
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
