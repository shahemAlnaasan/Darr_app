import '../../../../common/consts/typedef.dart';
import '../../data/models/get_ads_response.dart';
import '../repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAdsUsecase {
  final HomeRepository homeRepository;

  GetAdsUsecase({required this.homeRepository});

  DataResponse<GetAdsResponse> call() {
    return homeRepository.getAds();
  }
}
