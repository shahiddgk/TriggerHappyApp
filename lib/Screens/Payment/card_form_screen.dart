// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:credit_card_form/credit_card_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/dashboard_tiles.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../model/request_model/stripe_request_payment_model.dart';
import '../../network/http_manager.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Widgets/toast_message.dart';
import '../utill/UserState.dart';
import '../utill/userConstants.dart';

// ignore: must_be_immutable
class CardFormScreen extends StatefulWidget {
   CardFormScreen(this.packageDetails,{Key? key}) : super(key: key);
   String packageDetails;

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
  var clientkey = "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";
  // late CardFieldInputDetails _cardInputDetails;
  String publishableKey = "pk_live_51NAYCKLyPobj6EzkyRLf3pT2kzmHjAahmtahWsUfAEY5EV4ECruU6zlPTaTIwEGlQ7Tvip9hagaU8krn4mF5uHrl00sfo3RvfC";

  String? cardNumber;
  String? cardExpiryMonth;
  String? cardExpiryYear;
  String? cardCVC;

  // final CardFormEditController cardFormEditController = CardFormEditController();
  final CreditCardController creditCardController = CreditCardController();

  @override
  void initState() {
    _getUserData();
    _getSubscriptionData();
    // Stripe.publishableKey = 'pk_live_51NAYCKLyPobj6EzkyRLf3pT2kzmHjAahmtahWsUfAEY5EV4ECruU6zlPTaTIwEGlQ7Tvip9hagaU8krn4mF5uHrl00sfo3RvfC';
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

  _getSubscriptionData() async {
    //showUpdatePopup(context);
    // setState(() {
    //   _isUserDataLoading = true;
    // });
    //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    userPremium = sharedPreferences.getString(UserConstants().userPremium)!;
    userPremiumType = sharedPreferences.getString(UserConstants().userPremiumType)!;
    userCustomerId = sharedPreferences.getString(UserConstants().userCustomerId)!;
    userSubscriptionId = sharedPreferences.getString(UserConstants().userSubscriptionId)!;

    // setState(() {
    //   _isUserDataLoading = false;
    // });
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
                  // const SizedBox(height: 30.0),
                  // const Text(
                  //   '✔ some text here',
                  //   style: TextStyle(
                  //     fontSize: 20.0,
                  //     color: AppColors.textWhiteColor,
                  //     fontWeight: FontWeight.normal,
                  //   ),
                  // ),
                  // const Text(
                  //   '✔ some text here',
                  //   style: TextStyle(
                  //     fontSize: 20.0,
                  //     color: AppColors.textWhiteColor,
                  //     fontWeight: FontWeight.normal,
                  //   ),
                  // ),
                  // const Text(
                  //   '✔ some text here',
                  //   style: TextStyle(
                  //     fontSize: 20.0,
                  //     color: AppColors.textWhiteColor,
                  //     fontWeight: FontWeight.normal,
                  //   ),
                  // ),
                  // const Text(
                  //   '✔ some text here',
                  //   style: TextStyle(
                  //     fontSize: 20.0,
                  //     color: AppColors.textWhiteColor,
                  //     fontWeight: FontWeight.normal,
                  //   ),
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       color: AppColors.greyColor,
                  //       borderRadius: BorderRadius.circular(30)
                  //   ),
                  //   margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  //   alignment: Alignment.center,
                  //   padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 60,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       ElevatedButton(
                  //         onPressed: () {},
                  //         style: ElevatedButton.styleFrom(
                  //           padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(25.0),
                  //           ),
                  //           backgroundColor: AppColors.primaryColor,
                  //         ),
                  //         child:const Text("Free",style: TextStyle(fontSize: 15),),
                  //       ),
                  //       ElevatedButton(
                  //         onPressed: () {},
                  //         style: ElevatedButton.styleFrom(
                  //           padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(25.0),
                  //           ),
                  //           backgroundColor: AppColors.primaryColor,
                  //         ),
                  //         child:const Column(
                  //           children: [
                  //             Text("Annual",style: TextStyle(fontSize: 12),),
                  //             Text("200 \$",style: TextStyle(fontSize: 12),),
                  //           ],
                  //         ),
                  //       ),
                  //       ElevatedButton(
                  //         onPressed: () {},
                  //         style: ElevatedButton.styleFrom(
                  //           padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(25.0),
                  //           ),
                  //           backgroundColor: AppColors.primaryColor,
                  //         ),
                  //         child:const Column(
                  //           children: [
                  //             Text("Monthly",style: TextStyle(fontSize: 12),),
                  //             Text("20 \$",style: TextStyle(fontSize: 12),),
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
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
                              // ignore: avoid_print
                              print(CreditCardResult.cardNumber);
                              // ignore: avoid_print
                              print(CreditCardResult.expirationMonth);
                              // ignore: avoid_print
                              print(CreditCardResult.expirationYear);
                              // ignore: avoid_print
                              print(CreditCardResult.cardType);
                              // ignore: avoid_print
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

                      if(widget.packageDetails == "Monthly") {
                        _createCardToke(
                          cardNumber!, int.parse(cardExpiryMonth.toString()),
                          int.parse(cardExpiryYear.toString()), cardCVC!,
                          publishableKey,"month","8");
                      } else if(widget.packageDetails == "Day"){
                        _createCardToke(
                            cardNumber!, int.parse(cardExpiryMonth.toString()),
                            int.parse(cardExpiryYear.toString()), cardCVC!,
                            publishableKey,"day","8");
                      } else {
                        _createCardToke(
                            cardNumber!, int.parse(cardExpiryMonth.toString()),
                            int.parse(cardExpiryYear.toString()), cardCVC!,
                            publishableKey,"year","60");
                      }
                    },
                    child:const Text('Pay Now',style: TextStyle(color: AppColors.backgroundColor),),
                  ),
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


  _createCardToke(String cardNumber1,int expMonth1,int expYear1,String cvc1,String publishableKey1,String interval,String amount) {

    if(_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      HTTPManager().stripeTokenApi(cardNumber1, expMonth1, expYear1, cvc1, publishableKey).then((value) {
        // Token? tokenObject;
        // setState(() {
        //   tokenObject = value;
        // });
        // print("These are the Card Details of API RESPONSE");
        // print(value);
        // dynamic user = {
        //   "userid": id,
        //   "username": name,
        //   "useremail": email
        // };
        // final user = {
        //   "userid" : id,
        //   "useremail" : email,
        //   "username" : name
        // };
        // final plan = {
        //   "text" : widget.packageDetails == "Monthly" ? "Gold" :"Premium",
        //   "amount" : widget.packageDetails == "Monthly" ? "20" : "200",
        //   "interval" : "year"
        // };
        // Map<String, dynamic> body = {
        //   "user": user,
        //   "token": value,
        //   "package": plan,
        // };
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
        // ignore: avoid_print
        print(e);
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  _sendPaymentRequest (String usrId,String token1,String pkgText,String pkgAmount,String pkgInterval,) {
    // ignore: avoid_print
    print("Params For payment api");
    // ignore: avoid_print
    print(usrId);
    // ignore: avoid_print
    print(token1);
    // ignore: avoid_print
    print(pkgText);
    // ignore: avoid_print
    print(pkgAmount);
    // ignore: avoid_print
    print(pkgInterval);
    // print(tokenObject1.toString());
    // print(plan1.toString());

    // setState(() {
    //   isLoading = true;
    // });
    HTTPManager().stripePayment(StripePaymentRequestModel(userId: usrId,token: token1,packageAmount: pkgAmount,packageInterval: pkgInterval,packageText: pkgText)).then((value) {
      // ignore: avoid_print
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
