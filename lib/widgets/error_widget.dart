import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 40.w,
            color: Colors.red,
          ),
          Text(
            "Error!! cannot take the Data",
            style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: "Agbalumo"),
          )
        ],
      ),
    );
  }
}
