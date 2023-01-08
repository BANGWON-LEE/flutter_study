import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (
      Scaffold(
        body:
          Container(
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        color: Colors.red,
                        width: 50,
                        height: 50,
                      ),
                      Container(
                        color: Colors.orange,
                        width: 50,
                        height: 50,
                      ),
                      Container(
                        color: Colors.yellow,
                        width: 50,
                        height: 50,
                      ),
                      Container(
                        color: Colors.green,
                        width: 50,
                        height: 50,
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  ),
                ),
                Container(
                  child: Center(
                    child:
                    Container(
                      color: Colors.orange,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        color: Colors.red,
                        width: 50,
                        height: 50,
                      ),
                      Container(
                        color: Colors.orange,
                        width: 50,
                        height: 50,
                      ),
                      Container(
                        color: Colors.yellow,
                        width: 50,
                        height: 50,
                      ),
                      Container(
                        color: Colors.green,
                        width: 50,
                        height: 50,
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                ),
                Container(
                  child: Center(
                    child:
                    Container(
                      color: Colors.green,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),
      )
    );
  }
}
