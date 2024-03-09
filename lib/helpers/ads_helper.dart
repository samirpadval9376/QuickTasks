import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo_app/helpers/firestore_helper.dart';

class AdHelper {
  AdHelper._();

  static final AdHelper adHelper = AdHelper._();

  late BannerAd bannerAd;

  Future<void> loadBannerAd() async {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: await FireStoreHelper.fireStoreHelper
          .getAddId(adTypes: AdTypes.bannerAd),
      listener: BannerAdListener(
          onAdLoaded: (ad) {}, onAdFailedToLoad: (ad, error) {}),
      request: const AdRequest(),
    );
    await bannerAd.load();
  }
}
