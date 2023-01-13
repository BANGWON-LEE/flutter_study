import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';

class TabGame extends StatefulWidget {
  const TabGame({Key? key}) : super(key: key);

  @override
  State<TabGame> createState() => _TabGameState();

}

class _TabGameState extends State<TabGame> {
  Timer? _timer;
  var _time = 0;
  // List<int> btnCount = [123,456,789];
  var btnCount = [['1','2','3'],['4','5','6'],['7','8','9']];
  List gameCount = ['1','2','3','4','5','6','7','8','9'];
  List choiceCount = [];
  // var btnCount = [[1,2,3],[4,5,6],[7,8,9]];
  bool startSignal = false;
  int cnt  = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    print('dispose 실행');
    choiceCount.clear();
    super.dispose();
  }

  void _startTime(){
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        setState(() {
          _time++;
        });
    });
  }

  void _stopTime(){
    _timer?.cancel();
  }

  void _reset(){
    setState(() {
      _time = 0;
    });
  }

  Widget TimeRunning() {
    var sec = _time ~/ 100;
    var hundredth = '${_time % 100}'.padLeft(2, '0');

    return  Padding(
      padding: const EdgeInsets.only(top:50.0),
      child: Container(
        child: Text(
          '${sec}.${hundredth}',
          style: TextStyle(fontSize: 40, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimeRunning(),
            Padding(
              padding: const EdgeInsets.only(top:100.0),
              child: TimeCheck(signal :startSignal,gameCount: gameCount,choiceCount: choiceCount),
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
                                if(gameCount[cnt] == num){
                                  print('2 dd ${cnt} num ${num}');
                                  choiceCount.add(num);
                                  cnt = cnt+1;
                                }
                              });
                              if(choiceCount.length == gameCount.length){
                                startSignal = false;
                                choiceCount.clear();
                                cnt = 0;
                                _stopTime();
                              }
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
                  _startTime();
                 setState(() {
                    btnCount.shuffle();
                    gameCount.shuffle();
                    startSignal = true;
                    _reset();
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

class TimeCheck extends StatefulWidget {
  const TimeCheck({Key? key, required this.signal, required this.gameCount, required this.choiceCount}) : super(key: key);
  final bool signal;
  final List gameCount;
  final List choiceCount;

  @override
  State<TimeCheck> createState() => _TimeCheckState();
}

class _TimeCheckState extends State<TimeCheck> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: widget.signal == false ? null :  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            widget.gameCount.map((num) =>
                Container(
                    width: 33,
                    margin: EdgeInsets.all(4),
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orangeAccent
                    ),
                    child: Text('${num}', style:TextStyle(fontSize: 40, color: Colors.white))
                ),
            ).toList(),
          ),
        ),
        Container(
          child: widget.signal == false ? null :  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            widget.choiceCount.map((num) =>
                Container(
                    width: 33,
                    margin: EdgeInsets.all(4),
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepPurpleAccent
                    ),
                    child: Text('${num}', style:TextStyle(fontSize: 40, color: Colors.white))
                ),
            ).toList(),
          ),
        ),
      ],
    );
  }
}





