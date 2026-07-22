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

class MembershipPlan {
  final String id;
  final String name;
  final String price;
  final String pointsMultiplier;
  final String freeDelivery;
  final String discounts;

  MembershipPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.pointsMultiplier,
    required this.freeDelivery,
    required this.discounts,
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

class Address {
  final String id;
  final String label; // Home, Work, Custom
  final String street;
  final String city;
  final String zip;
  final String fullAddress;
  final String deliveryInstructions;
  final double lat;
  final double lng;

  Address({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.zip,
    required this.fullAddress,
    this.deliveryInstructions = '',
    this.lat = 28.6,
    this.lng = 77.1,
  });
}

class WalletTransaction {
  final String id;
  final String title;
  final String date;
  final double amount;
  final bool isCredit;

  WalletTransaction({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
  });
}

class SupportTicket {
  final String ticketNumber;
  final String subject;
  final String category;
  final String priority; // High, Medium, Low
  final String status; // Open, In Progress, Resolved
  final String date;
  final String assignedStaff;
  final String resolution;
  final String internalNotes;
  final List<String> messages;

  SupportTicket({
    required this.ticketNumber,
    required this.subject,
    required this.category,
    required this.priority,
    required this.status,
    required this.date,
    this.assignedStaff = 'Support Agent',
    this.resolution = '',
    this.internalNotes = '',
    required this.messages,
  });
}

class DeviceSession {
  final String id;
  final String deviceName;
  final String location;
  final String lastActive;
  final bool isCurrent;

  DeviceSession({
    required this.id,
    required this.deviceName,
    required this.location,
    required this.lastActive,
    this.isCurrent = false,
  });
}

class AppState extends ChangeNotifier {
  // Authentication State
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  final UserProfile _user = UserProfile(
    name: 'Rohan Sharma',
    email: 'rohansharma@gmail.com',
    photo: 'https://images.unsplash.com/photo-1607990283143-e81e7a2c93ab?w=150',
  );
  UserProfile get user => _user;

  // Wallet State
  double _walletBalance = 350.0;
  double get walletBalance => _walletBalance;

  final List<WalletTransaction> _walletTransactions = [
    WalletTransaction(id: 'wt1', title: 'Refund for ORD-5541', date: '08 July 2026', amount: 240.0, isCredit: true),
    WalletTransaction(id: 'wt2', title: 'Cashback Earned', date: '12 July 2026', amount: 30.0, isCredit: true),
    WalletTransaction(id: 'wt3', title: 'Referral Bonus', date: '15 July 2026', amount: 100.0, isCredit: true),
    WalletTransaction(id: 'wt4', title: 'Added via UPI', date: '18 July 2026', amount: 200.0, isCredit: true),
    WalletTransaction(id: 'wt5', title: 'Spent on ORD-7612', date: '16 July 2026', amount: 220.0, isCredit: false),
  ];
  List<WalletTransaction> get walletTransactions => _walletTransactions;

  // Address State
  final List<Address> _addresses = [
    Address(
      id: 'a1',
      label: 'Home',
      street: '742 Evergreen Terrace',
      city: 'Springfield',
      zip: '49001',
      fullAddress: '742 Evergreen Terrace, Springfield',
      deliveryInstructions: 'Leave with guard at the gate',
      lat: 28.6139,
      lng: 77.2090,
    ),
    Address(
      id: 'a2',
      label: 'Work',
      street: '100 Tech Park, Block C',
      city: 'Springfield',
      zip: '49002',
      fullAddress: '100 Tech Park, Block C, Springfield',
      deliveryInstructions: 'Deliver to 4th floor reception',
      lat: 28.6250,
      lng: 77.2200,
    ),
  ];
  Address? _selectedAddress;
  List<Address> get addresses => _addresses;
  Address? get selectedAddress => _selectedAddress ?? (_addresses.isNotEmpty ? _addresses.first : null);

  // Veg Filter & Delivery Time Filter State
  bool _isVegMode = false;
  bool get isVegMode => _isVegMode;

  int? _maxDeliveryTimeFilter;
  int? get maxDeliveryTimeFilter => _maxDeliveryTimeFilter;

  void toggleVegMode(bool value) {
    _isVegMode = value;
    notifyListeners();
  }

  void setMaxDeliveryTimeFilter(int? value) {
    _maxDeliveryTimeFilter = value;
    notifyListeners();
  }

  // Loyalty & Membership State
  int _loyaltyPoints = 450;
  int get loyaltyPoints => _loyaltyPoints;
  String _vipMembership = 'Silver'; // Bronze, Silver, Gold, Platinum
  String get vipMembership => _vipMembership;

  // Membership Plans List
  final List<MembershipPlan> _membershipPlans = [
    MembershipPlan(
      id: 'p1',
      name: 'Gold VIP Plan',
      price: '₹299 / month',
      pointsMultiplier: '2.0x points on orders',
      freeDelivery: 'Free delivery on all orders above ₹199',
      discounts: 'Extra 10% discount on Bestsellers',
    ),
    MembershipPlan(
      id: 'p2',
      name: 'Silver VIP Plan',
      price: '₹149 / month',
      pointsMultiplier: '1.5x points on orders',
      freeDelivery: 'Free delivery on all orders above ₹299',
      discounts: 'Extra 5% discount on desserts & drinks',
    ),
    MembershipPlan(
      id: 'p3',
      name: 'Bronze VIP Plan',
      price: '₹79 / month',
      pointsMultiplier: '1.2x points on orders',
      freeDelivery: 'Free delivery on orders above ₹399',
      discounts: 'Special Bronze-only coupon codes',
    ),
  ];

  List<MembershipPlan> get membershipPlans => _membershipPlans;

  void addMembershipPlan(String name, String price, String multiplier, String delivery, String discount) {
    _membershipPlans.insert(0, MembershipPlan(
      id: 'p${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      price: price,
      pointsMultiplier: multiplier,
      freeDelivery: delivery,
      discounts: discount,
    ));
    notifyListeners();
  }

  // Coupon State
  String? _appliedCouponCode;
  String? get appliedCouponCode => _appliedCouponCode;

  // Support Tickets State
  final List<SupportTicket> _supportTickets = [
    SupportTicket(
      ticketNumber: 'TKT-9912',
      subject: 'Refund for missing garlic naan',
      category: 'Food Quality',
      priority: 'Medium',
      status: 'Resolved',
      date: '17 July 2026',
      assignedStaff: 'Emily Watson',
      resolution: 'Refund of ₹40 has been credited to your Wallet.',
      internalNotes: 'User complained about garlic naan missing. Refund processed.',
      messages: ['Hi, my garlic naan was missing in order ORD-7612', 'Apologies for the inconvenience. We have refunded the amount to your wallet.'],
    ),
    SupportTicket(
      ticketNumber: 'TKT-1082',
      subject: 'Order delayed by 30 mins',
      category: 'Order Delay',
      priority: 'High',
      status: 'Open',
      date: 'Today',
      assignedStaff: 'Rohan Sharma',
      messages: ['My active order ORD-8742 is showing 12 mins left but it has been 45 mins.'],
    ),
  ];
  List<SupportTicket> get supportTickets => _supportTickets;

  // Device Sessions State
  final List<DeviceSession> _deviceSessions = [
    DeviceSession(id: 'd1', deviceName: 'iPhone 15 Pro Max', location: 'Springfield, USA', lastActive: 'Active Now', isCurrent: true),
    DeviceSession(id: 'd2', deviceName: 'Chrome Browser (Windows 11)', location: 'New York, USA', lastActive: '2 hours ago'),
    DeviceSession(id: 'd3', deviceName: 'iPad Air 5th Gen', location: 'Chicago, USA', lastActive: '3 days ago'),
  ];
  List<DeviceSession> get deviceSessions => _deviceSessions;

  // Referral State
  String _referralCode = 'FOODIE7612';
  String get referralCode => _referralCode;

  // Address CRUD operations
  void selectAddress(Address address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void addAddress(Address address) {
    _addresses.add(address);
    if (_selectedAddress == null) {
      _selectedAddress = address;
    }
    notifyListeners();
  }

  void updateAddress(String id, Address newAddress) {
    final index = _addresses.indexWhere((a) => a.id == id);
    if (index != -1) {
      _addresses[index] = newAddress;
      if (_selectedAddress?.id == id) {
        _selectedAddress = newAddress;
      }
      notifyListeners();
    }
  }

  void deleteAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    if (_selectedAddress?.id == id) {
      _selectedAddress = _addresses.isNotEmpty ? _addresses.first : null;
    }
    notifyListeners();
  }

  // Wallet Operations
  void addWalletMoney(double amount) {
    _walletBalance += amount;
    _walletTransactions.insert(0, WalletTransaction(
      id: 'wt${DateTime.now().millisecondsSinceEpoch}',
      title: 'Added via Card/UPI',
      date: 'Today',
      amount: amount,
      isCredit: true,
    ));
    _loyaltyPoints += (amount * 0.1).toInt(); // 10% points on adding money
    notifyListeners();
  }

  bool payWithWallet(double amount) {
    if (_walletBalance >= amount) {
      _walletBalance -= amount;
      _walletTransactions.insert(0, WalletTransaction(
        id: 'wt${DateTime.now().millisecondsSinceEpoch}',
        title: 'Spent on Order',
        date: 'Today',
        amount: amount,
        isCredit: false,
      ));
      notifyListeners();
      return true;
    }
    return false;
  }

  // Coupon Operations
  bool applyCoupon(String code) {
    final uc = code.toUpperCase().trim();
    if (uc == 'WELCOME50' || uc == 'FREEDEL') {
      _appliedCouponCode = uc;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _appliedCouponCode = null;
    notifyListeners();
  }

  // Loyalty & VIP Operations
  void redeemLoyaltyPoints(int points) {
    if (_loyaltyPoints >= points) {
      _loyaltyPoints -= points;
      final cashback = points / 10.0; // 10 points = 1 rupee cashback
      _walletBalance += cashback;
      _walletTransactions.insert(0, WalletTransaction(
        id: 'wt${DateTime.now().millisecondsSinceEpoch}',
        title: 'Loyalty Points Redeemed',
        date: 'Today',
        amount: cashback,
        isCredit: true,
      ));
      notifyListeners();
    }
  }

  void upgradeVipMembership(String plan) {
    _vipMembership = plan;
    notifyListeners();
  }

  // Support Tickets Operations
  void addSupportTicket(String subject, String category, String priority, String description) {
    final newTicket = SupportTicket(
      ticketNumber: 'TKT-${1000 + _supportTickets.length}',
      subject: subject,
      category: category,
      priority: priority,
      status: 'Open',
      date: 'Today',
      messages: [description],
    );
    _supportTickets.insert(0, newTicket);
    notifyListeners();
  }

  void replyToTicket(String ticketNumber, String message) {
    final index = _supportTickets.indexWhere((t) => t.ticketNumber == ticketNumber);
    if (index != -1) {
      _supportTickets[index].messages.add(message);
      notifyListeners();
    }
  }

  // Device Management Operations
  void logoutDevice(String id) {
    _deviceSessions.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  void logoutAllDevices() {
    _deviceSessions.removeWhere((d) => !d.isCurrent);
    notifyListeners();
  }

  // App Selection State
  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

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

  final List<Restaurant> _restaurants = [
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

  final List<FoodItem> _foodItems = [
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
      if (add == 'Extra Cheese') additionsCost += 30.00;
      if (add == 'Extra Paneer/Tofu') additionsCost += 40.00;
      if (add == 'Fresh Mushrooms') additionsCost += 25.00;
      if (add == 'Spicy Jalapenos') additionsCost += 20.00;
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

  // Getters with filtering
  List<Restaurant> get restaurants {
    List<Restaurant> list = _restaurants;
    if (_isVegMode) {
      // Filter out non-veg restaurants (e.g. r4 ramen/sushi, r6 tandoori curry could have non-veg, let's keep others)
      list = list.where((r) => r.id != 'r4' && r.id != 'r6').toList();
    }
    if (_maxDeliveryTimeFilter != null) {
      list = list.where((r) {
        final timeParts = r.deliveryTime.split('-').first.replaceAll(RegExp(r'[^0-9]'), '');
        final val = int.tryParse(timeParts) ?? 0;
        return val <= _maxDeliveryTimeFilter!;
      }).toList();
    }
    return list;
  }

  List<FoodItem> get foodItems {
    List<FoodItem> list = _foodItems;
    if (_isVegMode) {
      list = list.where((f) => f.tags.any((t) => t.toLowerCase() == 'vegetarian' || t.toLowerCase() == 'veg')).toList();
    }
    return list;
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
