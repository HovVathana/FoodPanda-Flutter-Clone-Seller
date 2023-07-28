import 'package:flutter/material.dart';
import 'package:foodpanda_seller/banner/screens/banner_screen.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/foods/screens/menu_screen.dart';
import 'package:foodpanda_seller/home/widgets/my_drawer.dart';
import 'package:foodpanda_seller/models/order.dart';
import 'package:foodpanda_seller/orders/controllers/order_controller.dart';
import 'package:foodpanda_seller/orders/screens/order_screen.dart';
import 'package:foodpanda_seller/providers/authentication_provider.dart';
import 'package:foodpanda_seller/providers/register_shop_provider.dart';
import 'package:foodpanda_seller/register_shop/screens/register_shop_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrderController orderController = OrderController();
    final height = MediaQuery.of(context).size.height;

    final ap = context.watch<AuthenticationProvider>();
    final rp = context.watch<RegisterShopProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        title: const Text(
          'FoodPanda Seller',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(parentContext: context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome ${ap.name}',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                collageItem(
                  height: height,
                  iconData: Icons.add_chart_outlined,
                  title: 'Dashboard',
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                collageItem(
                  height: height,
                  iconData: Icons.fastfood_rounded,
                  title: 'Menu',
                  onTap: () {
                    if (rp.isRegistered) {
                      Navigator.pushNamed(context, MenuScreen.routeName);
                    } else {
                      Navigator.pushNamed(
                          context, RegisterShopScreen.routeName);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                collageItem(
                  height: height,
                  iconData: Icons.person_2_outlined,
                  title: 'Customers',
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                ap.isSignedIn
                    ? StreamBuilder<List<Order>>(
                        stream: orderController.fetchOrder(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('loading');
                          }
                          return
                              // final food = snapshot.data![index];
                              collageItem(
                            height: height,
                            iconData: Icons.shopping_cart_outlined,
                            title: 'Orders',
                            onTap: () {
                              if (rp.isRegistered) {
                                Navigator.pushNamed(
                                    context, OrderScreen.routeName);
                              } else {
                                Navigator.pushNamed(
                                    context, RegisterShopScreen.routeName);
                              }
                            },
                            alert: snapshot.data == null
                                ? 0
                                : snapshot.data!.length,
                          );
                        })
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                collageItem(
                  height: height,
                  iconData: Icons.photo_size_select_actual_outlined,
                  title: 'Banners',
                  onTap: () {
                    if (rp.isRegistered) {
                      Navigator.pushNamed(context, BannerScreen.routeName);
                    } else {
                      Navigator.pushNamed(
                          context, RegisterShopScreen.routeName);
                    }
                  },
                ),
                const SizedBox(width: 8),
                collageItem(
                  height: height,
                  iconData: Icons.local_offer_outlined,
                  title: 'Voucher',
                  onTap: () {
                    if (rp.isRegistered) {
                      // Navigator.pushNamed(context, VoucherScreen.routeName);
                    } else {
                      Navigator.pushNamed(
                          context, RegisterShopScreen.routeName);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded collageItem({
    required double height,
    required IconData iconData,
    required String title,
    required VoidCallback onTap,
    int alert = 0,
  }) {
    return Expanded(
      child: InkWell(
        splashColor: scheme.primary.withOpacity(0.2),
        onTap: onTap,
        child: Ink(
          height: height * 0.17,
          decoration: BoxDecoration(
            color: MyColors.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                alert > 0
                    ? Positioned(
                        top: 20,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: scheme.primary,
                          radius: 13,
                          child: Text(
                            alert.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      iconData,
                      color: scheme.primary,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
