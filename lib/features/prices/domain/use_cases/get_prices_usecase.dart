import '../../../../common/consts/typedef.dart';
import '../../data/models/get_prices_response.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPricesUsecase {
  final PricesRepository pricesRepository;

  GetPricesUsecase({required this.pricesRepository});

  DataResponse<GetPricesResponse> call() {
    return pricesRepository.getPrices();
  }
}
