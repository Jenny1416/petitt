import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/new_password_screen.dart';
import '../screens/home_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/order_success_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/order_detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/reviews_screen.dart';
import '../screens/onboarding_page.dart';
import '../screens/onboarding_page_01.dart';
import '../screens/onboarding_page_02.dart';
import '../screens/offer_page.dart';
import '../screens/category_result_screen.dart';
import '../models/product.dart';
import '../models/order.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String newPassword = '/new-password';
  static const String home = '/home';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String orders = '/orders';
  static const String orderDetail = '/order-detail';
  static const String profile = '/profile';
  static const String reviews = '/reviews';
  static const String onboarding = '/onboarding';
  static const String onboarding1 = '/onboarding1';
  static const String onboarding2 = '/onboarding2';
  static const String offer = '/offer';
  static const String categoryResult = '/category-result';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      newPassword: (context) => const NewPasswordScreen(),
      home: (context) => const HomeScreen(),
      cart: (context) => const CartScreen(),
      checkout: (context) => const CheckoutScreen(),
      orders: (context) => const OrdersScreen(),
      profile: (context) => const ProfileScreen(),
      onboarding: (context) => const OnboardingPage(),
      onboarding1: (context) => const OnboardingPage01(),
      onboarding2: (context) => const OnboardingPage02(),
      offer: (context) => const OfferScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case categoryResult:
        final category = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => CategoryResultScreen(category: category),
        );
      case productDetail:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: product),
        );
      case orderSuccess:
        final order = settings.arguments as OrderModel;
        return MaterialPageRoute(
          builder: (context) => OrderSuccessScreen(order: order),
        );
      case orderDetail:
        final order = settings.arguments as OrderModel;
        return MaterialPageRoute(
          builder: (context) => OrderDetailScreen(order: order),
        );
      case reviews:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (context) => ReviewsScreen(product: product),
        );
      default:
        return null;
    }
  }
}
