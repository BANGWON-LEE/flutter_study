import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:practice/screen/game/admob.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class Lobby extends StatefulWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      final _msg = "게임을 종료하실 수 있습니다.";
      final snackBar = SnackBar(content: Text(_msg));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      initialRecentRecord();
      return Future.value(false);
    }
    return Future.value(true);
  }

  var rankNum = [0, 1, 2];
  var myRecord;
  var nick;

  void getLogoutHttp() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signOut();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void initRecord() async {
    final prefs = await SharedPreferences.getInstance();
    nick = prefs.getString('nick');
  }

  var recentRecord;

  void initialRecentRecord() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('recent_rc_record');
  }

  String? baseUrl = dotenv.env['BASE_URL'];

  void getUserRecordHttp() async {
    final prefs = await SharedPreferences.getInstance();

    var mem_userId = prefs.getString('userId');

    BaseOptions options = BaseOptions(
      baseUrl: baseUrl!,
      connectTimeout: 3000,
      receiveTimeout: 3000,
    );

    var recntRcRecord = prefs.getInt('recent_rc_record');
    print('recent Record1 ${recntRcRecord}');
    recentRecord = recntRcRecord == null
        ? null
        : '${recntRcRecord! ~/ 100}.${'${recntRcRecord! % 100}'.padLeft(2, '0')}';
    print('recent Record2 ${recentRecord}');

    Dio dio = new Dio(options);
    try {
      final res =
      await dio.post("/api/user/record", data: {"mem_userId": mem_userId});
      print('response ${res.data[0]}');
      var userArray = res.data[0];
      if (res == []) {
        print('아직 입니다.');
      } else {
        print('저장합니다.');
        prefs.setInt('rc_record', userArray['rc_record']);
        var sec = userArray['rc_record']! ~/ 100;
        var hundredth = '${userArray['rc_record'] % 100}'.padLeft(2, '0');
        myRecord = '${sec}.${hundredth}';
      }
    } catch (e) {
      await dio.post("/api/register/level1", data: {"mem_userId": mem_userId});
    }
  }

  List<dynamic>? rcData = List.filled(3, null);

  // List<dynamic>? rcData;
  // List rcData = List<String>.filled(3, '');
  // var rcData = [null,null,null];

  void getRecordHttp() async {
    print('start game');
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl!,
      connectTimeout: 3000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);

    try {
      final res2 = await dio.get("/api/record/level1/total");

      if (res2 != []) {
        var data = res2.data;
        var totalRank = data;
        // print('totalRank ${data.length}');
        // print('rcData1 ${rcData![0]}');
        // res2.data;
        for (int i = 0; i < data.length; i++) {
          // print('rcData3 ${rcData![0]}');
          rcData![i] = data[0];
          // print('rcData4 ${rcData}');
          // print('rcData i ${i}');
        }

        // print('rcData2 ${rcData![0]}');

        print('rankNum ${rankNum}');
      }
      // print('record total rank ${rcData[1].values.toList()[0]}');

    } catch (e) {
      // _showMyDialog();
    }
  }

  var myRank;

  void getMyRank() async {
    final prefs = await SharedPreferences.getInstance();

    BaseOptions options = BaseOptions(
      baseUrl: baseUrl!,
      // baseUrl: '192.168.0.206:5000',
      connectTimeout: 3000,
      receiveTimeout: 3000,
    );

    Dio dio = new Dio(options);

    try {
      final res = await dio.post("/api/record/level1/my/rank",
          data: {"mem_id": prefs.getInt('memId')});

      if (res != []) {
        myRank = res.data[0];
      }
      print('myRank ${myRank}');
    } catch (e) {
      // _showMyDialog();
    }
  }

  void _showMyDialog(String signal) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('회원탈퇴'),
          content: SingleChildScrollView(
            child: ListBody(
                children: signal == "회원탈퇴"
                    ? const <Widget>[
                  Text('회원탈퇴에'),
                  Text('성공하였습니다.'),
                ]
                    : const <Widget>[
                  Text('회원탈퇴에'),
                  Text('실패하였습니다.'),
                ]),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }

  void _checkWithDrawal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('회원탈퇴'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('회원탈퇴'),
                Text('하시겠습니까?.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                withdrawalHttp();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void withdrawalHttp() async {
    String? baseUrl = dotenv.env['BASE_URL'];
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl!,
      // baseUrl: '192.168.1.57:5000',
      connectTimeout: 3000,
      receiveTimeout: 3000,
    );

    Dio dio = new Dio(options);
    final prefs = await SharedPreferences.getInstance();

    try {
      var res = await dio.delete("/api/user/delete",
          queryParameters: {"mem_id": prefs.getInt('memId')});

      print('delete res ${res}');

      if (res.statusCode == 200) {
        _showMyDialog("회원탈퇴");
      }
    } catch (e) {
      _showMyDialog("!회원탈퇴");
    }
  }

  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 1),
        () => 'Data Loaded',
  );

  @override
  void initState() {
    super.initState();
    initRecord();
    getMyRank();
    getUserRecordHttp();
    getRecordHttp();
  }

  @override
  void dispose() {
    myRecord = 0;
    print('dispose lobby');
    initialRecentRecord();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Admob(),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WillPopScope(
                    onWillPop: onWillPop,
                    child: Container(
                      child: Text(
                        '랭킹 Top3',
                        style: TextStyle(fontSize: 55.0),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: rankNum
                          .map(
                            (el) => Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(right: 1.0),
                                  child: Image.asset(
                                    'asset/img/crown_${el}.png',
                                    width: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: FutureBuilder<String>(
                                    future: _calculation,
                                    // a previously-obtained Future<String> or null
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      List<Widget> children;
                                      if (snapshot.hasData) {
                                        children = <Widget>[
                                          Text(
                                            '${rcData![el] == null ? "?" : rcData![el].values.toList()[1]} : ${rcData![el] == null ? 0 : rcData![el].values.toList()[0] ~/ 100}.${rcData![el] == null ? 0 : '${rcData![el].values.toList()[0] % 100}'.padLeft(2, '0')} 초',
                                            style:
                                            TextStyle(fontSize: 20.0),
                                          ),
                                        ];
                                      } else if (snapshot.hasError) {
                                        children = <Widget>[
                                          const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 60,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16),
                                            child: Text(
                                                'Error: ${snapshot.error}'),
                                          ),
                                        ];
                                      } else {
                                        children = const <Widget>[
                                          SizedBox(
                                            width: 15,
                                            height: 15,
                                            child:
                                            CircularProgressIndicator(),
                                          ),
                                          // Padding(
                                          //   padding: EdgeInsets.only(top: 16),
                                          //   child: Text('랭킹을 불러오고 있습니다.'),
                                          // ),
                                        ];
                                      }
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: children,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Container(
                      child: FutureBuilder<String>(
                        future: _calculation,
                        // a previously-obtained Future<String> or null
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          List<Widget> children;
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Column(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(bottom: 15.0),
                                    child: Text(
                                      '"${nick}" 님의 최고기록 ${myRecord == null ? 0 : myRecord} 초',
                                      style: TextStyle(fontSize: 25.0),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(bottom: 15.0),
                                    child: Text(
                                      '"${nick}" 님의 현재 기록 ${recentRecord == null ? 0.00 : recentRecord!} 초',
                                      style: TextStyle(fontSize: 25.0),
                                    ),
                                  ),
                                  Text(
                                    '"${nick}" 님의 현재 순위 ${myRank['count(*)'] == null ? 0 : (myRank['count(*)'] + 1)} 위',
                                    style: TextStyle(fontSize: 25.0),
                                  ),
                                ],
                              ),
                            ];
                          } else if (snapshot.hasError) {
                            children = <Widget>[
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text('Error: ${snapshot.error}'),
                              ),
                            ];
                          } else {
                            children = const <Widget>[
                              SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(top: 16),
                              //   child: Text('기록을 불러오고 있습니다.'),
                              // ),
                            ];
                          }
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: children,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Container(
                      width: 130,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/game');
                          },
                          child: Text(
                            '게임입장',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      width: 130,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            getLogoutHttp();
                            Navigator.pushNamed(context, '/');
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
                            '로그아웃',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      width: 130,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            _checkWithDrawal();
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
                            '회원탈퇴',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
