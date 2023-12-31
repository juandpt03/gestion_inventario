import 'package:gestion_inventario/features/home/domain/entities/product_entity.dart';

abstract class HomeDataSource {
  Future<List<ProductEntity>> getProducts(String url);
  Future<String> upLoadProducts({
    required List<ProductEntity> products,
    required String userId,
  });
  Future<String> updateProduct({
    required ProductEntity product,
    required String userId,
  });
  Future<String> deleteProduct({
    required ProductEntity product,
    required String userId,
  });
  Future<String> addProduct({
    required ProductEntity product,
    required String userId,
  });
  Future<ProductEntity> loadProductbyId({
    required String id,
    required String userId,
  });
  Future<String> uploadProductPhoto({
    required String path,
    required String productId,
    required String userId,
  });
  Future<String> sentSell({
    required String userId,
    required String productId,
    required String quantity,
    required DateTime date,
  });
}
