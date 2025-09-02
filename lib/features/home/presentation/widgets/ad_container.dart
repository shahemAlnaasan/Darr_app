import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/utils/url_launche_helper.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/features/home/data/models/get_ads_response.dart';
import 'package:exchange_darr/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdContainer extends StatelessWidget {
  final Ad ad;
  const AdContainer({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.primaryColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 5, offset: Offset(0, 4))],
      ),

      child: Column(
        children: [
          // SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  insetPadding: EdgeInsets.all(1),
                  backgroundColor: Colors.black,
                  child: InteractiveViewer(
                    panEnabled: false,
                    minScale: 1,
                    maxScale: 5,
                    child: SizedBox(
                      width: double.infinity,
                      child: Image.network(ad.img, fit: BoxFit.contain, filterQuality: FilterQuality.high),
                    ),
                  ),
                ),
              );
            },
            child: SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  ad.img,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.image, size: 50),
                ),
              ),
            ),
          ),
          // SizedBox(height: 10),
          Divider(color: context.onPrimaryColor, height: 2),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Flexible(
                  child: AppText.bodySmall(
                    ad.title,
                    textAlign: TextAlign.right,
                    fontWeight: FontWeight.w600,
                    color: context.onPrimaryColor,
                  ),
                ),
                if (ad.map != "" && ad.map.isNotEmpty)
                  GestureDetector(
                    onTap: () async {
                      final result = await MapsLinkHelper.normalizeGoogleMapsLink(ad.map);
                      await UrlLaucncheHelper.launchWebUrl(result);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.tertiary,
                        borderRadius: BorderRadius.circular(8),
                        // boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 5, offset: Offset(0, 4))],
                      ),
                      padding: EdgeInsets.all(10),

                      width: 50,
                      height: 50,
                      child: Skeleton.ignore(child: Image.asset(Assets.images.location.path, color: Colors.white)),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
