import 'package:flutter/material.dart';

import 'package:practice/screen/game/lobby.dart';
import 'package:practice/screen/game/login.dart';
import 'package:practice/screen/game/register.dart';

import 'package:practice/screen/game/tap_game.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  await dotenv.load(fileName: 'asset/config/.env');
  runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/register': (context) => Register(),
        '/lobby': (context) => Lobby(),
        '/game' : (context) => TapGame(),
      }
  )
  );
}

