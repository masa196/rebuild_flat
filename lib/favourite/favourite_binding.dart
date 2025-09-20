import 'package:get/get.dart';

import 'fav-controller.dart';


class FavouriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoriteController>(() => FavoriteController(),
    );
  }
}
