import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

final idController = TextEditingController();
final pwController = TextEditingController();
final nickController = TextEditingController();

class _RegisterState extends State<Register> {

  @override
  void dispose() {
    idController.clear();
    pwController.clear();
    nickController.clear();

    super.dispose();
  }

  void _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('회원가입'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('아이디 또는 별명이'),
                Text('이미 존재하고 있습니다.'),
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


  void setRegisterHttp() async {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://192.168.123.110:5000',
      connectTimeout: 3000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);

    try{
      final res = await dio.post("/api/register", data: {"mem_userId": idController.text, "mem_userPw": pwController.text, "mem_nickname" : nickController.text });
      print('response ${res}');
      if(res.statusCode == 200){
        idController.clear();
        pwController.clear();
        nickController.clear();
        Navigator.pushNamed(context, '/');
      }
    }catch(e){
      _showMyDialog();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100.0,
                child: Container(
                  child: Text(
                    '회원가입',
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
                      maxLength: 15,
                      decoration: InputDecoration(
                          labelText: "아이디를 입력하시오(최대 15글자)",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          )
                      ),
                      controller: idController,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:15.0, bottom: 30.0),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: TextField(
                        maxLength : 15,
                        decoration: InputDecoration(
                            labelText: "별명을 입력하시오(최대 15글자)",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.blueAccent),
                            )
                        ),
                        controller: nickController,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Container(
                  width: 130,
                  child: ElevatedButton(
                    onPressed: () {

                      setRegisterHttp();

                    },
                    child: Text(
                      '가입하기',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
