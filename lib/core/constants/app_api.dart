/// api endpoint constants for the malamal backend
class AppApi {
  // base url for all api calls
  static const String baseUrl = 'https://api.malamal.com.bd/api/v1';

  // home screen hero section data
  static const String heroHome = '$baseUrl/hero/home';
  // product details screen api endpoints
  static const String productDetails = '$baseUrl/product/products'; // /slug
}
