import 'dart:convert';
import 'package:auksion_app/models/product.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ProductHttpService {
  List<Product> _productList = [];
  List<Product> _computercategory = [];
  List<Product> _housecategory = [];
  List<String> _allcategories = [];
  List<Product> _carcategory = [];

  Future<List<Product>> getProducts([int id = 0]) async {
    Uri url = Uri.parse(
        'https://fir-73d12-default-rtdb.firebaseio.com/products.json');
    final response = await http.get(url);

    // Clear the lists
    _productList.clear();
    _computercategory.clear();
    _housecategory.clear();
    _carcategory.clear();
    _allcategories.clear();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((key, value) {
        _allcategories.add(key);
        if (key == 'computer' && value is List) {
          for (var productData in value) {
            final product = Product(
              categoryname: productData['categoryname'],
              auksiontime: productData['auksiontime'],
              name: productData['name'],
              categoryID: key,
              description: productData['description'],
              endprice: productData['endprice'],
              id: productData['id']?.toString() ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
              images: productData['images'],
              rating: productData['rating'],
              startprice: productData['startprice'],
            );
            print('Parsed product: $product');
            _computercategory.add(product);
            _productList.add(product);
          }
        }
        if (key == 'cars' && value is List) {
          for (var productData in value) {
            if (productData != null) {
              final product = Product(
                categoryname: productData['categoryname'],
                auksiontime: productData['auksiontime'],
                name: productData['name'],
                categoryID: key,
                description: productData['description'],
                endprice: productData['endprice'],
                id: productData['id']?.toString() ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                images: productData['images'],
                rating: productData['rating'],
                startprice: productData['startprice'],
              );
              print('Parsed product: $product');
              _carcategory.add(product);
              _productList.add(product);
            }
          }
        }
        if (key == 'uylar' && value is Map) {
          final images = value['images'];
          value.forEach((houseKey, houseData) {
            if (houseKey != 'images') {
              final product = Product(
                categoryname: houseData['categoryname'],
                auksiontime: houseData['auksiontime'],
                name: 'House',
                categoryID: key,
                description: houseData['description'],
                endprice: houseData['endprice'],
                id: houseData['id']?.toString() ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                images: images,
                rating: houseData['rating'],
                startprice: houseData['startprice'],
              );
              print('Parsed product: $product');
              _housecategory.add(product);
              _productList.add(product);
            }
          });
        }
      });

      if (!_allcategories.contains('all')) {
        _allcategories.insert(0, 'all');
      }
    } else {
      throw Exception('Failed to load products');
    }

    switch (id) {
      case 1:
        return _carcategory;
      case 2:
        return _computercategory;
      case 3:
        return _housecategory;
      default:
        return _productList;
    }
  }

  Future<List<String>> getAllCategories() async {
    if (_allcategories.isEmpty) {
      await getProducts();
    }
    return [..._allcategories];
  }

  // Function to update startprice of a product by name
  Future<void> updateStartPrice(
      String productName, String category, int newStartPrice) async {
    print(
        'Attempting to update price for product: $productName in category: $category to new price: $newStartPrice');
    print('Current product list: $_productList');
    for (var product in _productList) {
      print('Checking product: ${product.name}');
      if (product.name == productName && product.categoryID == category) {
        product.startprice = newStartPrice;
        print('Product ID: ${product.id}');

        Uri url = Uri.parse(
            'https://fir-73d12-default-rtdb.firebaseio.com/products/${product.id}.json');
        final response = await http.patch(
          url,
          body: jsonEncode({'startprice': newStartPrice}),
        );

        if (response.statusCode != 200) {
          print('Failed to update startprice. Response: ${response.body}');
          throw Exception('Failed to update startprice');
        }

        print('Price updated successfully for product: $productName');
        break;
      }
    }
  }
}
