import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import '../../res/constants/paths.dart';
import '../../res/custom_widgets/custom_search_bar.dart';
import '../../res/custom_widgets/empty_widget.dart';
import '../../view/widgets/products/category_product.dart';

import '../../view_model/home_provider.dart';
import '../../res/custom_widgets/CustomAppBar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController? searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = HomeProvider.get(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSearchBar(
              controller: searchController,
              onChanged: (p0) {
                setState(() {
                  homeProvider.searchProduct(
                    searchText: searchController!.text,
                    productsList: homeProvider.getProducts,
                  );
                });
              },
              onSubmit: (v) {
                setState(() {
                  homeProvider.searchProduct(
                    searchText: searchController!.text,
                    productsList: homeProvider.getProducts,
                  );
                });
              },
            ),
            searchController!.text.isNotEmpty
                ? homeProvider.getSearchProducts.isNotEmpty
                    ? Expanded(
                        child: StreamBuilder<Object>(
                            stream: homeProvider.fetchProductsStream(),
                            builder: (context, snapshot) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return CategoryProduct(
                                    product:
                                        homeProvider.getSearchProducts[index],
                                  );
                                },
                                itemCount:
                                    homeProvider.getSearchProducts.length,
                              );
                            }),
                      )
                    : EmptyWidget(
                        title: LocaleKeys.empty.tr(context),
                        svg: AppImages.emptySearch,
                      )
                : homeProvider.getProducts.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return CategoryProduct(
                              product: homeProvider.getProducts[index],
                            );
                          },
                          itemCount: homeProvider.getProducts.length,
                        ),
                      )
                    : EmptyWidget(
                        title: LocaleKeys.empty.tr(context),
                        svg: AppImages.error,
                      )
          ],
        ),
      ),
    );
  }
}
