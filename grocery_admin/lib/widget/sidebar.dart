import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:grocery_admin/screens/banner_screen.dart';
import 'package:grocery_admin/screens/category_screens.dart';
import 'package:grocery_admin/screens/delivery_boy_screen.dart';
import 'package:grocery_admin/screens/home_screen.dart';
import 'package:grocery_admin/screens/login_screen.dart';
import 'package:grocery_admin/screens/notification_screen.dart';
import 'package:grocery_admin/screens/orders_screen.dart';
import 'package:grocery_admin/screens/settings_screen.dart';
import 'package:grocery_admin/screens/users_screen.dart';
import 'package:grocery_admin/screens/vendor_screen.dart';

class SideBarWidget{
  sideBarMenus(context,selectedRoutes){
    return  SideBar(
      items: const [
        MenuItem(
          title: 'Dashboard',
          route: HomeScreen.id,
          icon: Icons.dashboard,
        ),
        MenuItem(
          title: 'Banners',
          route: BannerScreen.id,
          icon: Icons.photo_size_select_actual_outlined,
        ),
        MenuItem(
          title: 'Vendors',
          route: VendorScreen.id,
          icon: Icons.store,
        ),
        MenuItem(
          title: 'Categories',
          route: CategoryScreen.id,
          icon: Icons.category,
        ),
        MenuItem(
          title: 'Delivery',
          route: DeliveryBoyScreen.id,
          icon: Icons.delivery_dining,
        ),
        MenuItem(
          title: 'Orders',
          route: OrdersScreen.id,
          icon: CupertinoIcons.shopping_cart,
        ),
        MenuItem(
          title: 'Admin Users',
          route: UsersScreen.id,
          icon: Icons.person,
        ),
        MenuItem(
          title: 'Send Notification',
          route: NotificationScreen.id,
          icon: Icons.notifications,
        ),
        MenuItem(
          title: 'Settings',
          route: SettingsScreen.id,
          icon: Icons.settings,
        ),
        MenuItem(
          title: 'Exit',
          route: LoginScreen.id,
          icon: Icons.exit_to_app,
        ),

      ],
      selectedRoute: selectedRoutes,
      onSelected: (item) {
        if (item.route != null) {
          Navigator.of(context).pushNamed(item.route);
        }
      },
      header: Container(
        height: 50,
        width: double.infinity,
        color: Colors.black45,
        child: Center(
          child: Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      footer: Container(
        height: 50,
        width: double.infinity,
        color: Colors.black45,
        child: Center(
          child: Text(
            'PBMTSoftware',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}