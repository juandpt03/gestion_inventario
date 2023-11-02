import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_inventario/features/home/domain/domain.dart';
import 'package:gestion_inventario/features/home/presentation/providers/providers.dart';

final productFirebaseProvider = StateNotifierProvider.autoDispose<
    ProductFirebaseNotifier, ProductFirebaseState>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return ProductFirebaseNotifier(homeRepository: productRepository);
});

class ProductFirebaseNotifier extends StateNotifier<ProductFirebaseState> {
  final HomeRepository homeRepository;
  ProductFirebaseNotifier({
    required this.homeRepository,
  }) : super(ProductFirebaseState(
          product: ProductEntity(
            id: 'new',
            name: '',
            description: '',
            stock: 0,
            salePrice: 0,
            basePrice: 0,
            imageUrl: '',
          ),
          id: '',
          name: '',
          description: '',
          stock: 0,
          salePrice: 0,
          basePrice: 0,
          imageUrl: '',
        ));
  Future<ProductEntity> loadProductbyIdFirebase(
      {required String id, required String userId}) async {
    final ProductEntity product =
        await homeRepository.loadProductbyId(id: id, userId: userId);
    state = state.copyWith(
      product: product,
      id: product.id,
      name: product.name,
      description: product.description,
      stock: product.stock,
      salePrice: product.salePrice,
      basePrice: product.basePrice,
      imageUrl: product.imageUrl,
    );
    return product;
  }

  void onChangedName(String name) {
    state = state.copyWith(
      name: name,
      salePrice: state.salePrice,
      basePrice: state.basePrice,
      description: state.description,
      stock: state.stock,
      imageUrl: state.imageUrl,
    );
  }

  void onChangedDescription(String description) {
    state = state.copyWith(
      name: state.name,
      salePrice: state.salePrice,
      basePrice: state.basePrice,
      description: description,
      stock: state.stock,
      imageUrl: state.imageUrl,
    );
  }

  void onChangedStock(num stock) {
    state = state.copyWith(
      name: state.name,
      salePrice: state.salePrice,
      basePrice: state.basePrice,
      description: state.description,
      stock: stock,
      imageUrl: state.imageUrl,
    );
  }

  void onChangedSalePrice(num salePrice) {
    state = state.copyWith(
      name: state.name,
      salePrice: salePrice,
      basePrice: state.basePrice,
      description: state.description,
      stock: state.stock,
      imageUrl: state.imageUrl,
    );
  }

  void onChangedBasePrice(num basePrice) {
    state = state.copyWith(
      name: state.name,
      salePrice: state.salePrice,
      basePrice: basePrice,
      description: state.description,
      stock: state.stock,
      imageUrl: state.imageUrl,
    );
  }

  void onChangedImageUrl(String imageUrl) {
    state = state.copyWith(
      name: state.name,
      salePrice: state.salePrice,
      basePrice: state.basePrice,
      description: state.description,
      stock: state.stock,
      imageUrl: imageUrl,
    );
  }

  Future<String> onFormSubmit(String userId) async {
    state = state.copyWith(
        product: ProductEntity(
      id: state.id,
      name: state.name,
      salePrice: state.salePrice,
      description: state.description,
      stock: state.stock,
      basePrice: state.basePrice,
      imageUrl: state.imageUrl,
    ));
    final String result = await homeRepository.updateProduct(
        product: state.product, userId: userId);
    return result;
  }

  Future<String> createProduct(String userId) async {
    final String result =
        await homeRepository.addProduct(product: state.product, userId: userId);
    return result;
  }
}

class ProductFirebaseState {
  final ProductEntity product;
  final String name;
  final String description;
  final num stock;
  final num salePrice;
  final num basePrice;
  final String imageUrl;
  final String id;

  ProductFirebaseState({
    required this.id,
    required this.product,
    required this.name,
    required this.description,
    required this.stock,
    required this.salePrice,
    required this.basePrice,
    required this.imageUrl,
  });
  ProductFirebaseState copyWith(
      {ProductEntity? product,
      String? id,
      String? name,
      String? description,
      num? stock,
      num? salePrice,
      num? basePrice,
      String? imageUrl}) {
    return ProductFirebaseState(
      id: id ?? this.id,
      product: product ?? this.product,
      name: name ?? this.name,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      salePrice: salePrice ?? this.salePrice,
      basePrice: basePrice ?? this.basePrice,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
