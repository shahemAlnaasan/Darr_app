import 'package:exchange_darr/common/consts/typedef.dart';
import 'package:exchange_darr/features/home/data/models/get_atms_info_response.dart';
import 'package:exchange_darr/features/home/data/models/get_company_info_response.dart';
import 'package:exchange_darr/features/home/domain/use_cases/get_atms_info_usecase.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/home_remote_data_source.dart';
import '../models/get_ads_response.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImp implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepositoryImp({required this.homeRemoteDataSource});

  @override
  DataResponse<GetAdsResponse> getAds() {
    return homeRemoteDataSource.getAds();
  }

  @override
  DataResponse<GetAtmsInfoResponse> getAtmsInfo({required GetAtmsInfoParams params}) {
    return homeRemoteDataSource.getAtmsInfo(params: params);
  }

  @override
  DataResponse<GetCompanyInfoResponse> getCompanyInfo() {
    return homeRemoteDataSource.getCompanyInfo();
  }
}
