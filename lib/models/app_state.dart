import 'package:flutter/material.dart';

class UserProfile {
  String name;
  String email;
  String photo;

  UserProfile({
    required this.name,
    required this.email,
    required this.photo,
  });
}

class Restaurant {
  final String id;
  final String name;
  final String image;
  final String logo;
  final double rating;
  final String deliveryTime;
  final double deliveryFee;
  final String description;
  final String category;

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.logo,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.description,
    required this.category,
  });
}

class FoodItem {
  final String id;
  final String restaurantId;
  final String name;
  final String image;
  final double rating;
  final String deliveryTime;
  final double price;
  final double? oldPrice;
  final String description;
  final String category;
  final List<String> tags;

  FoodItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.image,
    required this.rating,
    required this.deliveryTime,
    required this.price,
    this.oldPrice,
    required this.description,
    required this.category,
    required this.tags,
  });
}

class CartItem {
  final FoodItem foodItem;
  int quantity;
  final List<String> additions;
  final bool packageBox;
  final double additionsCost;
  final double packageCost;

  CartItem({
    required this.foodItem,
    this.quantity = 1,
    required this.additions,
    required this.packageBox,
    this.additionsCost = 0.0,
    this.packageCost = 0.0,
  });

  double get totalItemPrice {
    return (foodItem.price + additionsCost + packageCost) * quantity;
  }
}

class AppState extends ChangeNotifier {
  // Authentication State
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  final UserProfile _user = UserProfile(
    name: 'Katty Berry',
    email: 'kattyberry@gmail.com',
    photo: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
  );
  UserProfile get user => _user;

  // App Selection State
  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Favorites (list of restaurant/food IDs)
  final Set<String> _favoriteRestaurantIds = {'r1'};
  final Set<String> _favoriteFoodIds = {'f4'};

  Set<String> get favoriteRestaurantIds => _favoriteRestaurantIds;
  Set<String> get favoriteFoodIds => _favoriteFoodIds;

  // Cart State
  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  // Temporary selected options for food detail page
  List<String> tempAdditions = [];
  bool tempPackageBox = false;

  // Mock data
  final List<Restaurant> restaurants = [
    Restaurant(
      id: 'r1',
      name: 'La Pasta House',
      image: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=500',
      logo: '🍝',
      rating: 4.9,
      deliveryTime: '30-40 min',
      deliveryFee: 2.50,
      description: 'An authentic Italian touch and delicious meals, freshly baked and prepared daily.',
      category: 'Brunch',
    ),
    Restaurant(
      id: 'r2',
      name: 'Crazy Tacko',
      image: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=500',
      logo: '🌮',
      rating: 4.8,
      deliveryTime: '20-30 min',
      deliveryFee: 1.90,
      description: 'Spicy and flavorful Mexican tacos, quesadillas, and fresh guacamole.',
      category: 'Fast food',
    ),
    Restaurant(
      id: 'r3',
      name: 'La Sala Healthy Cafe',
      image: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500',
      logo: '🥗',
      rating: 4.7,
      deliveryTime: '15-25 min',
      deliveryFee: 3.00,
      description: 'Healthy and organic salad bowls, smoothies, and gluten-free recipes.',
      category: 'Brunch',
    ),
    Restaurant(
      id: 'r4',
      name: 'Tasty Bowl Sushi & Ramen',
      image: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=500',
      logo: '🍜',
      rating: 4.6,
      deliveryTime: '40-50 min',
      deliveryFee: 3.50,
      description: 'Authentic Japanese ramen and freshly rolled sushi plates.',
      category: 'Sea food',
    ),
    Restaurant(
      id: 'r5',
      name: 'Sweet Corner Desserts',
      image: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=500',
      logo: '🍰',
      rating: 4.9,
      deliveryTime: '20-30 min',
      deliveryFee: 1.50,
      description: 'Indulge in premium cakes, pies, and caramelized puddings.',
      category: 'Dessert',
    ),
    Restaurant(
      id: 'r6',
      name: 'Tandoori Flames',
      image: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=500',
      logo: '🍛',
      rating: 4.9,
      deliveryTime: '25-35 min',
      deliveryFee: 3.00,
      description: 'Experience the magic of traditional clay oven tandoors and spiced curry recipes.',
      category: 'Indian',
    ),
    Restaurant(
      id: 'r7',
      name: 'Burger Club',
      image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
      logo: '🍔',
      rating: 4.8,
      deliveryTime: '15-20 min',
      deliveryFee: 2.00,
      description: 'Sizzling hot and fresh tandoori paneer, vegetable, and chicken burgers made to order.',
      category: 'Fast food',
    ),
  ];

  final List<FoodItem> foodItems = [
    FoodItem(
      id: 'f8',
      restaurantId: 'r6',
      name: 'Butter Chicken & Naan',
      image: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=400',
      rating: 4.9,
      deliveryTime: '25-35 min',
      price: 280.00,
      description: 'Juicy chicken tikka chunks cooked in a rich, creamy, buttery spiced tomato gravy, served with fresh hot garlic naan.',
      category: 'Indian',
      tags: ['Indian', 'Healthy'],
    ),
    FoodItem(
      id: 'f10',
      restaurantId: 'r7',
      name: 'Aloo Tikki Burger',
      image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
      rating: 4.7,
      deliveryTime: '15-20 min',
      price: 90.00,
      description: 'Crispy mashed potato patty seasoned with Indian spices, served with fresh lettuce, onions, and spicy mayonnaise.',
      category: 'Burger',
      tags: ['Fast food', 'Vegetarian'],
    ),
    FoodItem(
      id: 'f4',
      restaurantId: 'r2',
      name: 'Shrimp pizza',
      image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
      rating: 4.7,
      deliveryTime: '25-30 min',
      price: 12.50,
      oldPrice: 14.00,
      description: 'A seafood lover\'s dream, loaded with seasoned grilled shrimp, fresh bell peppers, mozzarella cheese, and garlic butter sauce.',
      category: 'Pizza',
      tags: ['Sea food', 'Fast food'],
    ),
    FoodItem(
      id: 'f1',
      restaurantId: 'r1',
      name: 'Pesto pasta',
      image: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400',
      rating: 4.9,
      deliveryTime: '30-40 min',
      price: 9.50,
      oldPrice: 10.80,
      description: 'Delicious basil, pesto, parmesan cheese, sun-dried tomatoes, fresh extra virgin olive oil.',
      category: 'Pasta',
      tags: ['Vegetarian', 'Healthy', 'Soup'],
    ),
    FoodItem(
      id: 'f2',
      restaurantId: 'r1',
      name: 'Amatriciana pasta',
      image: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=400',
      rating: 4.8,
      deliveryTime: '30-40 min',
      price: 8.70,
      oldPrice: 9.40,
      description: 'Classic Roman pasta made with tomato sauce, smoked pork neck, red onions, pecorino cheese, and fresh chili.',
      category: 'Pasta',
      tags: ['Fast food', 'Soup'],
    ),
    FoodItem(
      id: 'f3',
      restaurantId: 'r1',
      name: 'Carbonara pasta',
      image: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400',
      rating: 4.9,
      deliveryTime: '30-40 min',
      price: 7.50,
      oldPrice: 8.80,
      description: 'Rich, authentic Italian pasta, egg yolk, pecorino cheese, guanciale, and fresh ground black pepper.',
      category: 'Pasta',
      tags: ['Fast food'],
    ),
    FoodItem(
      id: 'f5',
      restaurantId: 'r5',
      name: 'Crème brulee',
      image: 'https://images.unsplash.com/photo-1516685018646-549198525c1b?w=400',
      rating: 4.8,
      deliveryTime: '15-20 min',
      price: 5.20,
      description: 'Rich and creamy custard base topped with a contrasting layer of hardened caramelized sugar.',
      category: 'Dessert',
      tags: ['Dessert', 'Vegetarian'],
    ),
    FoodItem(
      id: 'f6',
      restaurantId: 'r1',
      name: 'Juice 250ml (Orange)',
      image: 'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=400',
      rating: 4.9,
      deliveryTime: '10 min',
      price: 3.10,
      description: 'Freshly squeezed sweet orange juice packed with Vitamin C.',
      category: 'Drinks',
      tags: ['Healthy'],
    ),
    FoodItem(
      id: 'f7',
      restaurantId: 'r5',
      name: 'Tiramisu cake slice',
      image: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400',
      rating: 4.9,
      deliveryTime: '15 min',
      price: 4.80,
      description: 'Classic coffee-flavoured Italian dessert made of ladyfingers dipped in coffee, layered with a whipped mixture of eggs, sugar, and mascarpone cheese.',
      category: 'Dessert',
      tags: ['Dessert'],
    ),
    FoodItem(
      id: 'f9',
      restaurantId: 'r6',
      name: 'Paneer Tikka Masala',
      image: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400',
      rating: 4.8,
      deliveryTime: '20-30 min',
      price: 240.00,
      description: 'Spiced and grilled paneer cubes simmered in a thick, tangy onion-tomato masala sauce.',
      category: 'Indian',
      tags: ['Indian', 'Vegetarian', 'Healthy'],
    ),
    FoodItem(
      id: 'f11',
      restaurantId: 'r7',
      name: 'Spicy Paneer Burger',
      image: 'https://images.unsplash.com/photo-1460306855393-0410f61241c7?w=400',
      rating: 4.8,
      deliveryTime: '15-20 min',
      price: 160.00,
      description: 'Crispy fried paneer patty loaded with tandoori spread, green vegetables, and melting cheese slices.',
      category: 'Burger',
      tags: ['Fast food', 'Vegetarian'],
    ),
    FoodItem(
      id: 'f12',
      restaurantId: 'r6',
      name: 'Masala Dosa',
      image: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=400',
      rating: 4.9,
      deliveryTime: '15-20 min',
      price: 130.00,
      description: 'Thin crispy rice crepe stuffed with spiced potato mash, served alongside fresh coconut chutney and hot sambar.',
      category: 'Indian',
      tags: ['Indian', 'Vegetarian', 'Healthy'],
    ),
  ];

  // Operations
  void login(String email, String name) {
    _user.email = email;
    if (name.isNotEmpty) _user.name = name;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _cart.clear();
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavoriteRestaurant(String id) {
    if (_favoriteRestaurantIds.contains(id)) {
      _favoriteRestaurantIds.remove(id);
    } else {
      _favoriteRestaurantIds.add(id);
    }
    notifyListeners();
  }

  void toggleFavoriteFood(String id) {
    if (_favoriteFoodIds.contains(id)) {
      _favoriteFoodIds.remove(id);
    } else {
      _favoriteFoodIds.add(id);
    }
    notifyListeners();
  }

  // Cart Operations
  int getItemQuantity(String foodId) {
    int total = 0;
    for (var item in _cart) {
      if (item.foodItem.id == foodId) {
        total += item.quantity;
      }
    }
    return total;
  }

  void addOrIncrementCartItem(FoodItem item) {
    int index = _cart.indexWhere((element) => element.foodItem.id == item.id);
    if (index != -1) {
      _cart[index].quantity++;
    } else {
      _cart.add(CartItem(
        foodItem: item,
        quantity: 1,
        additions: [],
        packageBox: false,
      ));
    }
    notifyListeners();
  }

  void decrementCartItem(FoodItem item) {
    int index = _cart.indexWhere((element) => element.foodItem.id == item.id);
    if (index != -1) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void addToCart(FoodItem item, int quantity, List<String> additions, bool packageBox) {
    double additionsCost = 0.0;
    for (var add in additions) {
      if (add == 'Parmesan cheese') additionsCost += 2.50;
      if (add == 'Sauce') additionsCost += 1.50;
    }
    double packageCost = packageBox ? 0.50 : 0.0;

    // Check if item with exact additions and package config exists
    int existingIndex = _cart.indexWhere((element) {
      if (element.foodItem.id != item.id) return false;
      if (element.packageBox != packageBox) return false;
      if (element.additions.length != additions.length) return false;
      return element.additions.every((a) => additions.contains(a));
    });

    if (existingIndex != -1) {
      _cart[existingIndex].quantity += quantity;
    } else {
      _cart.add(CartItem(
        foodItem: item,
        quantity: quantity,
        additions: additions,
        packageBox: packageBox,
        additionsCost: additionsCost,
        packageCost: packageCost,
      ));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void updateCartQuantity(CartItem item, int newQty) {
    if (newQty <= 0) {
      _cart.remove(item);
    } else {
      item.quantity = newQty;
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // Calculation getters
  double get cartSubtotal {
    double total = 0.0;
    for (var item in _cart) {
      total += item.totalItemPrice;
    }
    return total;
  }

  double get deliveryFee {
    if (_cart.isEmpty) return 0.0;
    // Base delivery fee from first restaurant or generic
    return 2.50;
  }

  double get cartTotal {
    return cartSubtotal + deliveryFee;
  }
}

class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context, {bool listen = true}) {
    if (listen) {
      final provider = context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
      assert(provider != null, "No AppStateProvider found in context");
      return provider!.notifier!;
    } else {
      final element = context.getElementForInheritedWidgetOfExactType<AppStateProvider>();
      assert(element != null, "No AppStateProvider found in context");
      return (element!.widget as AppStateProvider).notifier!;
    }
  }
}
