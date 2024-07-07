import '../constants/app_strings.dart';

extension StringNullEmptyExtension on String? {
  bool get isNotNullAndEmpty => this != null && this!.isNotEmpty;
}

extension ImagePathExtension on String {
  String get getIconPathByCategory {
    switch (toLowerCase()) {
      case AppString.categoryFood:
        return "assets/images/food.png";
      case AppString.categoryClothing:
        return "assets/images/clothing.png";
      case AppString.categoryRent:
        return "assets/images/rent.png";
      case AppString.categoryBike:
        return "assets/images/bike.png";
      case AppString.categoryTransport:
        return "assets/images/transport.png";
      case AppString.categoryUtils:
        return "assets/images/utils.png";
      case AppString.categoryKhaja:
        return "assets/images/khaja.png";
      case AppString.categoryMilk:
        return "assets/images/milk.png";
      case AppString.categoryWater:
        return "assets/images/water.png";
      case AppString.categoryGrocery:
        return "assets/images/grocery.png";
      case AppString.categoryChocolate:
        return "assets/images/chocolate.png";
      case AppString.categoryMeat:
        return "assets/images/meat.png";
      case AppString.categoryFruits:
        return "assets/images/fruits.png";
      case AppString.categoryStationary:
        return "assets/images/stationary.png";
      case AppString.categoryCosmetic:
        return "assets/images/cosmetic.png";
      case AppString.categoryPetrol:
        return "assets/images/bike.png";
      default:
        return "assets/images/bill.png";
    }
  }
}
