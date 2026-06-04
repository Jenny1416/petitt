import 'package:get/get.dart';
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
import '../screens/addresses_screen.dart';
import '../screens/support_screen.dart';
import '../screens/onboarding_page.dart';
import '../screens/onboarding_page_01.dart';
import '../screens/onboarding_page_02.dart';
import '../screens/offer_page.dart';
import '../screens/category_result_screen.dart';

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
  static const String addresses = '/addresses';
  static const String support = '/support';
  static const String reviews = '/reviews';
  static const String onboarding = '/onboarding';
  static const String onboarding1 = '/onboarding1';
  static const String onboarding2 = '/onboarding2';
  static const String offer = '/offer';
  static const String categoryResult = '/category-result';
}

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(name: AppRoutes.forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: AppRoutes.newPassword, page: () => const NewPasswordScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.productDetail, page: () => const ProductDetailScreen(product: null)), // Argument handled inside screen if needed or passed via Get.arguments
    GetPage(name: AppRoutes.cart, page: () => const CartScreen()),
    GetPage(name: AppRoutes.checkout, page: () => const CheckoutScreen()),
    GetPage(name: AppRoutes.orderSuccess, page: () => const OrderSuccessScreen(order: null)),
    GetPage(name: AppRoutes.orders, page: () => const OrdersScreen()),
    GetPage(name: AppRoutes.orderDetail, page: () => const OrderDetailScreen(order: null)),
    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen()),
    GetPage(name: AppRoutes.addresses, page: () => const AddressesScreen()),
    GetPage(name: AppRoutes.support, page: () => const SupportScreen()),
    GetPage(name: AppRoutes.reviews, page: () => const ReviewsScreen(product: null)),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingPage()),
    GetPage(name: AppRoutes.onboarding1, page: () => const OnboardingPage01()),
    GetPage(name: AppRoutes.onboarding2, page: () => const OnboardingPage02()),
    GetPage(name: AppRoutes.offer, page: () => const OfferScreen()),
    GetPage(name: AppRoutes.categoryResult, page: () => const CategoryResultScreen(category: '')),
  ];
}
