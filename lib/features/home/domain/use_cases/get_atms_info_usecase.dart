import '../../../../common/consts/typedef.dart';
import '../../data/models/get_atms_info_response.dart';
import '../repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAtmsInfoUsecase {
  final HomeRepository homeRepository;

  GetAtmsInfoUsecase({required this.homeRepository});

  DataResponse<GetAtmsInfoResponse> call({required GetAtmsInfoParams params}) {
    return homeRepository.getAtmsInfo(params: params);
  }
}

class GetAtmsInfoParams with Params {
  final String id;

  GetAtmsInfoParams({required this.id});

  @override
  BodyMap getBody() => {"id": id};
}
