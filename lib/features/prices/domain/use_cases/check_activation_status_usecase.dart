import '../../../../common/consts/typedef.dart';
import '../../data/models/check_activation_status_response.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckActivationStatusUsecase {
  final PricesRepository pricesRepository;

  CheckActivationStatusUsecase({required this.pricesRepository});

  DataResponse<CheckActivationStatusResponse> call({required CheckActivationStatusParams params}) {
    return pricesRepository.checkActivationStatus(params: params);
  }
}

class CheckActivationStatusParams with Params {
  final int id;

  CheckActivationStatusParams({required this.id});

  @override
  BodyMap getBody() => {"id": id};
}
