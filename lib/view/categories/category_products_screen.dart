import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import '../../view_model/home_provider.dart';
import '../../res/constants/paths.dart';
import '../../res/custom_widgets/CustomAppBar.dart';
import '../../res/custom_widgets/custom_text_field.dart';
import '../../res/custom_widgets/empty_widget.dart';
import '../../view/widgets/products/category_product.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;
  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final formKey = GlobalKey<FormState>();
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
    HomeProvider homeProvider = HomeProvider.get(context)
      ..categoryProduct(category: widget.categoryName);

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(widget.categoryName),
      ),
      body: Column(
        children: [
          CustomTextField(
            controller: searchController!,
            type: TextInputType.text,
            validate: (p0) => LocaleKeys.search.tr(context),
            onChange: (p0) {
              setState(() {
                homeProvider.searchProduct(
                    searchText: searchController!.text,
                    productsList: homeProvider.getCategoryProducts);
              });
            },
            onSubmit: (v) {
              setState(() {
                homeProvider.searchProduct(
                    searchText: searchController!.text,
                    productsList: homeProvider.getCategoryProducts);
              });
            },
            hint: LocaleKeys.search.tr(context),
            prefix: const Icon(Icons.search_outlined),
            suffix: IconButton(
                onPressed: () {
                  searchController!.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.close)),
          ),
          searchController!.text.isNotEmpty
              ? homeProvider.getSearchProducts.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CategoryProduct(
                            product: homeProvider.getSearchProducts[index],
                          );
                        },
                        itemCount: homeProvider.getSearchProducts.length,
                      ),
                    )
                  : EmptyWidget(
                      title: LocaleKeys.empty.tr(context),
                      svg: AppImages.emptySearch)
              : homeProvider.getCategoryProducts.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CategoryProduct(
                            product: homeProvider.getCategoryProducts[index],
                          );
                        },
                        itemCount: homeProvider.getCategoryProducts.length,
                      ),
                    )
                  : EmptyWidget(
                      title: LocaleKeys.empty.tr(context),
                      svg: AppImages.emptySearch),
        ],
      ),
    );
  }
}
