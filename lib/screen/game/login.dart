import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final idController = TextEditingController();
  final pwController = TextEditingController();

  String id ='';

  @override
  void initState() {
    super.initState();
  }

  void _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그인'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('해당 계정이'),
                Text('존재하지 않습니다.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void getLoginHttp()  async {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://192.168.123.110:5000',
      connectTimeout: 3000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);
    final prefs = await SharedPreferences.getInstance();

    try{
      var res = await dio.post("/api/login", data: {"mem_userId": idController.text, "mem_userPw": pwController.text});
      print('response ${res.data[0]}');
      var userArray = res.data[0];
      print('usernick ${userArray['mem_nickname']}');
      if(res == []){
        _showMyDialog();
      } else {
        prefs.setString('nick', userArray['mem_nickname']);
        prefs.setString('userId', userArray['mem_userId']);

        Navigator.pushNamed(context, '/lobby');
      }
    }catch(e){
      _showMyDialog();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100.0,
              child: Container(
                child: Text(
                  'Tap game',
                  style: TextStyle(
                    fontSize: 40
                  ),
                ),
              ),
            ),
            Container(
              width: 320.0,
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "아이디를 입력하시오",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      )
                    ),
                    controller: idController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:18.0, bottom: 30.0),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: "비밀번호를 입력하시오",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          )
                      ),
                      controller: pwController,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Container(
                width: 130,
                child: ElevatedButton( onPressed: (){
                  getLoginHttp();
                  // Navigator.pushNamed(context, '/lobby');
                },
                child: Text(
                  '로그인',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Container(
                width: 130,
                child: ElevatedButton( onPressed: (){
                  Navigator.pushNamed(context, '/register');
                },
                    child: Text(
                      '회원가입',
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
