import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_inventario/features/auth/presentation/providers/providers.dart';
import 'package:gestion_inventario/features/home/domain/domain.dart';
import 'package:gestion_inventario/features/home/presentation/providers/providers.dart';
import 'package:gestion_inventario/features/shared/shared.dart';

class EmptyScreen extends ConsumerWidget {
  const EmptyScreen({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductImage(product: product),
              _ProductTitle(product: product),
              _Description(product: product),
              _Stock(product: product),
              _BasePrice(product: product),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'save',
          onPressed: () async {
            await ref.read(productFirebaseProvider.notifier).createProduct(
                  ref.read(authProvider).user!.id,
                );
            await ref
                .read(productFirebaseProvider.notifier)
                .onFormSubmit(ref.read(authProvider).user!.id)
                .then((value) {
              ref
                  .read(productFirebaseProvider.notifier)
                  .loadProductbyIdFirebase(
                      id: product.id, userId: ref.read(authProvider).user!.id);
              ref
                  .read(productsFirebaseProvider.notifier)
                  .loadProductsFirebase(ref.read(authProvider).user!.id);
              return customErrorMessage(context, value);
            });
          },
          child: const Icon(Icons.save),
        ));
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Hero(
              tag: product.id,
              child: Image.network(
                product.imageUrl == ''
                    ? 'https://media.istockphoto.com/id/1409329028/vector/no-picture-available-placeholder-thumbnail-icon-illustration-design.jpg?s=612x612&w=0&k=20&c=_zOuJu755g2eEUioiOUdz_mHKJQJn-tDgIAhQzyeKUQ='
                    : product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          child: FloatingActionButton(
            heroTag: 'camera',
            onPressed: () {},
            child: const Icon(
              Icons.camera_alt_outlined,
            ),
          ),
        ),
      ],
    );
  }
}

class _BasePrice extends ConsumerWidget {
  final ProductEntity product;
  const _BasePrice({
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Precio Base:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                '\$${product.basePrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 1,
          ),
          CustomTextFormField(
            label: 'Actualizar Precio Base',
            keyboardType: TextInputType.number,
            height: 20,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Ingrese una cantidad';
              }
              return null;
            },
            onChanged: (value) {
              ref
                  .read(productFirebaseProvider.notifier)
                  .onChangedBasePrice(num.tryParse(value) ?? 0.0);
            },
          ),
        ],
      ),
    );
  }
}

class _Stock extends ConsumerWidget {
  const _Stock({
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cantidad:',
                style: textStyle.titleLarge?.copyWith(
                  color: colors.primary,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${product.stock}',
                style: textStyle.titleLarge?.copyWith(
                  color: colors.primary,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 1,
          ),
          CustomTextFormField(
              label: 'Actualizar Cantidad',
              keyboardType: TextInputType.number,
              height: 20,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingrese una cantidad';
                }
                return null;
              },
              onChanged: (value) => ref
                  .read(productFirebaseProvider.notifier)
                  .onChangedStock(int.tryParse(value) ?? 0)),
        ],
      ),
    );
  }
}

class _Description extends ConsumerWidget {
  const _Description({
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Descripción',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.primary,
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Text(product.description),
          const SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            label: 'Actualizar Descripción',
            keyboardType: TextInputType.text,
            height: 40,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Ingrese una descripción';
              }
              return null;
            },
            onChanged: (value) {
              ref
                  .read(productFirebaseProvider.notifier)
                  .onChangedDescription(value);
            },
          ),
        ],
      ),
    );
  }
}

class _ProductTitle extends ConsumerWidget {
  const _ProductTitle({
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  textAlign: TextAlign.left,
                  style: textStyle.titleLarge?.copyWith(
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w500,
                    color: colors.secondary,
                  ),
                ),
                Text(
                  '\$${product.salePrice.toStringAsFixed(2)}',
                  style: textStyle.titleLarge?.copyWith(
                    color: colors.primary,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          CustomTextFormField(
            label: 'Actualizar Nombre',
            keyboardType: TextInputType.text,
            height: 10,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Ingrese una nombre';
              }
              return null;
            },
            onChanged: (value) {
              ref.read(productFirebaseProvider.notifier).onChangedName(value);
            },
          ),
          CustomTextFormField(
            label: 'Actualizar Precio',
            keyboardType: TextInputType.number,
            height: 10,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Ingrese una cantidad';
              }
              return null;
            },
            onChanged: (value) {
              ref.read(productFirebaseProvider.notifier).onChangedSalePrice(
                    num.tryParse(value) ?? 0.0,
                  );
            },
          ),
        ],
      ),
    );
  }
}
