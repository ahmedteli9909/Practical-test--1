import 'package:flutter/material.dart';

import '../../../model/sub_category_model.dart';

class ProductItemView extends StatelessWidget {
  const ProductItemView({super.key, required this.productModel});

  final Product productModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          width: 150,
          margin: const EdgeInsets.only(right: 20, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12)
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(productModel.imageName!,errorBuilder: (context,_,trance) => const Icon(Icons.error),fit: BoxFit.cover,)),
        ),
         SizedBox(
            width: 120,
            child: Text(
              productModel.name ?? '',
              style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis),
              maxLines: 1,
            ))
      ],
    );
  }
}
