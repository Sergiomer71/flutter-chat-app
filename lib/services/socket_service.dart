// import 'package:flutter/material.dart';

// import 'package:socket_io_client/socket_io_client.dart' as IO;

// enum ServerStatus { Online, Offline, Connecting }

// class SocketService with ChangeNotifier {
//   ServerStatus _serverStatus = ServerStatus.Connecting;
//   IO.Socket _socket;

//   ServerStatus get serverStatus => this._serverStatus;

//   IO.Socket get socket => this._socket;
//   Function get emit => this._socket.emit;

//   SocketService() {
//     this._initConfig();
//   }

//   void _initConfig() {
//     // Dart client
//     this._socket = IO.io('http://localhost:3000/', {
//       'transports': ['websocket'],
//       'autoConnect': true
//     });

//     this._socket.on('connect', (_) {
//       this._serverStatus = ServerStatus.Online;
//       notifyListeners();
//     });

//     this._socket.on('disconnect', (_) {
//       this._serverStatus = ServerStatus.Offline;
//       notifyListeners();
//     });
//   }
// }

////////////////////////////////////////////////////////////////////////

import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/widgets.dart';

//todo el paquete lo esta renombrando como IO
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  // IO.Socket _socket; //original
  late final IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  void connect() async {
    final token = await AuthService.getToken();

    // Dart client
    // this._socket = IO.io('http://192.168.0.106:3000', {
    // IO.Socket socket = IO.io('http://localhost:3000', {
    this._socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    this._socket.on('connect', (_) {
      // print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on(('disconnect'), (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    this._socket.disconnect();
  }
}
