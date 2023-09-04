// ignore_for_file: use_build_context_synchronously, avoid_print
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:credit_card_form/credit_card_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Screens/utill/userConstants.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/model/request_model/stripe_request_payment_model.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../PireScreens/widgets/AppBar.dart';
import '../utill/UserState.dart';
import 'card_form_screen.dart';


// ignore: must_be_immutable
class StripePayment extends StatefulWidget {
   StripePayment(this.isBannerVisible,{Key? key}) : super(key: key);
  bool isBannerVisible;
  @override
  // ignore: library_private_types_in_public_api
  _StripePaymentState createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> with SingleTickerProviderStateMixin {


  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  String allowEmail = "";
  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";

  late AnimationController _animationController;
  bool _isBannerVisible = false;

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expMonthController = TextEditingController();
  final TextEditingController _expYearController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  Map<String, dynamic>? paymentIntent;
  bool isLoading = false;

  String? cardNumber;
  String? cardExpiryMonth;
  String? cardExpiryYear;
  String? cardCVC;

  bool isFreeButton = true;
  bool isDayButton = false;
  bool isAnnualButton = false;
  bool isMonthlyButton = false;

  // final CardFormEditController cardFormEditController = CardFormEditController();
  final CreditCardController creditCardController = CreditCardController();

  @override
  void initState() {
    _getUserData();
    _getSubscriptionData();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      setState(() {
        _isBannerVisible = true;
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }


  @override
  void dispose() {
    _cardNumberController.dispose();
    _expMonthController.dispose();
    _expYearController.dispose();
    _cvcController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void toggleBanner() {
    setState(() {
      _isBannerVisible = !_isBannerVisible;
      if (_isBannerVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void showSnackbar() {
    final materialBanner = MaterialBanner(
      elevation: 0,
      backgroundColor: Colors.transparent,
      forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: 'Oh Hey!!',
        message:
        'Please update your plan to premium',
         contentType: ContentType.failure,
        // to configure for material banner
        inMaterialBanner: true,
      ),
      actions: const [SizedBox.shrink()],
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(materialBanner);
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

    if(userPremium == "yes" && userPremiumType == "month") {
      setState(() {
        isFreeButton = false;
        isDayButton = false;
        isAnnualButton = false;
        isMonthlyButton = true;
      });
    } else if(userPremium == "yes" && userPremiumType == "year") {
      setState(() {
        isFreeButton = false;
        isDayButton = false;
        isAnnualButton = true;
        isMonthlyButton = false;
      });
    } else {
      setState(() {
        isFreeButton = true;
        isDayButton = false;
        isAnnualButton = false;
        isMonthlyButton = false;
      });
    }

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
    allowEmail = sharedPreferences.getString(UserConstants().allowEmail)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;


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
          if(widget.isBannerVisible)
          AnimatedContainer(
            height: _isBannerVisible ? 80.0 : 0.0,
            duration:const Duration(milliseconds: 500),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: MaterialBanner(
                margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                elevation: 10,
                backgroundColor: AppColors.radishHueColor,
                content:const Text("Please upgrade your plan to Premium!",style: TextStyle(color: AppColors.backgroundColor,),),
                actions: [
                  IconButton( onPressed: toggleBanner, icon:const Icon(Icons.close,color: AppColors.backgroundColor,))
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/18),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Burgeon',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    userPremiumType == "year" ? "Premium Annual" : userPremiumType == "month" ? "Premium monthly" : "Free Plan",
                    style:const TextStyle(
                      fontSize: 18.0,
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if(isFreeButton)
                  const Text(
                    'Free',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: AppColors.textWhiteColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  if(isDayButton)
                    const Text(
                      'Free',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: AppColors.textWhiteColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  if(isAnnualButton)
                    const Text(
                      'Annual',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: AppColors.textWhiteColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  if(isMonthlyButton)
                    const Text(
                      'Monthly',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: AppColors.textWhiteColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  SizedBox(height: MediaQuery.of(context).size.height/25),
                  Visibility(
                      visible: userPremium == "no" && isFreeButton,
                      child: const Text(
                    'Active Plan',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: AppColors.selectedAnswerColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ) ),

                  Visibility(
                      visible: isMonthlyButton && userPremiumType == "month",
                      child: const Text(
                        'Active Plan',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: AppColors.selectedAnswerColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ) ),

                  Visibility(
                      visible: isAnnualButton && userPremiumType == "year",
                      child: const Text(
                        'Active Plan',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: AppColors.selectedAnswerColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ) ),
                   SizedBox(height: MediaQuery.of(context).size.height/25),

                  Image.asset("assets/plan_subscription_text.png",),
                  const SizedBox(height: 30.0),
                  isMonthlyButton || isAnnualButton ? const Text(
                    '✔ P.I.R.E Unlimited',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.textWhiteColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ) : const Text(
                    '✔ P.I.R.E',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.textWhiteColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  isMonthlyButton || isAnnualButton ? const Text(
                    '✔ Trellis Unlimited',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.textWhiteColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ) :  const Text(
                    '✔ Trellis',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.textWhiteColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  isMonthlyButton || isAnnualButton ? const Text(
                    '✔ Bridge Unlimited',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.textWhiteColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ) :  const Text(
                    '✔ Bridge',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.textWhiteColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  isAnnualButton || isMonthlyButton ? const Text(
                    '✔ Garden Unlimited',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.textWhiteColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ) : const Text(
                    '',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.hoverColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 10,),
                    isAnnualButton || isMonthlyButton ? const Text(
                    '✔ Column Unlimited',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.textWhiteColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ) : const Text(
                      '',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: AppColors.backgroundColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  const SizedBox(height: 10,),
                  isMonthlyButton || isAnnualButton ? const Text(
                    '✔ Post Unlimited',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.textWhiteColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ) :  const Text(
                    '',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.textWhiteColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  if(isFreeButton)
                    const SizedBox(height: 2,),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.subscriptionGreyColor,
                      borderRadius: BorderRadius.circular(30)
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isFreeButton = true;
                              isDayButton = false;
                              isAnnualButton = false;
                              isMonthlyButton = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            backgroundColor: isFreeButton ? AppColors.primaryColor : AppColors.backgroundColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("  Free  ",style: TextStyle(fontSize: 12,color: isFreeButton ? AppColors.backgroundColor: AppColors.textWhiteColor),),
                              //Text("",style: TextStyle(fontSize: 12,color: isFreeButton ? AppColors.backgroundColor: AppColors.textWhiteColor),),
                            ],
                          ),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       isFreeButton = false;
                        //       isDayButton = true;
                        //       isAnnualButton = false;
                        //       isMonthlyButton = false;
                        //     });
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(25.0),
                        //     ),
                        //     backgroundColor: isDayButton ? AppColors.primaryColor : AppColors.backgroundColor,
                        //   ),
                        //   child: Column(
                        //     children: [
                        //       Text("Day",style: TextStyle(fontSize: 12,color: isDayButton ? AppColors.backgroundColor: AppColors.textWhiteColor),),
                        //       Text("20 \$",style: TextStyle(fontSize: 12,color: isDayButton ? AppColors.backgroundColor: AppColors.textWhiteColor),),
                        //     ],
                        //   ),
                        // ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isFreeButton = false;
                              isDayButton = false;
                              isAnnualButton = false;
                              isMonthlyButton = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            backgroundColor: isMonthlyButton ? AppColors.primaryColor : AppColors.backgroundColor,
                          ),
                          child: Column(
                            children: [
                              Text("Monthly",style: TextStyle(fontSize: 12,color: isMonthlyButton ? AppColors.backgroundColor: AppColors.textWhiteColor),),
                              Text("\$8",style: TextStyle(fontSize: 12,color: isMonthlyButton ? AppColors.backgroundColor: AppColors.textWhiteColor),),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isFreeButton = false;
                              isDayButton = false;
                              isAnnualButton = true;
                              isMonthlyButton = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            backgroundColor: isAnnualButton ? AppColors.primaryColor : AppColors.backgroundColor,
                          ),
                          child: Column(
                            children: [
                               Text("Annual",style: TextStyle(fontSize: 12,color: isAnnualButton ? AppColors.backgroundColor: AppColors.textWhiteColor),),
                               Text("\$60",style: TextStyle(fontSize: 12,color: isAnnualButton ? AppColors.backgroundColor: AppColors.textWhiteColor),),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  // Form(
                  //   key: _formKey,
                  //   child: SingleChildScrollView(
                  //       child: CreditCardForm(
                  //         hideCardHolder: true,
                  //         controller: creditCardController,
                  //         theme: CreditCardLightTheme(),
                  //         onChanged: (CreditCardResult ) {
                  //           setState(() {
                  //             cardNumber = CreditCardResult.cardNumber;
                  //             cardExpiryMonth = CreditCardResult.expirationMonth;
                  //             cardExpiryYear = CreditCardResult.expirationYear;
                  //             cardCVC = CreditCardResult.cvc;
                  //           });
                  //           print(CreditCardResult.cardNumber);
                  //           print(CreditCardResult.expirationMonth);
                  //           print(CreditCardResult.expirationYear);
                  //           print(CreditCardResult.cardType);
                  //           print(CreditCardResult.cvc);
                  //         },
                  //       )
                  //   ),
                  // ),
                  const  SizedBox(height: 16.0),
                  if(!isFreeButton)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: () {

                      print("cancel button clicked");
                      print(userPremium);
                      if(userPremium == "no") {
                        if (isFreeButton) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (
                              context) => CardFormScreen("Free",false)));
                        } else if (isDayButton) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (
                              context) => CardFormScreen("Day",false)));
                        } else if (isAnnualButton) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      CardFormScreen("Annual",false)));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CardFormScreen("Monthly",false
                                    )));
                        }
                      } else {
                        if ( isAnnualButton && userPremiumType == "month") {
                          _cancelSubscription("Annual");
                        } else if (isMonthlyButton && userPremiumType == "year") {
                          _cancelSubscription("Monthly");
                        } else {
                          _cancelSubscription("");
                        }
                      }
                      },
                    child: userPremium == "no"
                        ? const Text('Upgrade Now',style: TextStyle(color: AppColors.backgroundColor),)
                        : isDayButton && userPremiumType == "day"
                        ?  const Text('Cancel Subscription',style: TextStyle(color: AppColors.backgroundColor),)
                        :  isMonthlyButton && userPremiumType == "month"
                        ?  const Text('Cancel Subscription',style: TextStyle(color: AppColors.backgroundColor),)
                        : isAnnualButton && userPremiumType == "year"
                        ? const Text('Cancel Subscription',style: TextStyle(color: AppColors.backgroundColor),)
                        : const Text('Upgrade Now',style: TextStyle(color: AppColors.backgroundColor),),
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

  _cancelSubscription(String subscriptionType) {
    if (subscriptionType == "Annual") {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CardFormScreen("Annual",true)));
    } else if (subscriptionType == "Monthly") {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              CardFormScreen("Monthly",true
              )));
    } else {
      //showToastMessage(context, "Subscription cancelled", true);


      setState(() {
        isLoading = true;
      });

      HTTPManager().cancelSubscription(
          StripeCancelRequestModel(subscriptionId: userSubscriptionId)).then((
          value) {
        print("subscription cancel type::$subscriptionType");
        UserStatePrefrence().setAnswerText(
          true,
          userType,
          name,
          email,
          id,
          timeZone,
          allowEmail,
          "no",
          "",
          "",
          "",
        );
        setState(() {
          userPremiumType = "";
          isFreeButton = true;
          isDayButton = false;
          isAnnualButton = false;
          isMonthlyButton = false;
          userPremium = "no";

          isLoading = false;
        });
        if (subscriptionType == "Annual") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CardFormScreen("Annual",true)));
        } else if (subscriptionType == "Monthly") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  CardFormScreen("Monthly",true
                  )));
        } else {
          showToastMessage(context, "Subscription cancelled", true);
        }
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        print(e);
      });
    }
  }

  // _createCardToke(String cardNumber1,int expMonth1,int expYear1,String cvc1,String publishableKey1) {
  //
  //   if(_formKey.currentState!.validate()) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     HTTPManager().stripeTokenApi(cardNumber1, expMonth1, expYear1, cvc1, publishableKey).then((value) {
  //       // Token? tokenObject;
  //       // setState(() {
  //       //   tokenObject = value;
  //       // });
  //       // print("These are the Card Details of API RESPONSE");
  //       // print(value);
  //       // dynamic user = {
  //       //   "userid": id,
  //       //   "username": name,
  //       //   "useremail": email
  //       // };
  //       // final user = {
  //       //   "userid" : id,
  //       //   "useremail" : email,
  //       //   "username" : name
  //       // };
  //       // final plan = {
  //       //   "text" : "Premium",
  //       //   "amount" : "200",
  //       //   "interval" : "year"
  //       // };
  //       // Map<String, dynamic> body = {
  //       //   "user": user,
  //       //   "token": value,
  //       //   "package": plan,
  //       // };
  //       // User userObject = User(userid:int.parse(id),username:name.toString(),useremail:email.toString());
  //       // Package plan =  Package(text:"Premium".toString(), amount :200, interval:"year".toString());
  //       //_sendPaymentRequest (body);
  //       // setState(() {
  //       //   isLoading = false;
  //       // });
  //
  //     }).catchError((e) {
  //       print(e);
  //       setState(() {
  //         isLoading = false;
  //       });
  //     });
  //   }
  // }

  // _sendPaymentRequest (Map<String, dynamic> body) {
  //   print("Params For payment api");
  //   print(body);
  //   // print(tokenObject1.toString());
  //   // print(plan1.toString());
  //
  //   // setState(() {
  //   //   isLoading = true;
  //   // });
  //   HTTPManager().stripePayment(body).then((value) {
  //     print(value);
  //     setState(() {
  //       isLoading = false;
  //     });
  //     showToastMessage(context, "Subscription successful", true);
  //   }).catchError((e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     showToastMessage(context, e.toString(), false);
  //   });
  // }



  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //
  //
  //     Map<String, dynamic> body = {
  //       'amount': amount,
  //       'currency': currency,
  //       'payment_method_types[]': 'card'
  //     };
  //
  //
  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization': 'Bearer ' + clientkey, //SecretKey used here
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       },
  //       body: body,
  //     );
  //
  //     log('Payment Intent Body->>> ${response.body.toString()}');
  //     return jsonDecode(response.body);
  //   } catch (err) {
  //     // ignore: avoid_print
  //     log('err charging user: ${err.toString()}');
  //   }
  // }
  //
  // calculateAmount(String amount) {
  //   final calculatedAmout = (int.parse(amount)) * 100;
  //   return calculatedAmout.toString();
  // }
  //
  //
  // Future<void> makePayment() async {
  //   try {
  //
  //
  //     paymentIntent = await createPaymentIntent('10000', 'usd');
  //
  //
  //     await Stripe.instance
  //         .initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntent!['client_secret'],
  //         applePay: null,
  //         googlePay: null,
  //         style: ThemeMode.light,
  //         merchantDisplayName: 'SomeMerchantName',
  //       ),
  //     )
  //         .then((value) {
  //
  //       log("Success Payment checking");
  //     });
  //
  //
  //     displayPaymentSheet(); // Payment Sheet
  //   } catch (e, s) {
  //     String ss = "exception 1 :$e";
  //     String s2 = "reason :$s";
  //     log("exception 1:$e");
  //   }
  // }
  //
  //
  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Row(
  //                 children: const [
  //                   Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 10),
  //                     child: Icon(
  //                       Icons.check_circle,
  //                       color: Colors.green,
  //                     ),
  //                   ),
  //                   Text("Payment Successfull"),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //
  //
  //       paymentIntent = null;
  //     }).onError((error, stackTrace) {
  //       String ss = "exception 2 :$error";
  //       String s2 = "reason :$stackTrace";
  //     });
  //   } on StripeException catch (e) {
  //     print('Error is:---> $e');
  //     String ss = "exception 3 :$e";
  //   } catch (e) {
  //     log('$e');
  //   }
  // }

}
