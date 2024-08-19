import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/api_services.dart';
import 'dart:developer';

import 'package:test/features/auth/presentation/manger/auth_cubit/auth_cubit.dart'; // For using log

class DetailsView extends StatelessWidget {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is GetDataLoading) {}
        if (state is GetDataSuccess) {
          // Here you can perform any actions needed after successful data fetch
        }
      },
      builder: (context, state) {
        AuthCubit cubit = context.read<AuthCubit>();
        return Scaffold(
          body: Center(
            child: state is GetDataLoading
                ? const CircularProgressIndicator()
                : OrdersList(
                    orders: cubit.orders,
                  ),
          ),
        );
      },
    );
  }
}

class OrdersList extends StatefulWidget {
  const OrdersList({
    super.key,
    required this.orders,
  });

  final List<Order> orders;

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
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

      await context.read<AuthCubit>().getData(start: _start, end: _end);

      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.orders.length,
      itemBuilder: (context, index) {
        final order = widget.orders[index];
        return ListTile(
          onTap: () {
            log('Tapped on: ${order.name}, Price: ${order.price}');
          },
          title: Text('Item ${order.name}'),
          subtitle: Text('Price: ${order.price}'),
        );
      },
    );
  }
}
