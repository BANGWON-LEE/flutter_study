import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lobby extends StatefulWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  State<Lobby> createState() => _LobbyState();
}



class _LobbyState extends State<Lobby> {

  var myRecord;

  void initRecord() async {
    final prefs = await SharedPreferences.getInstance();
    var rec = prefs.getInt('rc_record');

    var sec = rec! ~/ 100;
    var hundredth = '${rec % 100}'.padLeft(2, '0');
    myRecord = '${sec}.${hundredth}';
  }

  void getUserRecordHttp() async {
    final prefs = await SharedPreferences.getInstance();

    var mem_userId = prefs.getString('userId');

    BaseOptions options = BaseOptions(
      baseUrl: 'http://192.168.123.110:5000',
      connectTimeout: 3000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);
  try {
    final res = await dio.post(
        "/api/user/record", data: {"mem_userId": mem_userId});
    print('response ${res.data[0]}');
    var userArray = res.data[0];
    if(res == []){
      print('아직 입니다.');
    } else {
      print('저장합니다.');
      prefs.setInt('rc_record', userArray['rc_record']);
    }
  } catch(e){
    await dio.post("/api/register/level1", data: {"mem_userId": mem_userId});
}
  }


  @override
  void initState() {
    super.initState();
    initRecord();
    getUserRecordHttp();
  }


  // void setRegisterRecordHttp() async {
  //   BaseOptions options = BaseOptions(
  //     baseUrl: 'http://192.168.123.110:5000',
  //     connectTimeout: 3000,
  //     receiveTimeout: 3000,
  //   );
  //   Dio dio = new Dio(options);
  //
  //   try{
  //     final res = await dio.post("/api/register/level1", data: {"mem_userId": idController.text });
  //     print('response ${res}');
  //     if(res.statusCode == 200){
  //       Navigator.pushNamed(context, '/');
  //     }
  //   }catch(e){
  //     // _showMyDialog();
  //   }
  // }

  List<int> rankNum = [1,2,3];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                '랭킹 Top3',
                style: TextStyle(
                  fontSize: 55.0
                ),
              ),
            ),
            Container(
              child:
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                  rankNum.map((el) =>
                    Container(
                      child:
                        Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 1.0),
                                child: Image.asset('asset/img/crown_${el}.png',
                                  width: 30,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Text('하얀색이 어울리는 소년 ',
                                  style: TextStyle(
                                    fontSize: 20.0
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),
                  ).toList(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top:25.0),
              child: Container(
                child: Text(
                  '나의 최고기록 ${myRecord} 초',
                  style: TextStyle(
                      fontSize: 35.0
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 55.0),
              child: Container(
                width: 130,
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/game');
                    },
                    child: Text(
                      '게임입장',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                ),
              ),
            )
            ],
          ),
        ),
      );
    }
  }

