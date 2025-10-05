import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef HelloNative = ffi.Pointer<ffi.Int8> Function();
typedef HelloDart = ffi.Pointer<ffi.Int8> Function();

class CobolBridge {
  late final ffi.DynamicLibrary _lib;

  CobolBridge() {
    final libPath = Platform.isLinux
        ? 'cobol/lib/libtest.so'
        : (Platform.isWindows
              ? 'cobol/lib/hello.dll'
              : 'cobol/lib/libhello.dylib');
    _lib = ffi.DynamicLibrary.open(libPath);
  }

  String getMessage() {
    final cobolInit = _lib.lookupFunction<ffi.Void Function(), void Function()>(
      'cobol_init',
    );
    cobolInit();

    final ffiTest = _lib
        .lookupFunction<
          ffi.Void Function(ffi.Pointer<ffi.Int8>),
          void Function(ffi.Pointer<ffi.Int8>)
        >('ffi_test_c');

    final buffer = calloc<ffi.Int8>(200);
    ffiTest(buffer);

    final msg = buffer.cast<Utf8>().toDartString();
    calloc.free(buffer);

    final cobolDestroy = _lib
        .lookupFunction<ffi.Void Function(), void Function()>('cobol_destroy');
    cobolDestroy();

    return msg;
  }
}
