import '../../../../common/consts/typedef.dart';
import '../../data/models/get_company_info_response.dart';
import '../repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCompanyInfoUsecase {
  final HomeRepository homeRepository;

  GetCompanyInfoUsecase({required this.homeRepository});

  DataResponse<GetCompanyInfoResponse> call() {
    return homeRepository.getCompanyInfo();
  }
}
