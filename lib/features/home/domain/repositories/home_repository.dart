import 'package:exchange_darr/common/consts/typedef.dart';
import 'package:exchange_darr/features/home/data/models/get_ads_response.dart';
import 'package:exchange_darr/features/home/data/models/get_atms_info_response.dart';
import 'package:exchange_darr/features/home/domain/use_cases/get_atms_info_usecase.dart';

abstract class HomeRepository {
  DataResponse<GetAdsResponse> getAds();
  DataResponse<GetAtmsInfoResponse> getAtmsInfo({required GetAtmsInfoParams params});
}
