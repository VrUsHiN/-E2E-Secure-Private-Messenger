
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CryptoHelper {
//  static var _secretKey =
//      SecretKey.randomBytes(16); //fix one for now, then key exchange
  static var _nonce = Nonce.randomBytes(12); //non-secret

//  static String get secretKey => base64Encode(_secretKey.extractSync());//utf8.decode(_secretKey.extractSync(),allowMalformed: true);//check

  static String get nonce => base64Encode(_nonce.bytes);//utf8.decode(_nonce.bytes,allowMalformed: true);

  final _cipher = CipherWithAppendedMac(aesCtr, Hmac(sha256));

  //for decryption the nonce and secretKey should be same as encryption

  Future<String> privKeyToStr(PrivateKey key) async{
    final privBytes = await key.extract();
    final val = base64Encode(privBytes);
    return val;
  }
  String pubKeyToStr(PublicKey key) {
    final val = base64Encode(key.bytes);
    return val;
  }

  PublicKey strToPubKey(String key) {
    final val = PublicKey(base64Decode(key));
    return val;
  }

  Future<PrivateKey> strToPrivKey(String key) async{
    final val = PrivateKey(base64Decode(key));
    return val;
  }

  Future<PrivateKey> getPrivKey(String userId) async{
    String val = await FlutterSecureStorage().read(key: userId);
    final privKey = strToPrivKey(val);
    return privKey;
  }

  Future<void> storePrivKey(PrivateKey privKey, String userId) async{
    final val = await privKeyToStr(privKey);
    final storage = new FlutterSecureStorage();
    await storage.write(key: userId, value: val);
  }
  
  Future<KeyPair> generateKeyPair() async{
    final keyPair = await x25519.newKeyPair();
    return keyPair;
  }

  Future<SecretKey> getSecretKey(PublicKey pubKey,PrivateKey privKey) async{
    final secretKey = await x25519.sharedSecret(localPrivateKey: privKey, remotePublicKey: pubKey);
    return secretKey;
  }

  Future<String> encryptMsg(String PT,PublicKey receiverPubKey,PrivateKey senderPrivKey) async {
    final message = utf8.encode(PT);//base64Decode(PT).toList();
    final secretKey = await getSecretKey(receiverPubKey, senderPrivKey);
    final encrypted = await _cipher.encrypt( 
      message,
      secretKey: secretKey,
      nonce: _nonce,
    );
    //final List<int> temp = List.from(encrypted);
//    print(encrypted.toString());
    return String.fromCharCodes(encrypted);//utf8.decode(encrypted);//base64Encode(encrypted.toList());//utf8.decode(temp,allowMalformed: true);//base64Encode(encrypted.toList());
  }

  Future<String> decryptMsg(String CT,String strNonSecNonce,PublicKey senderPubKey,PrivateKey receiverPrivKey) async {
//    //final message = utf8.encode(CT);//base64Decode(CT).toList();
//    CT = CT.substring(1,CT.length-2);
//    final tempList = CT.split(',');
//    final message = tempList.map(int.parse).toList();
    final message = Uint8List.fromList(CT.codeUnits);
//    final secKey = SecretKey(base64Decode(strSecKey).toList());
    final nonSecNonce = Nonce(base64Decode(strNonSecNonce).toList());
    final secretKey = await getSecretKey(senderPubKey, receiverPrivKey);
    final decrypted = await _cipher.decrypt(
      message,
      secretKey: secretKey,
      nonce: nonSecNonce,
    );
    return utf8.decode(decrypted);//base64Encode(decrypted.toList());
  }

  static const platform = const MethodChannel('com.flutter.crypto/crypto');

  void Printy() async{
    String val;
    try{
      val = await platform.invokeMethod('Printy');
    }
    catch(e){
      print(e);
    }
    print(val);
  }
}
