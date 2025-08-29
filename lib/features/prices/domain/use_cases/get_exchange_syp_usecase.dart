import '../../../../common/consts/typedef.dart';
import '../../data/models/get_exchage_response.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExchangeSypUsecase {
  final PricesRepository pricesRepository;

  GetExchangeSypUsecase({required this.pricesRepository});

  DataResponse<GetExchangeResponse> call({required GetExchangeSypParams params}) {
    return pricesRepository.getExchangeSyp(params: params);
  }
}

class GetExchangeSypParams with Params {
  final String id;

  GetExchangeSypParams({required this.id});

  @override
  BodyMap getBody() => {"id": id};
}
