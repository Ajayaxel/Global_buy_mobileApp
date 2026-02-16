import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/cart/cart_event.dart';
import 'package:global/bloc/cart/cart_state.dart';
import 'package:global/repositories/cart_repository.dart';
import 'package:global/services/cart_manager.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<FetchCartItems>(_onFetchCartItems);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<BuyNowEvent>(_onBuyNow);
  }

  Future<void> _onBuyNow(BuyNowEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      await cartRepository.buyNow();
      CartManager().clearCart();
      emit(const CartSuccess("Order placed successfully."));
      emit(const CartLoaded([]));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      await cartRepository.updateCartItemQuantity(
        cartItemId: event.cartItemId,
        quantity: event.quantity,
      );
      final (items, cartId) = await cartRepository.getCart();
      CartManager().cartItemsNotifier.value = items;
      CartManager().cartId = cartId;
      emit(const CartSuccess("Quantity updated successfully."));
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      await cartRepository.deleteCartItem(event.cartItemId);
      final (items, cartId) = await cartRepository.getCart();
      CartManager().cartItemsNotifier.value = items;
      CartManager().cartId = cartId;
      emit(const CartSuccess("Item removed from cart."));
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onFetchCartItems(
    FetchCartItems event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final (items, cartId) = await cartRepository.getCart();
      CartManager().cartItemsNotifier.value = items;
      CartManager().cartId = cartId;
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoading) return;

    emit(CartLoading());
    try {
      await cartRepository.addToCart(
        productId: event.productId,
        quantity: event.quantity,
        price: event.price,
      );
      final (items, cartId) = await cartRepository.getCart();
      CartManager().cartItemsNotifier.value = items;
      CartManager().cartId = cartId;
      emit(const CartSuccess("Product added to cart successfully."));
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
