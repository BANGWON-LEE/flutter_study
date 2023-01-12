import 'dart:math';

import 'package:flutter/material.dart';

class TabGame extends StatefulWidget {
  const TabGame({Key? key}) : super(key: key);

  @override
  State<TabGame> createState() => _TabGameState();
}

class _TabGameState extends State<TabGame> {
  List<int> btnCount = [123,456,789];

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: btnCount.map((el) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: el.toString().split('').asMap().entries.map((num) =>
                        // el.toString().split('').shuffle();
                      Padding(
                        padding: EdgeInsets.only(left: num.key  == 0 ? 0 : 10.0, top: 10.0),
                        child: SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: ElevatedButton(
                            onPressed:(){

                            },
                            child:
                              Text(
                              '${num.value}',
                                style: TextStyle(fontSize: 40, color: Colors.white),
                            )
                          ),
                        ),
                      )
                    ).toList(),
                  )).toList(),
                )
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 70.0,
              child: ElevatedButton(
                onPressed: (){
                  List<int> ranArray = [];
                  for(int i = 0; i<3; i++){
                   List<String> line = btnCount[i].toString().split('');
                   line.shuffle();
                   int num = int.parse(line.join());
                   // int num = int.parse();
                    // print(line);
                    ranArray.add(num);
                  }
                  btnCount = ranArray;
                 setState(() {

                    btnCount.shuffle();

                  });
                } ,
                child: Text(
                  '시작',
                  style: TextStyle(fontSize: 40, color: Colors.white),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
