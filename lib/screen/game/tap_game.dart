import 'dart:math';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TapGame extends StatefulWidget {
  const TapGame({Key? key}) : super(key: key);

  @override
  State<TapGame> createState() => _TapGameState();

}

class _TapGameState extends State<TapGame> {
  Timer? _timer;
  var _time = 0;
  // List<int> btnCount = [123,456,789];
  var btnCount = [['1','2','3'],['4','5','6'],['7','8','9']];
  List gameCount = ['1','2','3','4','5','6','7','8','9'];
  List choiceCount = [];
  // var btnCount = [[1,2,3],[4,5,6],[7,8,9]];
  bool startSignal = false;
  int cnt  = 0;

  Map<int,String> kind = {0:'8',1:'B',2:'A',3:'C',4:'D',5:'F',6:'E',7:'B',8:'A',9:'F', 10:'E', 11 : '7', 12 : 'E',13 : 'F',14 : 'A' };

  String cntStr = '';
  String hexNum = '';
  String secondHexNum = '';
  String thirdHexNum = '';
  String fourthHexNum = '';

  int codeHex = 0;
  int secondCodeHex = 0;
  int thirdCodeHex = 0;
  int fourthCodeHex = 0;

  int random = Random().nextInt(99);
  int indexRandom = Random().nextInt(10);

  void setEditRecordHttp() async {
    print('start game');
    BaseOptions options = BaseOptions(
      baseUrl: 'http://192.168.123.110:5000',
      connectTimeout: 3000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);
    final prefs = await SharedPreferences.getInstance();

    var prevRecord =  prefs.getInt('rc_record');

    print('prevR_1  ${prevRecord}');
    print('_time_1 ${_time}');

    if(  prevRecord != null && prevRecord! > _time) {
        print('prevR  ${prevRecord}');
        print('_time  ${_time}');

      try {
        final res = await dio.put("/api/record/level1/edit", data: {
          "mem_userId": prefs.getString('userId'),
          "rc_record": _time,
        });
        print('response edit ${res}');

          Navigator.pushNamed(context, '/lobby');

      } catch (e) {
        // _showMyDialog();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('dispose 실행');
    choiceCount.clear();
    _time = 0;
    super.dispose();
  }

  void _startTime(){
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        setState(() {
          _time++;
          if(_time == 3000){
            _stopTime();
          }
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
              padding: const EdgeInsets.only(top:20.0),
              child: TimeCheck(signal :startSignal,gameCount: gameCount,choiceCount: choiceCount),
            ),
            Expanded(
              child: Stack(
                children:[ Positioned(
                  bottom: 15,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: btnCount.map((el) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: el.asMap().entries.map((num) =>
                            // el.toString().split('').shuffle();
                          Padding(
                            padding: EdgeInsets.only(left:  10.0, top: 10.0),
                            child: SizedBox(
                              width: 100.0,
                              height: 100.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                   primary:
                                   cnt == 0 ? Colors.blue :
                                   (random-cnt) % int.parse(num.value) == 1 ? Color(codeHex) :
                                   (random+cnt)  % int.parse(num.value)  == 3  ? Color(secondCodeHex) :
                                   (random + cnt) % int.parse(num.value) == 2  ? Color(thirdCodeHex) :
                                   ((random+31) / int.parse(num.value)) % 2 == 0 ?  Color(fourthCodeHex) : Colors.pinkAccent
                                ),
                                onPressed:(){
                                  cntStr = cnt.toString();
                                  hexNum = '0xffC${kind[indexRandom+3]}5C5C';
                                  secondHexNum = '0xffF7${kind[indexRandom+1]}F50';
                                  thirdHexNum = '0xff2F${kind[indexRandom]}Df4';
                                  fourthHexNum = '0xff2F${kind[indexRandom+2]}Df4';

                                  codeHex = int.parse(hexNum);
                                  secondCodeHex = int.parse(secondHexNum);
                                  thirdCodeHex = int.parse(thirdHexNum);
                                  fourthCodeHex = int.parse(fourthHexNum);

                                  int rangeReplace = 0;

                                  setState(() {
                                    if(gameCount[0] == num.value && startSignal == true){
                                      // print('2 dd ${cnt} num ${num}');
                                      HapticFeedback.lightImpact();
                                      // HapticFeedback.heavyImpact();
                                      choiceCount.add(num.value);
                                      btnCount.shuffle();
                                      gameCount.removeRange(0, 1);
                                      cnt = cnt+1;
                                      gameCount.shuffle();


                                    } else if( gameCount[0] != num.value && startSignal == true) {
                                      // HapticFeedback.vibrate();
                                      HapticFeedback.heavyImpact();
                                      _time+=125;
                                      return null;
                                    }
                                  });
                                  if(choiceCount.length == 9){
                                    startSignal = false;
                                    choiceCount.clear();
                                    cnt = cnt * 0;
                                    gameCount = ['1','2','3','4','5','6','7','8','9'];
                                    _stopTime();
                                    setEditRecordHttp();

                                  }

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
                )],
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





