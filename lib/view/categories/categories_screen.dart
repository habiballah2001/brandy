import 'package:flutter/material.dart';

import '../../res/constants/constants.dart';
import '../../view/widgets/category/category_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => CategoryItem(
        categoryModel: Lists.categoriesList(context: context)[index],
      ),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: Lists.categoriesList(context: context).length,
    );
  }
}
