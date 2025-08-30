import 'package:exchange_darr/core/models/status_response_model.dart';

import '../../../../common/consts/typedef.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateExchangeSypUsecase {
  final PricesRepository pricesRepository;

  UpdateExchangeSypUsecase({required this.pricesRepository});

  DataResponse<StatusResponseModel> call({required UpdateExchangeParams params}) {
    return pricesRepository.updateExchangeSyp(params: params);
  }
}

class UpdateExchangeParams with Params {
  final String id;
  final String cur;
  final String buy;
  final String sell;

  UpdateExchangeParams({required this.id, required this.cur, required this.buy, required this.sell});

  @override
  BodyMap getBody() => {"id": id, "cur": cur, "buy": buy, "sell": sell};
}
