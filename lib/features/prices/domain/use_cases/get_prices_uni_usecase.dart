import '../../../../common/consts/typedef.dart';
import '../../data/models/get_prices_uni_response.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPricesUniUsecase {
  final PricesRepository pricesRepository;

  GetPricesUniUsecase({required this.pricesRepository});

  DataResponse<List<GetPricesUniResponse>> call() {
    return pricesRepository.getPricesUni();
  }
}
