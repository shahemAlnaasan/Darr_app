import 'package:exchange_darr/common/consts/typedef.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_exchage_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_exchange_syp_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_exchange_usd_usecase.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/prices_repository.dart';
import '../data_sources/prices_remote_data_source.dart';
import '../models/avg_prices_response.dart';

@Injectable(as: PricesRepository)
class PricesRepositoryImp implements PricesRepository {
  final PricesRemoteDataSource pricesRemoteDataSource;

  PricesRepositoryImp({required this.pricesRemoteDataSource});

  @override
  DataResponse<AvgPricesResponse> avgPrices() {
    return pricesRemoteDataSource.avgPrices();
  }

  @override
  DataResponse<GetPricesResponse> getPrices() {
    return pricesRemoteDataSource.getPrices();
  }

  @override
  DataResponse<GetPricesResponse> getUsdPrices() {
    return pricesRemoteDataSource.getUsdPrices();
  }

  @override
  DataResponse<GetExchangeResponse> getExchangeSyp({required GetExchangeSypParams params}) {
    return pricesRemoteDataSource.getExchageSyp(params: params);
  }

  @override
  DataResponse<GetExchangeResponse> getExchangeUsd({required GetExchangeUsdParams params}) {
    return pricesRemoteDataSource.getExchageUsd(params: params);
  }

  @override
  DataResponse<GetCursResponse> getCurs() {
    return pricesRemoteDataSource.getCurs();
  }
}
