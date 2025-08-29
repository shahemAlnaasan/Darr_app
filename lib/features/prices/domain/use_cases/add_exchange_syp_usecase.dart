import '../../../../common/consts/typedef.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddExchangeSypUsecase {
  final PricesRepository pricesRepository;

  AddExchangeSypUsecase({required this.pricesRepository});

  DataResponse<void> call({required AddExchangeParams params}) {
    return pricesRepository.addExchangeSyp(params: params);
  }
}

class AddExchangeParams with Params {
  final String id;
  final String cur;

  AddExchangeParams({required this.id, required this.cur});

  @override
  BodyMap getBody() => {"id": id, "cur": cur};
}
