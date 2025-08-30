import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PriceContainerParms {
  final String buyCur;
  final String buyPrice;
  final String sellCur;
  final String sellPrice;
  final List<Cur> curs;

  PriceContainerParms({
    required this.buyCur,
    required this.buyPrice,
    required this.sellCur,
    required this.sellPrice,
    required this.curs,
  });
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
    final buyCur = parms.curs.firstWhere(
      (cur) => cur.id == parms.buyCur,
      orElse: () => Cur(id: "-1", name: parms.buyCur),
    );
    final sellCur = parms.curs.firstWhere(
      (cur) => cur.id == parms.sellCur,
      orElse: () => Cur(id: "-1", name: parms.buyCur),
    );

    final buyCurName = buyCur.name;
    final sellCurName = sellCur.name;

    return Column(
      spacing: 5,
      children: [
        ///
        ///
        //////
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: context.onTertiary,
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(width: 3),
            boxShadow: [BoxShadow(color: const Color(0x20000000), blurRadius: 5, offset: const Offset(0, 0))],
          ),
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
                  "$sellCurName - $buyCurName",
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
          decoration: BoxDecoration(
            color: context.onTertiary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: const Color(0x20000000), blurRadius: 5, offset: const Offset(0, 0))],
          ),
          child: Column(
            spacing: 20,
            children: [
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSubContainer(context, title: "الشراء"),
                  SizedBox(width: 30),
                  _buildSubContainer(context, title: "البيع"),
                ],
              ),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSubContainer(context, title: formatPrice(parms.buyPrice)),
                  SizedBox(width: 30),
                  _buildSubContainer(context, title: formatPrice(parms.sellPrice)),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
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
