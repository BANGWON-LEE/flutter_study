import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:practice/screen/game/admob.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final idController = TextEditingController();
  final pwController = TextEditingController();

  String id = '';

  @override
  void initState() {
    super.initState();
  }

  void _showMyDialog(String signal) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: signal == "회원탈퇴" || signal == "!회원탈퇴"
              ? const Text('회원탈퇴')
              : const Text('!로그인'),
          content: SingleChildScrollView(
            child: ListBody(
              children: signal == "회원탈퇴"
                  ? const <Widget>[
                Text('회원탈퇴에'),
                Text('성공하였습니다.'),
              ]
                  : signal == "!회원탈퇴"
                  ? const <Widget>[
                Text('회원탈퇴에'),
                Text('실패하였습니다.'),
              ]
                  : const <Widget>[
                Text('로그인에'),
                Text('실패하였습니다.'),
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

  var userArray;

  void getLoginHttp() async {
    String? baseUrl = dotenv.env['BASE_URL'];
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl!,
      connectTimeout: 3000,
      receiveTimeout: 3000,
    );

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    Dio dio = new Dio(options);
    final prefs = await SharedPreferences.getInstance();

    var google_userId = googleUser?.email;
    var google_userName = googleUser?.displayName;

    try {
      var res = await dio.post("/api/login",
          data: {"mem_userId": google_userId, "mem_userPw": 1234});
      print('response ${res.data[0]}');
      userArray = res.data[0];
      print('usernick ${userArray['mem_nickname']}');
      if (res == []) {
        _showMyDialog("!로그인");
      } else {
        prefs.setString('nick', userArray['mem_nickname']);
        prefs.setString('userId', userArray['mem_userId']);
        prefs.setInt('memId', userArray['mem_id']);

        Navigator.popAndPushNamed(context, '/lobby');
      }
    } catch (e) {
      // _showMyDialog();
      // void setRegisterHttp() async {
      //   String? baseUrl = dotenv.env['BASE_URL'];
      //   BaseOptions options = BaseOptions(
      //     baseUrl: baseUrl!,
      //     connectTimeout: 3000,
      //     receiveTimeout: 3000,
      //   );
      //   Dio dio = new Dio(options);

      try {
        final res = await dio.post("/api/register", data: {
          "mem_userId": google_userId,
          "mem_userPw": 1234,
          "mem_nickname": google_userName
        });
        print('response ${res}');
        if (res.statusCode == 200) {
          idController.clear();
          pwController.clear();
          // nickController.clear();
          Navigator.popAndPushNamed(context, '/lobby');
        }
      } catch (e) {
        _showMyDialog("!로그인");
      }
      // }
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
            Admob(),
            // Container(
            //   width: 320.0,
            //   child: Column(
            //     children: [
            //       TextField(
            //         decoration: InputDecoration(
            //           labelText: "아이디를 입력하시오",
            //           enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.all(Radius.circular(15)),
            //             borderSide: BorderSide(color: Colors.blueAccent),
            //           )
            //         ),
            //         controller: idController,
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(top:18.0, bottom: 30.0),
            //         child: TextField(
            //           decoration: InputDecoration(
            //               labelText: "비밀번호를 입력하시오",
            //               enabledBorder: OutlineInputBorder(
            //                 borderRadius: BorderRadius.all(Radius.circular(15)),
            //                 borderSide: BorderSide(color: Colors.blueAccent),
            //               )
            //           ),
            //           obscureText: true,
            //           controller: pwController,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100.0,
                    child: Container(
                      child: Text(
                        'Tap game',
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      width: 130,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            getLoginHttp();
                            // Navigator.pushNamed(context, '/lobby');
                          },
                          icon: Image.asset(
                            'asset/img/google.png',
                            width: 20,
                            height: 20,
                            fit: BoxFit.fill,
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors
                                  .blueGrey //elevated btton background color
                          ),
                          label: Text(
                            '로그인',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 15.0),
            //   child: Container(
            //     width: 130,
            //     child: ElevatedButton( onPressed: (){
            //       Navigator.pushNamed(context, '/register');
            //     },
            //         child: Text(
            //           '회원가입',
            //           style: TextStyle(fontSize: 20, color: Colors.white),
            //         )
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
