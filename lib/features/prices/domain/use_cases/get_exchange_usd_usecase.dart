import 'package:exchange_darr/features/prices/data/models/get_exchage_response.dart';

import '../../../../common/consts/typedef.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExchangeUsdUsecase {
  final PricesRepository pricesRepository;

  GetExchangeUsdUsecase({required this.pricesRepository});

  DataResponse<GetExchangeResponse> call({required GetExchangeUsdParams params}) {
    return pricesRepository.getExchangeUsd(params: params);
  }
}

class GetExchangeUsdParams with Params {
  final String id;

  GetExchangeUsdParams({required this.id});

  @override
  BodyMap getBody() => {"id": id};
}
