import 'package:exchange_darr/core/models/status_response_model.dart';

import '../../../../common/consts/typedef.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangeActivationUsecase {
  final PricesRepository pricesRepository;

  ChangeActivationUsecase({required this.pricesRepository});

  DataResponse<StatusResponseModel> call({required ChangeActivationParams params}) {
    return pricesRepository.changeActivation(params: params);
  }
}

class ChangeActivationParams with Params {
  final String status;
  final int id;

  ChangeActivationParams({required this.status, required this.id});

  @override
  BodyMap getBody() => {"status": status, "id": id};
}
