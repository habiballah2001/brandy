import 'package:flutter/material.dart';
import '../../../view_model/home_provider.dart';
import '../../../models/product_model.dart';
import '../products/last_arrival_product.dart';

class LastArrivalSection extends StatelessWidget {
  const LastArrivalSection({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = HomeProvider.get(context);
    return SizedBox(
      height: 120,
      child: FutureBuilder<List<ProductModel>>(
          future: homeProvider.fetchProducts(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: homeProvider.getProducts.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return LastArrivalProduct(
                  product: homeProvider.getProducts[index],
                );
              },
            );
          }),
    );
  }
}
