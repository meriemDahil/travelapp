import 'package:flutter/material.dart';

class ListProfile extends StatelessWidget{

  final String title ;
  final IconData icon;
  final VoidCallback onPressed;
  final bool endicon;
  final Color? textcolor;

  const ListProfile({super.key,  required this.title, required this.icon, required this.onPressed, required this.endicon, this.textcolor});
  
  @override
  Widget build(BuildContext context) {
    return   ListTile(
      onTap: onPressed,
      leading: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.white,),
        child:Icon(icon , size: 28, color: Colors.black,),

      ),
      title:Text(title,style:  TextStyle(color: textcolor , fontSize: 18.0, fontWeight: FontWeight.w400,letterSpacing: 0.7,fontFamily: 'Roboto'),),

      trailing: endicon? Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.grey.shade200,),
        child:const Icon(Icons.arrow_right),
      ):null,
    );
  }
  

}