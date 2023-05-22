// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
//
// class StripePayment extends StatefulWidget {
//   const StripePayment({Key? key}) : super(key: key);
//
//   @override
//   _StripePaymentState createState() => _StripePaymentState();
// }
//
// class _StripePaymentState extends State<StripePayment> {
//
//   final TextEditingController _cardNumberController = TextEditingController();
//   final TextEditingController _expMonthController = TextEditingController();
//   final TextEditingController _expYearController = TextEditingController();
//   final TextEditingController _cvcController = TextEditingController();
//
//   @override
//   void initState() {
//
//     Stripe.publishableKey = 'YOUR_PUBLISHABLE_KEY';
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _cardNumberController.dispose();
//     _expMonthController.dispose();
//     _expYearController.dispose();
//     _cvcController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _processPayment() async {
//     final paymentMethod = await Stripe.instance.createPaymentMethod(
//       params: PaymentMethodParams.card(
//           paymentMethodData: PaymentMethodData(
//
//           )
//         // number: _cardNumberController.text,
//         // expMonth: int.parse(_expMonthController.text),
//         // expYear: int.parse(_expYearController.text),
//         // cvc: _cvcController.text, paymentMethodData: PaymentMethodData,
//       ),
//     );
//
//     // Process the payment method object
//     // ...
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Payment Successful'),
//         content: Text('Thank you for your purchase!'),
//         actions: [
//           TextButton(
//             child: Text('OK'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stripe Payment'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Card Details',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16.0),
//             TextFormField(
//               controller: _cardNumberController,
//               decoration: InputDecoration(
//                 labelText: 'Card Number',
//               ),
//             ),
//             SizedBox(height: 8.0),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _expMonthController,
//                     decoration: InputDecoration(
//                       labelText: 'Expiration Month',
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8.0),
//                 Expanded(
//                   child: TextFormField(
//                     controller: _expYearController,
//                     decoration: InputDecoration(
//                       labelText: 'Expiration Year',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8.0),
//             TextFormField(
//               controller: _cvcController,
//               decoration: InputDecoration(
//                 labelText: 'CVC',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               child: Text('Pay Now'),
//               onPressed: _processPayment,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
