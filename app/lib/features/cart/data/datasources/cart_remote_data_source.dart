import 'package:cloud_firestore/cloud_firestore.dart';
import '../data.dart';
import '../../../../shared/constants/app_const/app_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CartRemoteDataSource {
  // CARTS
  Future<void> addToCart(CartItemModel product);
  Future<void> removeFromCart(String id);
  Future<void> incrementCart(String id);
  Future<void> decrementCart(String id);
  Stream<List<CartItemModel>> getAllCartItems();
  Future<void> clearCart();
  Future<void> setCartItemCount(CartItemModel cartt);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final _firestore = FirebaseFirestore.instance;
  final SharedPreferences _prefs;

  CartRemoteDataSourceImpl(this._prefs);

  Future<void> createUser(String userId) async {
    DocumentReference userRef = _firestore.collection('users').doc(userId);

    await userRef.set({
      'id': userId,
      'token': _prefs.getString(AppConst.accessToken),
    });
  }

  @override
  Future<void> addToCart(CartItemModel product) async {
    var userId = _prefs.getString(AppConst.userId);
    await createUser("$userId");
    await _firestore
        .collection('users')
        .doc('$userId')
        .collection('cart')
        .doc("${product.food?.id}")
        .set(product.toJson());
  }

  @override
  Stream<List<CartItemModel>> getAllCartItems() {
    var userId = _prefs.getString(AppConst.userId);
    return _firestore
        .collection('users')
        .doc("$userId")
        .collection('cart')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CartItemModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Future<void> removeFromCart(String id) async {
    var userId = _prefs.getString(AppConst.userId);
    _firestore
        .collection('users')
        .doc('$userId')
        .collection('cart')
        .doc(id)
        .delete();
  }

  @override
  Future<void> decrementCart(String id) async {
    var userId = _prefs.getString(AppConst.userId);
    var docRef = _firestore
        .collection('users')
        .doc('$userId')
        .collection('cart')
        .doc(id);
    await _firestore.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(docRef);

      if (docSnapshot.exists) {
        int newQuantity = docSnapshot.get('quantity') - 1;
        transaction.update(docRef, {'quantity': newQuantity});
      }
    });
  }

  @override
  Future<void> incrementCart(String id) async {
    var userId = _prefs.getString(AppConst.userId);
    var docRef = _firestore
        .collection('users')
        .doc('$userId')
        .collection('cart')
        .doc(id);
    await _firestore.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(docRef);

      if (docSnapshot.exists) {
        int newQuantity = docSnapshot.get('quantity') + 1;
        transaction.update(docRef, {'quantity': newQuantity});
      }
    });
  }

  @override
  Future<void> clearCart() async {
    var userId = _prefs.getString(AppConst.userId);
    var cart = await _firestore
        .collection('users')
        .doc('$userId')
        .collection('cart')
        .get();
    for (var doc in cart.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<void> setCartItemCount(CartItemModel cart) async {
    var userId = _prefs.getString(AppConst.userId);
    await createUser("$userId");
    await _firestore
        .collection('users')
        .doc('$userId')
        .collection('cart')
        .doc(cart.food?.id)
        .set(cart.toJson(), SetOptions(merge: true));
  }
}
