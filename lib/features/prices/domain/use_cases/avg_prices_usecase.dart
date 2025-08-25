import '../../../../common/consts/typedef.dart';
import '../../data/models/avg_prices_response.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AvgPricesUsecase {
  final PricesRepository pricesRepository;

  AvgPricesUsecase({required this.pricesRepository});

  DataResponse<AvgPricesResponse> call() {
    return pricesRepository.avgPrices();
  }
}
