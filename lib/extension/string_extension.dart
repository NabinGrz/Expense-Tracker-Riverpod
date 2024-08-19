import 'package:flutter/material.dart';

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
        return "assets/images/bike.webp";
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
        return "assets/images/petrol.webp";
      case AppString.categoryMedicine:
        return "assets/images/medicine.webp";
      case AppString.categoryGas:
        return "assets/images/gas.webp";
      case AppString.categoryRice:
        return "assets/images/rice.webp";
      case AppString.categorySugar:
        return "assets/images/sugar.png";
      case AppString.categoryPersonal:
        return "assets/images/personal.webp";
      case AppString.categorySnacks:
        return "assets/images/snacks.webp";
      case AppString.categoryShampoo:
        return "assets/images/shampoo.webp";
      case AppString.categoryIcecream:
        return "assets/images/icecream.png";
      case AppString.categoryOffice:
        return "assets/images/office.webp";
      case AppString.categoryJhyapliKhaja:
        return "assets/images/jhyapliKhaja.webp";
      case AppString.categoryColdDrink:
        return "assets/images/coldDrink.png";
      case AppString.categorySubinExpense:
        return "assets/images/jhyapliKhaja.webp";
      case AppString.categoryHouseHoldSupplies:
        return "assets/images/household supplies.webp";
      case AppString.categoryElectricty:
        return "assets/images/electricity.webp";
      case AppString.categorySoap:
        return "assets/images/soap.png";
      case AppString.categoryRestaurant:
        return "assets/images/restaurant.webp";
      case AppString.categoryKhanepaniBill:
        return "assets/images/khanepanibill.webp";
      default:
        return "assets/images/bill.png";
    }
  }

  Color get getColorByCategory {
    switch (toLowerCase()) {
      case AppString.categoryFood:
        return Colors.deepOrangeAccent;
      case AppString.categoryClothing:
        return Colors.purple;
      case AppString.categoryRent:
        return Colors.pink;
      case AppString.categoryBike:
        return Colors.green;
      case AppString.categoryTransport:
        return Colors.blue;
      case AppString.categoryUtils:
        return Colors.blue;
      case AppString.categoryKhaja:
        return Colors.pink;
      case AppString.categoryMilk:
        return Colors.yellow;
      case AppString.categoryWater:
        return Colors.blueAccent;
      case AppString.categoryGrocery:
        return Colors.greenAccent;
      case AppString.categoryChocolate:
        return Colors.brown;
      case AppString.categoryMeat:
        return Colors.redAccent;
      case AppString.categoryFruits:
        return Colors.green;
      case AppString.categoryStationary:
        return Colors.pink;
      case AppString.categoryCosmetic:
        return Colors.pink;
      case AppString.categoryPetrol:
        return Colors.purple;
      case AppString.categoryMedicine:
        return Colors.amber;
      case AppString.categoryGas:
        return Colors.purpleAccent;
      case AppString.categoryRice:
        return Colors.red;
      case AppString.categorySugar:
        return Colors.green;
      case AppString.categoryPersonal:
        return Colors.green;
      case AppString.categorySnacks:
        return Colors.purple;
      case AppString.categoryShampoo:
        return Colors.amber;
      case AppString.categoryIcecream:
        return Colors.green;
      case AppString.categoryOffice:
        return Colors.orange;
      case AppString.categoryJhyapliKhaja:
        return Colors.greenAccent;
      case AppString.categoryColdDrink:
        return Colors.yellow;
      case AppString.categorySubinExpense:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
