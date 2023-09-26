import 'package:flutter/material.dart';
import 'package:bharatekrishi/Settings/ManageVehical/vehicle_list_screen.dart';

 class VehicalDetails extends StatefulWidget {
    final vehicle deail;
    VehicalDetails(this.deail);
 
   @override
   State<VehicalDetails> createState() => _VehicalDetailsState();
 }
 
 class _VehicalDetailsState extends State<VehicalDetails> {
   @override
   Widget build(BuildContext context) {
     final height =MediaQuery.of(context).size.height;
     final width =MediaQuery.of(context).size.width;
     return Dialog(
       shape:RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(16),
       ),
       elevation: 2,
       backgroundColor: Colors.transparent,
       child:
       Container(
         height: height*0.5,
         padding: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
         decoration: BoxDecoration(
             gradient: LinearGradient(
                 begin: Alignment.centerLeft,
                 end: Alignment.centerRight,
                 colors: [ Color(0xffeafce8),Color(0xffffffff),Color(0xffeafce8)]),
             borderRadius: BorderRadius.circular(5),
             boxShadow: [
               BoxShadow(
                 offset: Offset(0, 1),
                 color: Colors.black.withOpacity(0.5),
                 spreadRadius: 2.5,
                 blurRadius: 3,
               )
             ],
             color: Colors.white
         ),
         child: Column(
           children: [
             SizedBox(height: 10,),
             Text('Vehicle Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20, ),),
             Divider(thickness: 1, color: Colors.black,),
             Text  ( widget.deail.vehicle_no.toString(),style: TextStyle(color: Colors.black,
                 fontWeight: FontWeight.w600, fontSize: 17 ),),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text  ( 'Vehicle : ',style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
                 Text  ( widget.deail.catname.toString(),style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
               ],
             ),
             SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text  ( 'Company : ',style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
                 Text  ( widget.deail.companyname.toString(),style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
               ],
             ),
             SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text  ( 'Model : ',style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
                 Text  ( widget.deail.modelname.toString(),style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
               ],
             ),
             SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text  ( 'Overspeeding : ',style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
                 Text  ( widget.deail.overspeeding.toString(),style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
               ],
             ),
             SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text  ( 'Overheating : ',style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
                 Text  ( widget.deail.overheathing.toString(),style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
               ],
             ),
             SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text  ( 'Total hour : ',style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
                 Text  ( widget.deail.initial_engine.toString(),style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
               ],
             ),
             SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text  ('Pass code : ',style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
                 Text  (widget.deail.passcode=='null'?'add pass code':'${widget.deail.passcode}',
                   style: TextStyle(color: Colors.black,
                       fontWeight: FontWeight.w600, fontSize: 17 ),),
               ],
             ),
             // SizedBox(height: 10,),
             // Row(
             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
             //   crossAxisAlignment: CrossAxisAlignment.start,
             //   children: [
             //     Text  ( 'Manager : ',style: TextStyle(color: Colors.black,
             //         fontWeight: FontWeight.w600, fontSize: 17 ),),
             //     Text  ( widget.deail.Managername.toString(),style: TextStyle(color: Colors.black,
             //         fontWeight: FontWeight.w600, fontSize: 17 ),),
             //   ],
             // ),
             // SizedBox(height: 10,),
             // Row(
             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
             //   crossAxisAlignment: CrossAxisAlignment.start,
             //   children: [
             //     Text  ( 'Manager No : ',style: TextStyle(color: Colors.black,
             //         fontWeight: FontWeight.w600, fontSize: 17 ),),
             //     Text  ( widget.deail.Managermobile.toString(),style: TextStyle(color: Colors.black,
             //         fontWeight: FontWeight.w600, fontSize: 17 ),),
             //   ],
             // ),
             SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text  ( 'Divice No : ',style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
                 Text  ( widget.deail.devices_id.toString(),style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.w600, fontSize: 17 ),),
               ],
             ),
             SizedBox(height: 10,),
             InkWell(
               onTap: () {
                 Navigator.pop(context);
               },
               child: Container(
                   height: height*0.05,
                   width: width*0.4,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.grey.shade600,
                         spreadRadius: 1,
                         blurRadius: 1,
                         offset: Offset(1, 1),
                       ),
                       BoxShadow(
                           color: Colors.white,
                           offset: Offset(-5, -5),
                           blurRadius: 15,
                           spreadRadius: 1),
                     ],
                     gradient: LinearGradient(
                       begin: Alignment.topLeft,
                       end: Alignment.bottomRight,
                       colors: [
                         Colors.green.shade200,
                         Colors.green.shade300,
                         Colors.green.shade400,
                         Colors.green.shade500,
                       ],
                     ),
                   ),
                   child: Center(
                       child: Text(
                         'Ok',
                         style: TextStyle(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                             color: Colors.white),
                       ))),
             ),
           ],
         ),
       )
     );
   }
 }
 