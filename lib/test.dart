//import 'package:rsa_encrypt/rsa_encrypt.dart';
//import 'package:pointycastle/api.dart' as crypto;
//
//class Test{
////  //Future to hold our KeyPair
////  Future<crypto.AsymmetricKeyPair> futureKeyPair;
////
//////to store the KeyPair once we get data from our future
////  crypto.AsymmetricKeyPair keyPair;
////
////  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>> getKeyPair()
////  {
////    var helper = RsaKeyHelper();
////    return helper.computeRSAKeyPair(helper.getSecureRandom());
////  }
////
////  Future<void> initialise() async{
////    keyPair = await getKeyPair();
////    var e = encrypt('Hello', keyPair.publicKey);
////    print(e);
////    var d = decrypt(e, keyPair.privateKey);
////    print(d);
////  }
////
////  Test(){
////    initialise();
////  }
//
//}