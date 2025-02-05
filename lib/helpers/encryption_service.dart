import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:puntuacion_tacher/constants/constants.dart';

class EncryptionService {
  // The singleton instance
  static final EncryptionService _instance = EncryptionService._internal();

  // Private constructor
  EncryptionService._internal();

  // Factory constructor to return the same instance
  factory EncryptionService() {
    return _instance;
  }

  // Encryption key 
  // TODO obtener encript_key de firebase
  // TODO repasar si viene nulo
  final encrypt.Key _key = encrypt.Key.fromUtf8(Environment.encryptKey);

  // Method to initialize the encryption key
  // void init(String keyString) {
  //   _key = encrypt.Key.fromUtf8(keyString);
  // }

  // Method to encrypt data
  String encryptData(String password) {
    final iv = encrypt.IV.fromLength(16); // Generate a random IV
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));

    final encrypted = encrypter.encrypt(password, iv: iv);
    final ivBase64 = iv.base64;
    final encryptedBase64 = encrypted.base64;

    return '$ivBase64:$encryptedBase64'; // Store IV and ciphertext together
  }

  // Method to decrypt data
  String decryptData(String encryptedPassword) {
    final parts = encryptedPassword.split(':');
    final iv = encrypt.IV.fromBase64(parts[0]); // Extract the IV
    final encrypted = encrypt.Encrypted.fromBase64(parts[1]);

    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    return decrypted;
  }
}