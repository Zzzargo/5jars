import 'dart:ffi';
import 'dart:io';

DynamicLibrary openLibrary(String name) {
  if (Platform.isLinux) {
    return DynamicLibrary.open('lib/$name.so');
  } else if (Platform.isAndroid) {
    return DynamicLibrary.open(name);
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('lib/$name.dll');
  } else if (Platform.isIOS) {
    return DynamicLibrary.executable();
  } else if (Platform.isMacOS) {
    return DynamicLibrary.open('lib/$name.dylib');
  } else {
    throw UnsupportedError('Platform not supported');
  }
}

final accountsLib = openLibrary('libaccounts');
final usersLib = openLibrary('libusers');
final transactionsLib = openLibrary('libtransactions');
