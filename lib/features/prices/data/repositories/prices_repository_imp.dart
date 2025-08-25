import 'package:exchange_darr/common/consts/typedef.dart';
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
}
