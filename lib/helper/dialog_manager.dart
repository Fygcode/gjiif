// import 'package:flutter_svg/svg.dart';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../core/res/colors.dart';
// import '../core/res/spacing.dart';
// import '../locator.dart';
// import '../services/dialog_service.dart';
// import '../ui/widgets/button.dart';
//
// class DialogManager extends StatefulWidget {
//   final Widget child;
//
//   const DialogManager({required this.child});
//
//   _DialogManagerState createState() => _DialogManagerState();
// }
//
// class _DialogManagerState extends State<DialogManager> {
//   final _dialogService = locator<DialogService>();
//
//   @override
//   void initState() {
//     super.initState();
//     _dialogService.registerDialogListener(
//       _showInfoDialog,
//       _showCustomAlertDialog,
//       _showConfirmationDialog,
//       _bottomSheet,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned(left: 0, right: 0, top: 0, bottom: 0, child: widget.child),
//       ],
//     );
//   }
//
//   void _showInfoDialog(AlertRequest request) {
//     showCupertinoDialog(
//         context: context,
//         barrierDismissible: request.dismissable,
//         builder: (context) {
//           return WillPopScope(
//               onWillPop: () async {
//                 _dialogService.dialogComplete(AlertResponse(status: false));
//                 return false;
//               },
//               child: CupertinoAlertDialog(
//                 title: Text(
//                   request.title ?? '',
//                   style: const TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w500,
//                       color: AppColor.divider,
//                       letterSpacing: 0.5),
//                 ),
//                 content: Text(request.description ?? '',
//                     style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.normal,
//                         color: AppColor.divider,
//                         letterSpacing: 0.5)),
//                 actions: <Widget>[
//                   CupertinoDialogAction(
//                     child: Text(
//                       request.buttonTitle ?? '',
//                       style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500,
//                           color: AppColor.primary,
//                           letterSpacing: 0.5),
//                     ),
//                     onPressed: () {
//                       _dialogService
//                           .dialogComplete(AlertResponse(status: true));
//                     },
//                   ),
//                 ],
//               ));
//         });
//   }
//
//   void _showConfirmationDialog(AlertRequest request) {
//     showCupertinoDialog(
//         context: context,
//         builder: (context) {
//           return WillPopScope(
//               onWillPop: () async {
//                 _dialogService.dialogComplete(AlertResponse(status: false));
//                 return false;
//               },
//               child: CupertinoAlertDialog(
//                 title: Text(
//                   request.title ?? '',
//                   style: const TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w500,
//                       color: AppColor.divider,
//                       letterSpacing: 0.5),
//                 ),
//                 content: Text(request.description ?? '',
//                     style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.normal,
//                         color: AppColor.divider,
//                         letterSpacing: 0.5)),
//                 actions: <Widget>[
//                   if (request.secondaryButtonTitle != null)
//                     CupertinoDialogAction(
//                       child: Text(
//                         request.secondaryButtonTitle ?? '',
//                         style: const TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.normal,
//                             color: AppColor.primary,
//                             letterSpacing: 0.5),
//                       ),
//                       onPressed: () {
//                         _dialogService
//                             .dialogComplete(AlertResponse(status: false));
//                       },
//                     ),
//                   CupertinoDialogAction(
//                     child: Text(
//                       request.buttonTitle ?? '',
//                       style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500,
//                           color: AppColor.primary,
//                           letterSpacing: 0.5),
//                     ),
//                     onPressed: () {
//                       _dialogService
//                           .dialogComplete(AlertResponse(status: true));
//                     },
//                   ),
//                 ],
//               ));
//         });
//   }
//
//   void _showCustomAlertDialog(AlertRequest request) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return WillPopScope(
//             onWillPop: () {
//               return Future.value(false);
//             },
//             child:   AlertDialog(
//               key: request.key,
//               shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(12.0))),
//               content: Container (
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16)
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SvgPicture.asset(request.image ?? ""),
//                     VerticalSpacing.custom(value: request.image != null ? 24 : 0),
//                     Text(request.title ?? "",style: AppTextStyle.title,),
//                     VerticalSpacing.custom(value: 12),
//                     Text(request.description ?? "",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xff414141)) ,textAlign: TextAlign.center,),
//                     VerticalSpacing.custom(value: 20),
//                     Button(request.buttonTitle ?? "", key: UniqueKey(),  onPressed: () async {
//                       _dialogService.dialogComplete(AlertResponse(status: true ));
//                     }),
//                     VerticalSpacing.custom(value: 12),
//                     request.secondaryButtonTitle != null ?
//                     Button(request.secondaryButtonTitle ?? "", key: UniqueKey(),
//                         color: AppColor.grey,
//                         textStyle:const TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Color(0xff312D4A)),
//                         onPressed: () async {
//                           _dialogService.dialogComplete(AlertResponse(status: false));
//                         })
//                         : Container(),
//                   ],
//                 ),
//               ) ,
//
//             ),
//           );
//         });
//   }
//
//   void _bottomSheet(AlertRequest request) {
//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         isDismissible: true,
//         //barrierColor: AppColor.primary,
//         backgroundColor: Colors.transparent,
//         useRootNavigator: true,
//         builder: (context) => Container(
//           padding: MediaQuery.of(context).viewInsets,
//           margin: EdgeInsets.only(
//               top: MediaQuery.of(context).viewPadding.bottom > 0
//                   ? MediaQuery.of(context).viewPadding.bottom
//                   : 25),
//           decoration: const BoxDecoration(
//             color: AppColor.background,
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(15),
//                 topRight: Radius.circular(15)),
//           ),
//           child: Wrap(
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: Container(
//                   height: 4.0,
//                   width: 24.0,
//                   margin: const EdgeInsets.only(top: 8.0),
//                   decoration: const BoxDecoration(
//                     color: AppColor.textOnBackground,
//                     borderRadius: BorderRadius.all(Radius.circular(2.0)),
//                   ),
//                 ),
//               ),
//               if (request.showActionBar == true)
//                 Padding(
//                   padding:
//                   const EdgeInsets.only(left: 15, right: 5, top: 5),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (request.iconWidget != null)
//                         Padding(
//                           padding: const EdgeInsets.only(right: 10),
//                           child: request.iconWidget,
//                         ),
//                       Expanded(
//                           child: request.title == null
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 10, bottom: 10),
//                             child: Text(
//                               request.title ?? '',
//                               textScaleFactor: 1,
//                             ),
//                           )),
//                       if (request.showCloseIcon == true)
//                         IconButton(
//                           onPressed: () {
//                             _dialogService.dialogComplete(
//                                 AlertResponse(status: false));
//                           },
//                           icon: Container(
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.black12,
//                             ),
//                             padding: const EdgeInsets.all(5),
//                             child: const Icon(
//                               Icons.close,
//                               size: 20,
//                               color: Colors.black54,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               SingleChildScrollView(
//                   child: Wrap(
//                     children: [
//                       SafeArea(child: request.contentWidget ?? Container()),
//                     ],
//                   )),
//             ],
//           ),
//         ));
//   }
// }