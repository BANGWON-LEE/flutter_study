import 'package:flutter/material.dart';

class MyOndoBody extends  StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return(
        Scaffold(
          body:
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Image.asset(
                      'asset/img/myondo.png'
                  ),
                  // color: Colors.red,
                ),
                Container(
                  // color: Colors.green,
                  child: CircularProgressIndicator(
                  ),
                ),
                Container(
                  // color: Colors.yellow,
                  // width: 100,
                  // height: 80,
                  child: Image.asset(
                    'asset/img/ask_img.png', width: 60.0,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}


