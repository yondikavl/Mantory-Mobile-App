import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_app/app/data/models/product_model.dart';
import 'package:qrcode_app/app/routes/app_pages.dart';

import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamProducts(),
        builder: (context, snapProducts) {
          if (snapProducts.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapProducts.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Products"),
            );
          }

          List<ProductModel> allProducts = [];

          for (var element in snapProducts.data!.docs) {
            allProducts.add(ProductModel.fromJson(element.data()));
          }

          return ListView.builder(
            itemCount: allProducts.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              ProductModel product = allProducts[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.detailProduct, arguments: product);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.code,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(product.name),
                              Text("Jumlah : ${product.qty}"),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: QrImageView(
                            data: product.code,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
