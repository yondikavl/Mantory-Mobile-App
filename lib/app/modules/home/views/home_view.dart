import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:get/get.dart';
import 'package:qrcode_app/app/controllers/auth_controller.dart';
import 'package:qrcode_app/app/routes/app_pages.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final AuthController authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text(
        //   'Home',
        //   style: TextStyle(color: Colors.white),
        // ),
        // centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          // Hero Section
          SizedBox(
            width: double.infinity,
            height: 130,
            child: Stack(
              fit: StackFit.expand,
              children: [
                SvgPicture.asset(
                  'assets/images/heromantory.svg',
                  fit: BoxFit.cover,
                  color: Colors.indigo,
                  colorBlendMode: BlendMode.color,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'to Mantory',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: 4,
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                late String title;
                late IconData icon;
                late VoidCallback onTap;

                switch (index) {
                  case 0:
                    title = "Add Product";
                    icon = Icons.post_add_rounded;
                    onTap = () => Get.toNamed(Routes.addProduct);
                    break;
                  case 1:
                    title = "Product";
                    icon = Icons.list_alt_outlined;
                    onTap = () => Get.toNamed(Routes.products);
                    break;
                  case 2:
                    title = "QR Code";
                    icon = Icons.qr_code;
                    onTap = () async {
                      String barcode = await FlutterBarcodeScanner.scanBarcode(
                        "#000000",
                        "Back",
                        true,
                        ScanMode.QR,
                      );

                      // get data dari firebase serach by product id
                      Map<String, dynamic> hasil =
                          await controller.getProductById(barcode);
                      if (hasil["error"] == false) {
                        Get.toNamed(Routes.detailProduct,
                            arguments: hasil["data"]);
                      } else {
                        Get.snackbar(
                          "Error",
                          hasil["message"],
                          duration: const Duration(seconds: 2),
                        );
                      }
                    };
                    break;
                  case 3:
                    title = "Catalog";
                    icon = Icons.document_scanner_outlined;
                    onTap = () {
                      controller.downloadCatalog();
                    };
                    break;
                  default:
                }

                return Material(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(icon, size: 50),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(title)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic> hasil = await authC.logout();
          if (hasil["error"] == false) {
            Get.offAllNamed(Routes.login);
          } else {
            Get.snackbar("error", hasil["error"]);
          }
        },
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: Icon(Icons.logout),
      ),
    );
  }
}
