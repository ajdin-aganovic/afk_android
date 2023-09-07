// import 'dart:core';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'PaypalServices.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

// // class PaypalPayment extends StatefulWidget {
// //   final Function onFinish;

// //   PaypalPayment({required this.onFinish});

// //   @override
// //   State<StatefulWidget> createState() {
// //     return PaypalPaymentState();
// //   }
// // }

// // class PaypalPaymentState extends State<PaypalPayment> {
// //   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// //   late String checkoutUrl;
// //   late String executeUrl;
// //   late String accessToken;
// //   PaypalServices services = PaypalServices();

// //   // you can change default currency according to your need
// //   Map<dynamic,dynamic> defaultCurrency = {"symbol": "USD ", "decimalDigits": 2, "symbolBeforeTheNumber": true, "currency": "USD"};

// //   bool isEnableShipping = false;
// //   bool isEnableAddress = false;

// //   String returnURL = 'return.example.com';
// //   String cancelURL= 'cancel.example.com';


// //   @override
// //   void initState() {
// //     super.initState();

// //     Future.delayed(Duration.zero, () async {
// //       try {
// //         accessToken = (await services.getAccessToken())!;

// //         final transactions = getOrderParams();
// //         final res =
// //             await services.createPaypalPayment(transactions, accessToken);
// //         if (res != null) {
// //           setState(() {
// //             checkoutUrl = res["approvalUrl"]!;
// //             executeUrl = res["executeUrl"]!;
// //           });
// //         }
// //       } catch (e) {
// //         print('exception: '+e.toString());
// //         final snackBar = SnackBar(
// //           content: Text(e.toString()),
// //           duration: Duration(seconds: 10),
// //           action: SnackBarAction(
// //             label: 'Close',
// //             onPressed: () {
// //               // Some code to undo the change.
// //             },
// //           ),
// //         );
// //         // _scaffoldKey.currentState.showSnackBar(snackBar);
// //       }
// //     });
// //   }

// //   // item name, price and quantity
// //   String itemName = 'iPhone X';
// //   String itemPrice = '1.99';
// //   int quantity = 1;

// //   Map<String, dynamic> getOrderParams() {
// //     List items = [
// //       {
// //         "name": itemName,
// //         "quantity": quantity,
// //         "price": itemPrice,
// //         "currency": defaultCurrency["currency"]
// //       }
// //     ];


// //     // checkout invoice details
// //     String totalAmount = '1.99';
// //     String subTotalAmount = '1.99';
// //     String shippingCost = '0';
// //     int shippingDiscountCost = 0;
// //     String userFirstName = 'Gulshan';
// //     String userLastName = 'Yadav';
// //     String addressCity = 'Delhi';
// //     String addressStreet = 'Mathura Road';
// //     String addressZipCode = '110014';
// //     String addressCountry = 'India';
// //     String addressState = 'Delhi';
// //     String addressPhoneNumber = '+919990119091';

// //     Map<String, dynamic> temp = {
// //       "intent": "sale",
// //       "payer": {"payment_method": "paypal"},
// //       "transactions": [
// //         {
// //           "amount": {
// //             "total": totalAmount,
// //             "currency": defaultCurrency["currency"],
// //             "details": {
// //               "subtotal": subTotalAmount,
// //               "shipping": shippingCost,
// //               "shipping_discount":
// //                   ((-1.0) * shippingDiscountCost).toString()
// //             }
// //           },
// //           "description": "The payment transaction description.",
// //           "payment_options": {
// //             "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
// //           },
// //           "item_list": {
// //             "items": items,
// //             if (isEnableShipping &&
// //                 isEnableAddress)
// //               "shipping_address": {
// //                 "recipient_name": userFirstName +
// //                     " " +
// //                     userLastName,
// //                 "line1": addressStreet,
// //                 "line2": "",
// //                 "city": addressCity,
// //                 "country_code": addressCountry,
// //                 "postal_code": addressZipCode,
// //                 "phone": addressPhoneNumber,
// //                 "state": addressState
// //               },
// //           }
// //         }
// //       ],
// //       "note_to_payer": "Contact us for any questions on your order.",
// //       "redirect_urls": {
// //         "return_url": returnURL,
// //         "cancel_url": cancelURL
// //       }
// //     };
// //     return temp;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     print(checkoutUrl);

// //     if (checkoutUrl != null) {
// //       return Scaffold(
// //         appBar: AppBar(
// //           backgroundColor: Theme.of(context).backgroundColor,
// //           leading: GestureDetector(
// //             child: Icon(Icons.arrow_back_ios),
// //             onTap: () => Navigator.pop(context),
// //           ),
// //         ),
// //         body: WebView(
// //           initialUrl: checkoutUrl,
// //           javascriptMode: JavascriptMode.unrestricted,
// //           navigationDelegate: (NavigationRequest request) {
// //             if (request.url.contains(returnURL)) {
// //               final uri = Uri.parse(request.url);
// //               final payerID = uri.queryParameters['PayerID'];
// //               if (payerID != null) {
// //                 services
// //                     .executePayment(executeUrl, payerID, accessToken)
// //                     .then((id) {
// //                   widget.onFinish!(id);
// //                   Navigator.of(context).pop();
// //                 });
// //               } else {
// //                 Navigator.of(context).pop();
// //               }
// //               Navigator.of(context).pop();
// //             }
// //             if (request.url.contains(cancelURL)) {
// //               Navigator.of(context).pop();
// //             }
// //             return NavigationDecision.navigate;
// //           },
// //         ),
// //       );
// //     } else {
// //       return Scaffold(
// //         key: _scaffoldKey,
// //         appBar: AppBar(
// //           leading: IconButton(
// //               icon: Icon(Icons.arrow_back),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               }),
// //           backgroundColor: Colors.black12,
// //           elevation: 0.0,
// //         ),
// //         body: Center(child: Container(child: CircularProgressIndicator())),
// //       );
// //     }
// //   }
// // }

// // class JavascriptMode {
// //   static var unrestricted;
// // }

// // WebView({required String initialUrl, required javascriptMode, required NavigationDecision Function(NavigationRequest request) navigationDelegate}) {
// // }

// import 'package:paypal_sdk/catalog_products.dart';
// import 'package:paypal_sdk/core.dart';
// import 'package:paypal_sdk/src/webhooks/webhooks_api.dart';
// import 'package:paypal_sdk/subscriptions.dart';
// import 'package:paypal_sdk/webhooks.dart';
// import 'package:paypal_sdk/paypal_sdk.dart';

// const _clientId = 'Abt5WEZlWWlgfNDY54qMnh75onTzr-zi5PzkRMNeabdPzwlmjewNFiNllGzUwrnc6a6RiQZ2EpbCW29r';
// const _clientSecret = 'EHnH9gQP5JhTlxLrhkqJSwnPtNmx_ar4onzSScGacgZQIOSluSMPp6Ezq4t3zxadRAqUW19jBvxyUcmO';

// Future<void> initiatePayPalPayment() async {
//   PayPalConfiguration config = PayPalConfiguration(
//     clientId: "YOUR_CLIENT_ID",
//     environment: PayPalEnvironment.Sandbox, // or PayPalEnvironment.Production
//   );
//   PayPalService.setup(config);

//   PayPalPaymentDetails paymentDetails = PayPalPaymentDetails(
//     subtotal: "10.00",
//     shipping: "0.00",
//     tax: "1.00",
//   );

//   PayPalPayment payment = PayPalPayment(
//     amount: "11.00",
//     currency: "USD",
//     description: "Test Payment",
//     custom: "custom_data",
//     paymentDetails: paymentDetails,
//   );

//   String? result = await PayPalPayment.request(payment);
//   if (result == "SUCCESS") {
//     // Payment successful
//   } else {
//     // Payment canceled or failed
//   }
// }

// void PaypalPayment() async {
//   AccessToken? accessToken; // load existing token here if available

//   var paypalEnvironment = PayPalEnvironment.sandbox(
//       clientId: _clientId, clientSecret: _clientSecret);

//   var payPalHttpClient =
//       PayPalHttpClient(paypalEnvironment, accessToken: accessToken,
//           accessTokenUpdatedCallback: (accessToken) async {
//     // Persist token for re-use
//   });

//   await catalogProductsExamples(payPalHttpClient);
//   await subscriptionExamples(payPalHttpClient);
//   await webhookExamples(payPalHttpClient);
// }

// Future<void> catalogProductsExamples(PayPalHttpClient payPalHttpClient) async {
//   var productsApi = CatalogProductsApi(payPalHttpClient);

//   // Get product details
//   try {
//     var product = await productsApi.showProductDetails('product_id');
//     print(product);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // List products
//   try {
//     var productsCollection = await productsApi.listProducts();

//     for (var product in productsCollection.products) {
//       print(product);
//     }
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Create product
//   try {
//     var createProductRequest = ProductRequest(
//         name: 'test_product',
//         type: ProductType.digital,
//         description: 'test_description');

//     var product = await productsApi.createProduct(createProductRequest);

//     print(product);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Update product
//   try {
//     await productsApi.updateProduct('product_id', [
//       Patch(
//           op: PatchOperation.replace,
//           path: '/description',
//           value: 'Updated description')
//     ]);
//   } on ApiException catch (e) {
//     print(e);
//   }
// }

// Future<void> subscriptionExamples(PayPalHttpClient payPalHttpClient) async {
//   var subscriptionsApi = SubscriptionsApi(payPalHttpClient);

//   // Plans
//   // List plans
//   try {
//     var planCollection = await subscriptionsApi.listPlans();
//     print(planCollection);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Create plan
//   try {
//     var planRequest = PlanRequest(
//         productId: 'PROD-3XF87627UU805523Y',
//         name: 'Test plan',
//         billingCycles: [
//           BillingCycle(
//               pricingScheme: PricingScheme(
//                 fixedPrice: Money(currencyCode: 'GBP', value: '5'),
//               ),
//               frequency: Frequency(
//                 intervalUnit: IntervalUnit.month,
//                 intervalCount: 1,
//               ),
//               tenureType: TenureType.regular,
//               sequence: 1)
//         ],
//         paymentPreferences: PaymentPreferences(
//             autoBillOutstanding: true,
//             setupFee: Money(currencyCode: 'GBP', value: '1.00'),
//             setupFeeFailureAction: SetupFeeFailureAction.cancel,
//             paymentFailureThreshold: 2));
//     var billingPlan = await subscriptionsApi.createPlan(planRequest);
//     print(billingPlan);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Update plan
//   try {
//     await subscriptionsApi.updatePlan('P-6KG67732XY2608640MFGL3RY', [
//       Patch(
//           op: PatchOperation.replace,
//           path: '/description',
//           value: 'Test description')
//     ]);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Show plan details
//   try {
//     var billingPlan =
//         await subscriptionsApi.showPlanDetails('P-6KG67732XY2608640MFGL3RY');
//     print(billingPlan);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Activate plan
//   try {
//     await subscriptionsApi.activatePlan('P-6KG67732XY2608640MFGL3RY');
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Deactivate plan
//   try {
//     await subscriptionsApi.deactivatePlan('P-6KG67732XY2608640MFGL3RY');
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Update plan pricing
//   try {
//     await subscriptionsApi.updatePlanPricing(
//         'P-6KG67732XY2608640MFGL3RY',
//         PricingSchemesUpdateRequest([
//           PricingSchemeUpdateRequest(
//               billingCycleSequence: 1,
//               pricingScheme: PricingScheme(
//                 fixedPrice: Money(currencyCode: 'GBP', value: '5.0'),
//               ))
//         ]));
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Subscriptions
//   // Create subscription
//   try {
//     var createSubscriptionRequest = SubscriptionRequest(
//         planId: 'P-6KG67732XY2608640MFGL3RY', customId: 'custom_id');
//     var subscription =
//         await subscriptionsApi.createSubscription(createSubscriptionRequest);
//     print(subscription);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Update subscription
//   try {
//     await subscriptionsApi.updateSubscription('I-1WSNAWATBCXP', [
//       Patch(
//           op: PatchOperation.add,
//           path: '/custom_id',
//           value: 'updated_custom_id')
//     ]);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Show subscription details
//   try {
//     var subscription =
//         await subscriptionsApi.showSubscriptionDetails('I-1WSNAWATBCXP');
//     print(subscription);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Activate subscription
//   try {} on ApiException catch (e) {
//     print(e);
//   }

//   // Cancel subscription
//   try {
//     await subscriptionsApi.cancelSubscription(
//         'I-93KN27174NGR', 'No longer needed');
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Capture authorized payment on subscription
//   try {
//     var request = SubscriptionCaptureRequest(
//         note: 'Outstanding balance',
//         amount: Money(currencyCode: 'GBP', value: '5.00'));

//     var response = await subscriptionsApi
//         .captureAuthorizedPaymentOnSubscription('I-1WSNAWATBCXP', request);
//     print(response);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Revise plan or quantity of subscription
//   try {
//     var request = SubscriptionReviseRequest(
//         planId: 'P-9DR273747C8107746MFGHYKY',
//         shippingAmount: Money(currencyCode: 'USD', value: '2.0'));

//     var response =
//         await subscriptionsApi.reviseSubscription('I-1WSNAWATBCXP', request);
//     print(response);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Suspend subscription
//   try {
//     var request = Reason('Out of stock');
//     await subscriptionsApi.suspendSubscription('I-1WSNAWATBCXP', request);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // List transactions for subscription
//   try {
//     var response = await subscriptionsApi.listTransactions('I-1WSNAWATBCXP',
//         '2021-09-01T07:50:20.940Z', '2021-09-29T07:50:20.940Z');
//     print(response);
//   } on ApiException catch (e) {
//     print(e);
//   }
// }

// Future<void> webhookExamples(PayPalHttpClient payPalHttpClient) async {
//   var webhooksApi = WebhooksApi(payPalHttpClient);

//   // List webhooks
//   try {
//     var webhooksList = await webhooksApi.listWebhooks();
//     print(webhooksList);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Create webhook
//   try {
//     var webhook =
//         Webhook(url: 'https://api.test.com/paypal_callback', eventTypes: [
//       EventType(name: 'BILLING.SUBSCRIPTION.CREATED'),
//       EventType(name: 'BILLING.SUBSCRIPTION.CANCELLED'),
//     ]);

//     webhook = await webhooksApi.createWebhook(webhook);
//     print(webhook);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Delete webhook
//   try {
//     await webhooksApi.deleteWebhook('1HG80537L4140544T');
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Update webhook
//   try {
//     await webhooksApi.updateWebhook('5B760822JX046254S', [
//       Patch(
//           op: PatchOperation.replace,
//           path: '/url',
//           value: 'https://api.test.com/paypal_callback_new'),
//     ]);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // Show webhook details
//   try {
//     var webhook = await webhooksApi.showWebhookDetails('7BS56736HU608525B');
//     print(webhook);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // List event types for webhook
//   try {
//     var eventTypesList =
//         await webhooksApi.listEventSubscriptionsForWebhook('7BS56736HU608525B');
//     print(eventTypesList);
//   } on ApiException catch (e) {
//     print(e);
//   }

//   // List available events
//   try {
//     var eventTypesList = await webhooksApi.listAvailableEvents();
//     print(eventTypesList);
//   } on ApiException catch (e) {
//     print(e);
//   }
// }