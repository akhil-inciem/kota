
// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class MyActionScreen extends StatefulWidget {
//   const MyActionScreen({super.key});

//   @override
//   State<MyActionScreen> createState() => _MyActionScreenState();
// }

// class _MyActionScreenState extends State<MyActionScreen> {

//   DateTime _selectedDate = DateTime.now();
//   late DateTime _firstDayOfMonth;
//   late DateTime _lastDayOfMonth;
//   late int _daysInMonth;
//   late List<int> _years;
//   final List<String> _months = List.generate(12, (i) => DateFormat.MMMM().format(DateTime(0, i + 1)));
//   late PageController _pageController;
  
//   List<Data> myActionList = [];
//   List<ZoomDateModel> zoomList = [];

//   List<bool> isChecked = [];

//   bool isAttendanceMarked = true;
//   bool isAttendanceFetching = true;

//   currentCourse.StudentCurrentCourseResponse? currentCourseDetails;

//   var notificationController = Get.put(NotificationController());


//   @override
//   void initState() {
//     _updateCalendar(_selectedDate);
//     _years = List.generate(101, (index) => 2000 + index);
//     _pageController = PageController(initialPage: _selectedDate.month - 1);
//     getCurrentCourse();
//     super.initState();
//   }


//   @override
//   Widget build(BuildContext context) {
//     double deviceWidth = MediaQuery.of(context).size.width;
//     return Obx(()=>Scaffold(
//         backgroundColor: StaticColors.staticBackground,
//         appBar: CustomAppBar(
//           context,
//           "My Actions",
//           [
//             if(notificationController.batchId.value != '0')
//               GestureDetector(
//                 child: Padding(
//                   padding: EdgeInsets.only(right: 1.5.h),
//                   child: Image.asset(
//                     notificationController.notification.value == true ? "assets/icons/zoom.png"  : "assets/icons/zoom_unread.png",
//                     width: 10.w,
//                     color: Colors.white,
//                   ),
//                 ),
//                 onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => const ZoomNotificationScreen()),
//                   );
//                 },
//               ),
//             GestureDetector(
//               child: Padding(
//                 padding: EdgeInsets.only(right: 1.5.h),
//                 child: Image.asset(
//                   notificationController.notification.value == true ? "assets/icons/empty_notification.png"  : "assets/icons/notification_icon.png",
//                   width: 5.w,
//                   height: 3.h,
//                 ),
//               ),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 5.w),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 90.w,
//                     height: deviceWidth < 500 ? 42.h : 55.h,
//                     padding: EdgeInsets.all(15.sp),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       color: StaticColors.staticSecondaryBlack,
//                     ),
//                     child: customCalendar(),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 3.h,
//                 ),
//                   if(!isAttendanceFetching && currentCourseDetails != null && currentCourseDetails!.batchStartDate != null)
//                  !isDateInRange(_selectedDate,currentCourseDetails!.batchStartDate,currentCourseDetails!.batchEndDate) ? SizedBox() : Container(
//                     padding: const EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         color: StaticColors.staticSecondaryBlack
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         ImageIcon(const AssetImage('assets/icons/attendance_icon.png'),color: StaticColors.staticGradientYellow,size: 25.sp,),
//                         SizedBox(width: 5.w,),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(isAttendanceMarked ? "Attendance marked" : 'Attendance not marked',
//                               style: TextStyle(
//                                   fontSize: 16.sp, color: Colors.white,
//                                   fontWeight: FontWeight.w600
//                               ),),
//                             SizedBox(height: 0.5.h,),

//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 SizedBox(
//                   height: 2.h,
//                 ),
//                 if(zoomList.isNotEmpty)
//                 Text("Classes on ${DateFormat('MMMM dd  yyyy').format(_selectedDate)}",
//                   style: TextStyle(
//                       fontSize: 17.sp, color: StaticColors.staticLabelWhite,fontWeight: FontWeight.w600),),
//                 // if(DateFormat('ddMMyyyy').format(_selectedDate) != DateFormat('ddMMyyyy').format(DateTime.now()))
//                   SizedBox(
//                     height: 1.h,
//                   ),
//                 ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: zoomList.length,
//                     itemBuilder: (context, index) {
//                       isChecked.add(false);
//                       return  GestureDetector(
//                         onTap: (){
//                           launchUrl(Uri.parse('${zoomList[index].url}'));
//                         },
//                         child: Container(
//                           margin: EdgeInsets.only(bottom: 1.h),
//                           padding: const EdgeInsets.all(15),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               color: StaticColors.staticSecondaryBlack
//                           ),
//                           child: Row(
//                             children: [
//                               ImageIcon(const AssetImage('assets/icons/zoom.png'),color: StaticColors.staticGradientYellow,size: 25.sp,),
//                               SizedBox(width: 5.w,),
//                               Expanded(
//                                 child: Row(
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         SizedBox(
//                                           width: 57.w,
//                                           child: Text(zoomList[index].title,
//                                             style: TextStyle(
//                                                 fontSize: 15.sp, color: Colors.white,
//                                                 fontWeight: FontWeight.w600
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 0.5.h,),
//                                         zoomList[index].isAttended == 'attended' ?  Text('Attended',
//                                           style: TextStyle(
//                                             fontFamily: 'Poppins',
//                                             fontSize: 14.sp, color: Colors.grey,),)
//                                             : DateTime.parse(zoomList[index].dateTime).isBefore(DateTime.now().subtract(const Duration(hours: 24))) ?
//                                         Text("Not attended",
//                                           style: TextStyle(
//                                             fontFamily: 'Poppins',
//                                             fontSize: 14.sp, color: Colors.grey,),) :
//                                         Row(
//                                           children: [
//                                             Text("Join meeting on: ",
//                                               style: TextStyle(
//                                                 fontFamily: 'Poppins',
//                                                 fontSize: 14.sp, color: Colors.grey,),),
//                                             Text(DateFormat('hh:mm a').format(DateTime.parse('${zoomList[index].dateTime}')),
//                                               style: TextStyle(
//                                                 fontFamily: 'Poppins',
//                                                 fontSize: 14.sp, color: StaticColors.staticLabelWhite,),),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     if(!DateTime.parse(zoomList[index].dateTime).isBefore(DateTime.now().subtract(const Duration(hours: 24))) && !DateTime.parse(zoomList[index].dateTime).isAfter(DateTime.now()))
//                                       Checkbox(shape: const CircleBorder(side: BorderSide(color: Colors.white)),
//                                         activeColor: StaticColors.staticGradientYellow,
//                                         value: isChecked[index],
//                                         onChanged: (bool? value) {
//                                           setState(() {
//                                             isChecked[index] = value!;
//                                           });
//                                           if(value == true){
//                                             markZoomAttendance(zoomList[index].id,index);
//                                           }
//                                         },
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }),
//                 // SizedBox(height: 2.5.h,),
//                 // ListView.builder(
//                 //   shrinkWrap: true,
//                 //   physics: const NeverScrollableScrollPhysics(),
//                 //   itemCount: myActionList.length,
//                 //   itemBuilder: (context, index) {
//                 //     return Row(
//                 //       mainAxisAlignment: MainAxisAlignment.start,
//                 //       crossAxisAlignment: CrossAxisAlignment.center,
//                 //       children: [
//                 //         Text(DateTime.parse('${myActionList[index].completionDate}').toLocal().isAfter(DateTime.now().subtract(const Duration(minutes: 5))) ? "Now"
//                 //             : DateFormat('hh.mm a').format(DateTime.parse('${myActionList[index].completionDate}').toLocal()) ,
//                 //           style: TextStyle(
//                 //               fontSize: 15.sp,
//                 //               color: StaticColors.staticLabelWhite
//                 //           ),
//                 //         ),
//                 //         SizedBox(width: 4.w,),
//                 //         Expanded(
//                 //           child: Container(
//                 //             padding: EdgeInsets.all(15.sp),
//                 //             decoration: BoxDecoration(
//                 //                 borderRadius: BorderRadius.circular(12),
//                 //                 color: StaticColors.staticSecondaryBlack,border: Border.all(color: StaticColors.staticYellow)
//                 //             ),
//                 //             child: Row(
//                 //               mainAxisAlignment: MainAxisAlignment.start,
//                 //               crossAxisAlignment: CrossAxisAlignment.start,
//                 //               children: [
//                 //                 Expanded(
//                 //                   child: Column(
//                 //                     mainAxisAlignment: MainAxisAlignment.start,
//                 //                     crossAxisAlignment: CrossAxisAlignment.start,
//                 //                     children: [
//                 //                       SizedBox(
//                 //                         //width: 50.w,
//                 //                         height: 5.h,
//                 //                         child: Text(
//                 //                           "${myActionList[index].chapterName}",
//                 //                           style: TextStyle(
//                 //                               color: StaticColors.staticLabelWhite,
//                 //                               fontSize: 17.sp,
//                 //                               fontWeight: FontWeight.w500),
//                 //                         ),
//                 //                       ),
//                 //
//                 //                       Text(
//                 //                         "${myActionList[index].unitName}",
//                 //                         style: TextStyle(
//                 //                             color: StaticColors.staticGrey,
//                 //                             fontSize: 16.sp,
//                 //                             fontWeight: FontWeight.w400),
//                 //                       ),
//                 //                     ],
//                 //                   ),
//                 //                 ),
//                 //               ],
//                 //             ),
//                 //           ),
//                 //         ),
//                 //       ],
//                 //     );
//                 //   },
//                 // ),
//               ],
//             ),
//           ),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//         floatingActionButton: currentCourseDetails != null && isDateInRangeAndToday(_selectedDate,currentCourseDetails!.batchStartDate,currentCourseDetails!.batchEndDate) && !isAttendanceMarked && !isAttendanceFetching ? GestureDetector(
//           onTap: (){
//             markAttendance();
//           },
//           child: Container(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: StaticColors.staticGradientYellow
//             ),
//             padding: const EdgeInsets.all(10),
//             child: Text(
//               'Mark Attendance',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 15.sp
//               ),
//             ),
//           ),
//         ) : null
//     ));
//   }


//   void _onSwipe(int page) {
//     int currentYear = _selectedDate.year;
//     int currentMonth = _selectedDate.month;
//     int totalMonths = (currentYear - 2000) * 12 + currentMonth - 1;
//     int newTotalMonths = totalMonths + (page - (_selectedDate.month - 1));
//     int newYear = 2000 + (newTotalMonths ~/ 12);
//     int newMonth = (newTotalMonths % 12) + 1;
//     _updateCalendar(DateTime(newYear, newMonth, 1));
//   }

//   void _showYearMonthPickerDialog({required BuildContext context, required int initialYear, required int initialMonth,}) {
//     // Variables to store the selected year and month
//     int selectedYear = initialYear;
//     int selectedMonth = initialMonth;

//     // Dialog to pick year and month
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           backgroundColor: StaticColors.staticSecondaryBlack,
//           child: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return Container(
//                 height: 50.h,
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 1.h),
//                     const Text(
//                       "Select Year and Month",
//                       style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
//                     ),
//                     SizedBox(height: 2.h),
//                     Expanded(
//                       child: Row(
//                         children: [
//                           // Year Picker
//                           Expanded(
//                             child: ListWheelScrollView.useDelegate(
//                               itemExtent: 40,
//                               physics: const FixedExtentScrollPhysics(),
//                               controller: FixedExtentScrollController(
//                                 initialItem: _years.indexOf(initialYear), // Start with the current year
//                               ),
//                               onSelectedItemChanged: (index) {
//                                 setState(() {
//                                   selectedYear = _years[index];
//                                 });
//                               },
//                               childDelegate: ListWheelChildBuilderDelegate(
//                                 builder: (context, index) {
//                                   bool isSelected = _years[index] == selectedYear; // Check if it's selected
//                                   return Center(
//                                     child: Text(
//                                       _years[index].toString(),
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                         color: isSelected ? Colors.white : Colors.grey, // Highlight selected year
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 childCount: _years.length,
//                               ),
//                             ),
//                           ),
//                           // Month Picker
//                           Expanded(
//                             child: ListWheelScrollView.useDelegate(
//                               itemExtent: 40,
//                               physics: const FixedExtentScrollPhysics(),
//                               controller: FixedExtentScrollController(
//                                 initialItem: initialMonth - 1, // Start with the current month (0-based)
//                               ),
//                               onSelectedItemChanged: (index) {
//                                 setState(() {
//                                   selectedMonth = index + 1; // Adjust for 1-based month
//                                 });
//                               },
//                               childDelegate: ListWheelChildBuilderDelegate(
//                                 builder: (context, index) {
//                                   bool isSelected = (index + 1) == selectedMonth; // Check if it's selected
//                                   return Center(
//                                     child: Text(
//                                       _months[index],
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                         color: isSelected ? Colors.white : Colors.grey, // Highlight selected month
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 childCount: _months.length,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 3.h),
//                     GestureDetector(
//                       child: Center(
//                         child: Container(
//                           width: 40.w,
//                           padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                               colors: [
//                                 StaticColors.staticGradientYellow,
//                                 StaticColors.staticGradientDark,
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Center(
//                             child: Text(
//                               "Submit",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   color: StaticColors.staticBackground,
//                                   fontFamily: "Poppins",
//                                   fontSize: 15.sp,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                           ),
//                         ),
//                       ),
//                       onTap: () {

//                         _pageController.jumpToPage(selectedMonth - 1);

//                         // After selecting year and month, update the calendar view in parent widget
//                         _updateCalendar(DateTime(selectedYear, selectedMonth, 1));

//                         // Close the dialog
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   void _updateCalendar(DateTime date) {
//     setState(() {
//       _selectedDate = date;
//       getMyActionsList();
//       _firstDayOfMonth = DateTime(date.year, date.month, 1);
//       _lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
//       _daysInMonth = _lastDayOfMonth.day;
//     });
//   }

//   void getMyActionsList() async{
//     getStudentAttendance();
//     getZoomList();
//     var body = json.encode({
//       "date": DateFormat('yyyy-mm-dd').format(_selectedDate)
//     });
//     var response = await Api.getMyActions(body);
//     if(response != null && response.statuscode == 200){
//       myActionList.addAll(response.data ?? <Data>[]);
//     }

//   }

//   void getZoomList() async{
//     var body = json.encode({
//       "date": '${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
//       "batch_id": notificationController.batchId.value
//     });
//     var response = await Api.getZoomByDate(body);
//     if(response != null && response.data != null){
//       zoomList.clear();
//       print(response.data!.length);
//       for(int i=0;i<response.data!.length;i++){
//         setState(() {
//           zoomList.add(ZoomDateModel(
//               id:response.data![i].sId ?? '',
//               title: response.data![i].title ?? '',
//               url: response.data![i].link ?? '',
//               dateTime: response.data![i].dateNTime ?? '',
//               isAttended: response.data![i].attendanceStatus ?? ''
//           ));
//         });
//       }
//     }
//   }

//   void markZoomAttendance (zoomId,index)async{
//     var body = json.encode({
//       "_id":"$zoomId",
//       "batch_id": notificationController.batchId.value
//     });

//     var response = await Api.markZoomAttendance(body);
//     if(response!.success == true){
//       Common.toast('Zoom attendance marked');
//       setState(() {
//         zoomList[index].isAttended = 'Attended';
//       });
//     }else{
//       Common.toast('${response.message}');
//     }
//   }

//   void getStudentAttendance() async{
//     setState(() {
//       isAttendanceFetching = true;
//     });
//     var response = await Api.getCurrentAttendanceStatus(_selectedDate);
//     if(response != null && response.statuscode == 200){
//       setState(() {
//         isAttendanceMarked = true;
//         isAttendanceFetching = false;

//       });
//     }else{
//       setState(() {
//         isAttendanceMarked = false;
//         isAttendanceFetching = false;
//       });
//     }

//   }


//   void getCurrentCourse()async{
//     Get.log('current course');
//     var response = await Api.getCurrentCourse();
//     if(response!.statuscode == 200 && response.courseDetails != null){
//       setState(() {
//         currentCourseDetails = response;
//       });
//     }
//     getMyActionsList();
//     getZoomList();
//     getStudentAttendance();
//   }

//   void markAttendance() async{
//     var response = await Api.markAttendance('${currentCourseDetails!.courseDetails!.sId}');
//     print(response);
//     if(response == 'Success'){
//       setState(() {
//         isAttendanceMarked = true;
//       });
//       Common.toast('Attendance marked');
//     }else if(response == 'Error'){
//       Common.toast('Something went wrong.');
//     }
//     // else{
//     //   Common.toast('$response');
//     // }
//   }

//   bool isDateInRangeAndToday(DateTime selectedDate,startDate,endDate) {
//     if(startDate == null || endDate == null){
//       return false;
//     }else{
//       DateTime batchStartDate = DateTime.parse("$startDate").toLocal();
//       DateTime batchEndDate = DateTime.parse("$endDate").toLocal();
//       DateTime today = DateTime.now();
//       bool isInRange = selectedDate.isAfter(batchStartDate.subtract(Duration(days: 1))) && selectedDate.isBefore(batchEndDate.add(Duration(days: 1)));
//       bool isToday = selectedDate.year == today.year &&
//           selectedDate.month == today.month &&
//           selectedDate.day == today.day;
//       print(isInRange && isToday);
//       return isInRange && isToday;
//     }
//   }

//   bool isDateInRange(DateTime selectedDate,startDate,endDate) {
//     if(startDate == null || endDate == null){
//       return false;
//     }else{
//       DateTime batchStartDate = DateTime.parse("$startDate").toLocal();
//       DateTime batchEndDate = DateTime.parse("$endDate").toLocal();
//       bool isInRange = selectedDate.isAfter(batchStartDate.subtract(Duration(days: 1))) && selectedDate.isBefore(batchEndDate);
//       print(isInRange);
//       return isInRange;
//     }
//   }

// }

