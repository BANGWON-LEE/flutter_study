import 'dart:math';

import 'package:flutter/material.dart';

class TabGame extends StatefulWidget {
  const TabGame({Key? key}) : super(key: key);

  @override
  State<TabGame> createState() => _TabGameState();

}

class _TabGameState extends State<TabGame> {

  @override
  void dispose() {
    // TODO: implement dispose
    print('dispose 실행');
    super.dispose();
  }

  // List<int> btnCount = [123,456,789];
  var btnCount = [['1','2','3'],['4','5','6'],['7','8','9']];
  List gameCount = ['1','2','3','4','5','6','7','8','9'];
  List choiceCount = [];
  // var btnCount = [[1,2,3],[4,5,6],[7,8,9]];
  bool startSignal = false;
  int cnt  = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top:100.0),
              child: Column(
                children: [
                  Container(
                    child: startSignal == false ? null : Text('${gameCount}', style:TextStyle(fontSize: 40, color: Colors.black)),
                  ),
                  Container(
                    child: startSignal == false ? null : Text('${choiceCount}', style:TextStyle(fontSize: 40, color: Colors.black)),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: btnCount.map((el) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: el.map((num) =>
                        // el.toString().split('').shuffle();
                      Padding(
                        padding: EdgeInsets.only(left:  10.0, top: 10.0),
                        child: SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: ElevatedButton(
                            onPressed:(){


                              setState(() {
                                cnt = cnt+1;
                                choiceCount.add(num);
                              });

                              if(gameCount[cnt] != choiceCount[cnt]){
                                choiceCount.remove(choiceCount[cnt]);
                                cnt = cnt - 1;
                              }

                              if(cnt == 8 && gameCount[8] == choiceCount[8]){
                                startSignal = false;
                                choiceCount.clear();
                                // dispose();
                              }
                              print('cnt ${cnt}');



                            },
                            child:
                              Text(
                              '${num}',
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
              child: startSignal == true ? null : ElevatedButton(
                onPressed: (){
                  List<List<String>> resultArray = [[],[],[]];
                  List mix = btnCount.reduce((acr,cur) => [...acr, ...cur]);
                  mix.shuffle();

                  int j = 0;
                  int z = 0;

                 for(int i = 0; i<=2; i++){
                    for(j = j; j<=(2+z); j++){
                      resultArray[i].add(mix[j]);
                    }
                    z = z + 3;
                 }
                  btnCount = resultArray;
                 setState(() {
                    btnCount.shuffle();
                    gameCount.shuffle();
                    startSignal = true;
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
