import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  RxBool isLoading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) async {
    try {
      var hasil = await firestore.collection("products").add(data);
      await firestore.collection("products").doc(hasil.id).update({
        "productId": hasil.id,
      });

      return {
        "error": false,
        "message": "Successfully added product.",
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Cannot add product.",
      };
    }
  }
}
