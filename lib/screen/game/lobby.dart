import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Lobby extends StatefulWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  State<Lobby> createState() => _LobbyState();
}



class _LobbyState extends State<Lobby> {




  void setRegisterRecordHttp() async {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://192.168.123.110:5000',
      connectTimeout: 3000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);

    try{
      final res = await dio.post("/api/register/level1", data: {"mem_userId": idController.text });
      print('response ${res}');
      if(res.statusCode == 200){
        Navigator.pushNamed(context, '/');
      }
    }catch(e){
      // _showMyDialog();
    }
  }

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

