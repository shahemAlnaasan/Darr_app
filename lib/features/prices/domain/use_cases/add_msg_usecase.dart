import 'package:exchange_darr/core/models/status_response_model.dart';

import '../../../../common/consts/typedef.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddMsgUsecase {
  final PricesRepository pricesRepository;

  AddMsgUsecase({required this.pricesRepository});

  DataResponse<StatusResponseModel> call({required AddMsgParams params}) {
    return pricesRepository.addMsg(params: params);
  }
}

class AddMsgParams with Params {
  final int id;
  final String msg;

  AddMsgParams({required this.id, required this.msg});

  @override
  BodyMap getBody() => {"id": id, "msg": msg};
}
