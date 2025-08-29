import 'package:exchange_darr/common/consts/typedef.dart';
import 'package:exchange_darr/features/prices/data/models/avg_prices_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart';

abstract class PricesRepository {
  DataResponse<AvgPricesResponse> avgPrices();
  DataResponse<GetPricesResponse> getPrices();
  DataResponse<GetPricesResponse> getUsdPrices();
}
