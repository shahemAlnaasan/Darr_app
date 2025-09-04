import 'package:exchange_darr/core/models/status_response_model.dart';

import '../../../../common/consts/typedef.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteMsgUsecase {
  final PricesRepository pricesRepository;

  DeleteMsgUsecase({required this.pricesRepository});

  DataResponse<StatusResponseModel> call({required DeleteMsgParams params}) {
    return pricesRepository.deleteMsg(params: params);
  }
}

class DeleteMsgParams with Params {
  final int id;
  final int userId;

  DeleteMsgParams({required this.id, required this.userId});

  @override
  BodyMap getBody() => {"id": id, "userId": userId};
}
