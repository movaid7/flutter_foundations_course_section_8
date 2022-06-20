import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartService {
  CartService(this.ref);
  final Ref ref;

  // fetch cart from either local or remote
  // depending on the user's authentication status
  Future<Cart> _fetchCart() {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteCartRepositoryProvider).fetchCart(user.uid);
    } else {
      return ref.read(localCartRepositoryProvider).fetchCart();
    }
  }

  // set cart to either local or remote repository
  // depending on the user's authentication status
  Future<void> _setCart(Cart cart) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref.read(remoteCartRepositoryProvider).setCart(user.uid, cart);
    } else {
      await ref.read(localCartRepositoryProvider).setCart(cart);
    }
  }

  // sets an item to the local or remote cart
  Future<void> _setItem(Item item) async {
    final cart = await _fetchCart();
    final updatedCart = cart.setItem(item);
    await _setCart(updatedCart);
  }

  // adds an item to the local or remote cart
  Future<void> _addItem(Item item) async {
    final cart = await _fetchCart();
    final updatedCart = cart.addItem(item);
    await _setCart(updatedCart);
  }

  // remove an item from the local or remote cart
  Future<void> _removeItemById(ProductID productId) async {
    final cart = await _fetchCart();
    final updatedCart = cart.removeItemById(productId);
    await _setCart(updatedCart);
  }
}

final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(ref);
});
