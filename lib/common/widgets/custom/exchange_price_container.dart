import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/widgets/custom/bouncing_arrow.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PriceContainerParms {
  final String buyCur;
  final String buyPrice;
  final String sellCur;
  final String sellPrice;

  PriceContainerParms({required this.buyCur, required this.buyPrice, required this.sellCur, required this.sellPrice});
}

class ExchangePriceContainer extends StatelessWidget {
  final PriceContainerParms parms;
  const ExchangePriceContainer({super.key, required this.parms});
  String formatPrice(String priceStr) {
    double price = double.tryParse(priceStr) ?? 0.0;

    if (price == price.toInt()) {
      return price.toInt().toString();
    } else {
      return price.toStringAsFixed(3);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final List<Map<String, Type>> Price = cityPrices.currencies;
    // final curName = Price.
    // final from = buyPrice?.curfrom ?? sellPrice?.curfrom ?? "";
    // final to = buyPrice?.curto ?? sellPrice?.curto ?? "";

    return Column(
      spacing: 5,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(color: context.surfaceContainer, borderRadius: BorderRadius.circular(8)),
            child: Skeleton.ignore(
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    parms.buyCur,
                    style: TextStyle(color: context.primaryColor, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    parms.sellCur,
                    style: TextStyle(color: context.primaryColor, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),

        ///
        ///
        //////
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(color: context.primaryContainer, borderRadius: BorderRadius.circular(8)),
          child: Skeleton.ignore(
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.network(
                //   "https://kawaja2025.com/x5k4e/img/${getCurrencyObject(from)!.img}",
                //   width: 30,
                //   height: 30,
                //   fit: BoxFit.cover,
                //   filterQuality: FilterQuality.high,
                //   errorBuilder: (context, error, stackTrace) {
                //     return SizedBox.shrink();
                //   },
                // ),
                Text(
                  "${parms.sellCur} - ${parms.buyCur}",
                  style: TextStyle(color: context.primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                // Image.network(
                //   "https://kawaja2025.com/x5k4e/img/${getCurrencyObject(to)!.img}",
                //   width: 30,
                //   height: 30,
                //   fit: BoxFit.cover,
                //   filterQuality: FilterQuality.high,
                //   errorBuilder: (context, error, stackTrace) {
                //     return SizedBox.shrink();
                //   },
                // ),
              ],
            ),
          ),
        ),

        ///
        ///
        //////
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(color: context.surfaceContainer, borderRadius: BorderRadius.circular(8)),
          child: Column(
            spacing: 20,
            children: [
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSubContainer(context, title: "الشراء"),
                  BouncingArrow(bounceUp: true, icon: Icons.keyboard_arrow_up_rounded, color: Colors.green),
                  _buildSubContainer(context, title: "البيع"),
                ],
              ),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSubContainer(context, title: formatPrice(parms.buyPrice)),
                  BouncingArrow(bounceUp: false, icon: Icons.keyboard_arrow_down_rounded, color: Colors.red),
                  _buildSubContainer(context, title: formatPrice(parms.sellPrice)),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

Widget _buildSubContainer(BuildContext context, {required String title}) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      margin: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(5)),
      child: Skeleton.ignore(
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: context.onPrimaryColor, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
