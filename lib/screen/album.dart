import 'package:flutter/material.dart';

class Album extends StatefulWidget {
  const Album({Key? key}) : super(key: key);

  @override
  State<Album> createState() => _AlbumState();
}

class _AlbumState extends State<Album> {
  List<int> album = [0, 0, 0, 0, 0,];

  late PageController controller; // 초기화 시점을 뒤로 미룸 여기에선 initialState로

  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: 0,
    );

  }

  int pageIndex = 0;

  onChanged(int index){
    setState(() {
      pageIndex = index;
    });
  }

  // @override
  // void dispose() {
  //     print('종료');
  //     // controller.dispose();
  //     super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // print('currentPage : $controller');
    return (
      Scaffold(
        body: Container(
          child: Stack(
            children: [
              Container(
                child: PageView(
                  children: [1,2,3,4,5].map((e) =>
                      Image.asset('asset/img/travel_0$e.jpg',
                         fit: BoxFit.cover,
                      )
                  ).toList(),
                  onPageChanged: onChanged,
                  controller: controller,
                ),
                height: MediaQuery.of(context).size.height,
              ),
              // Positioned(
              //   bottom: 20,
              //   left: 20,
              //   child: Container(
              //     width: 100,
              //     height: 100,
              //     child: ElevatedButton(
              //         style: ButtonStyle(
              //             backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
              //             shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
              //                 RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(50)
              //                 )
              //             )
              //         ),
              //         child: Text('나가기'),
              //         onPressed: (){
              //           setState(() {
              //             dispose();
              //           });
              //         }
              //     ),
              //   ),
              // ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  width: 100,
                  height: 100,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
                      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                        )
                      )
                    ),
                    child: Image.asset('asset/img/hearth.png',
                    ),
                    onPressed: (){
                      setState(() {
                        album[pageIndex]++;
                      });
                    }
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Image.asset('asset/img/big_hearth.png'),
                          Positioned(
                            top: 40,
                            left: 55,
                            child: Text('${album[pageIndex]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 47,
                              )
                            ),
                          ),
                        ]
                      )
                    ],
                  ) ,
                )
              ),
            ],
          ),
        )
      )
    );
  }
}
