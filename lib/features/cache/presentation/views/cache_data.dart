import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/service_locator.dart';
import 'package:test/features/cache/data/models/product_model.dart';
import 'package:test/features/cache/data/repos/impl_product_repo.dart';
import 'package:test/features/cache/presentation/manger/cubit/product_cubit.dart';

class CacheData extends StatelessWidget {
  const CacheData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductCubit(getIt.get<ImplProductRepo>())..getProducts(),
      child: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          ProductCubit cubit = context.read<ProductCubit>();
          return Scaffold(
            appBar: AppBar(),
            body: state is GetProductLoading
                ? const Center(child: CircularProgressIndicator())
                : ProductsGrid(
                    products: cubit.products,
                  ),
          );
        },
      ),
    );
  }
}

class ProductsGrid extends StatefulWidget {
  const ProductsGrid({
    super.key,
    required this.products,
  });
  final List<ProductModel> products;

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
   late ScrollController _scrollController;
  int _start = 0;
  int _end = 29;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    if (isLoading) return;

    final position = _scrollController.position;
    final isAtBottom = position.atEdge && position.pixels != 0;
    final isNearBottom = position.pixels >= position.maxScrollExtent * 0.6;

    if (isAtBottom || isNearBottom) {
      isLoading = true;
      _start = _end + 1; // Update _start to fetch new data
      _end += 20;
// Increase the end range for the next fetch
      log("@Start-$_start");
      log("@End-$_end");

      await context.read<ProductCubit>().getProducts(start: _start, end: _end);

      isLoading = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      itemCount: widget.products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 4,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: widget.products[index]);
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(
              product.imageUrl ??
                  "https://via.placeholder.com/150?text=Product+",
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? "Product name",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  product.description ?? "Description",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${product.price}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
