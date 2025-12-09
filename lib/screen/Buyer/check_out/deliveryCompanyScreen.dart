// // ignore_for_file: file_names
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:fils/controller/provider/app_notifire.dart';
// import 'package:fils/utils/storage/storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fils/controller/provider/cart_notifire.dart';
// import 'package:fils/utils/const.dart';
// import 'package:fils/utils/enum/message_type.dart';
// import 'package:fils/utils/message_app/show_flash_message.dart';
// import 'package:fils/utils/theme/color_manager.dart';
// import 'package:fils/widget/button_widget.dart';
// import 'package:fils/widget/defulat_text.dart';
// import 'package:fils/widget/item_back.dart';
//
// import 'package:provider/provider.dart';
//
// class DeliveryCompanyScreen extends StatefulWidget {
//   const DeliveryCompanyScreen({super.key});
//
//   @override
//   State<DeliveryCompanyScreen> createState() => _DeliveryCompanyScreenState();
// }
//
// class _DeliveryCompanyScreenState extends State<DeliveryCompanyScreen> {
//   @override
//   void initState() {
//     context.read<CartNotifire>().deliveryCompaniList.forEach((element) {
//       element.select = false;
//     });
//     context.read<CartNotifire>().deliveryCompaniesModelSelect = null;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer2<CartNotifire , AppNotifire>(
//       builder: (context, cart,app, child) {
//         return Scaffold(
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//           ),
//           body: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Column(
//                 children: [
//                   itemBackAndTitle(context, title: "Delivery companies".tr()),
//                   SizedBox(height: heigth * 0.05),
//                   ...List.generate(
//                     cart.deliveryCompaniList.length,
//                     (index) => GestureDetector(
//                       onTap: () {
//                         cart.selectDeliveryCompany(
//                             cart.deliveryCompaniList[index]);
//                       },
//                       child: Container(
//                         height: heigth * 0.12,
//                         margin: const EdgeInsets.only(bottom: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: const Color(0xffFAFAFA)),
//                           color:getTheme()?Colors.black: const Color(0xffFAFAFA),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 7),
//                           child: Row(
//                             children: [
//                               Image.asset(
//                                 cart.deliveryCompaniList[index].pathImage!,
//                               ),
//                               SizedBox(width: width * 0.03),
//                               Expanded(
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           DefaultText(
//                                             cart.deliveryCompaniList[index]
//                                                 .name!,
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w600,
//                                             color:getTheme()?white:  blackColor,
//                                           ),
//                                           SizedBox(height: heigth * 0.01),
//                                           DefaultText(
//                                             cart.deliveryCompaniList[index]
//                                                 .address!,
//                                             fontSize: 8,
//                                             fontWeight: FontWeight.w400,
//                                             color:getTheme()?white:  textColor,
//                                           ),
//                                           SizedBox(height: heigth * 0.01),
//                                           DefaultText(
//                                             "${cart.deliveryCompaniList[index].price}${app.currancy}",
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.w500,
//                                             color: secondColor,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       height: 25,
//                                       width: 25,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(50),
//                                         border: Border.all(color: grey2),
//                                       ),
//                                       child: cart.deliveryCompaniList[index]
//                                               .select!
//                                           ? Padding(
//                                               padding: const EdgeInsets.all(3),
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   color: purpleColor,
//                                                   borderRadius:
//                                                       BorderRadius.circular(50),
//                                                 ),
//                                               ),
//                                             )
//                                           : null,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           bottomSheet: Padding(
//             padding: const EdgeInsets.all(12),
//             child: ButtonWidget(
//               colorButton: secondColor,
//               title: "CONTINUO".tr(),
//               sizeTitle: 16,
//               fontType: FontType.SemiBold,
//               onTap: () {
//                 if (cart.deliveryCompaniesModelSelect == null) {
//                   showCustomFlash(
//                       message: "Please Select Delivery Company".tr(),
//                       messageType: MessageType.Faild);
//                 } else {
//                   cart.functionGetPaymentMethode();
//                 }
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
