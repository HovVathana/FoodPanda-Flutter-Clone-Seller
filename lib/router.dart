import 'package:flutter/material.dart';
import 'package:foodpanda_seller/address/screens/address_screen.dart';
import 'package:foodpanda_seller/authentication/screens/authentication_screen.dart';
import 'package:foodpanda_seller/authentication/screens/login_screen.dart';
import 'package:foodpanda_seller/authentication/screens/register_screen.dart';
import 'package:foodpanda_seller/authentication/screens/send_verification_email_screen.dart';
import 'package:foodpanda_seller/banner/screens/add_banner_screen.dart';
import 'package:foodpanda_seller/banner/screens/banner_screen.dart';
import 'package:foodpanda_seller/foods/screens/add_category_screen.dart';
import 'package:foodpanda_seller/foods/screens/add_customize.dart';
import 'package:foodpanda_seller/foods/screens/add_food_screen.dart';
import 'package:foodpanda_seller/foods/screens/food_screen.dart';
import 'package:foodpanda_seller/foods/screens/menu_screen.dart';
import 'package:foodpanda_seller/home/screens/home_screen.dart';
import 'package:foodpanda_seller/home/screens/home_screen_no_approve.dart';
import 'package:foodpanda_seller/order_history/screens/order_history_screen.dart';
import 'package:foodpanda_seller/orders/screens/order_screen.dart';
import 'package:foodpanda_seller/register_shop/screens/register_shop_screen.dart';
import 'package:foodpanda_seller/register_shop/screens/search_address_manual_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );

    case HomeScreenNoApprove.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreenNoApprove(),
      );

    case AuthenticationScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthenticationScreen(),
      );

    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );

    case RegisterScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RegisterScreen(),
      );

    case SendVerificationEmailScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SendVerificationEmailScreen(),
      );

    case MenuScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const MenuScreen(),
      );

    case FoodScreen.routeName:
      final id = routeSettings.arguments as String;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => FoodScreen(
          id: id,
        ),
      );

    case AddCategoryScreen.routeName:
      final args = routeSettings.arguments as AddCategoryScreen;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddCategoryScreen(
          title: args.title,
          subtitle: args.subtitle,
          id: args.id,
        ),
      );

    case AddFoodScreen.routeName:
      final args = routeSettings.arguments as AddFoodScreen;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddFoodScreen(
          id: args.id,
          foodId: args.foodId,
        ),
      );

    case AddCustomizationScreen.routeName:
      final args = routeSettings.arguments as AddCustomizationScreen;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddCustomizationScreen(
          categoryId: args.categoryId,
          foodId: args.foodId,
        ),
      );

    case RegisterShopScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RegisterShopScreen(),
      );

    case SearchAddressManualScreen.routeName:
      final args = routeSettings.arguments as SearchAddressManualScreen;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchAddressManualScreen(
          initialLatLng: args.initialLatLng,
          changeAddress: args.changeAddress,
          mapPreviewController: args.mapPreviewController,
        ),
      );

    case AddressScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddressScreen(),
      );

    case OrderScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OrderScreen(),
      );

    case OrderHistoryScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OrderHistoryScreen(),
      );

    case BannerScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BannerScreen(),
      );

    case AddBannerScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddBannerScreen(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
