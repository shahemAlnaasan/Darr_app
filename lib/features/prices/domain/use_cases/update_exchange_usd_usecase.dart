import 'package:exchange_darr/core/models/status_response_model.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/update_exchange_syp_usecase.dart';

import '../../../../common/consts/typedef.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateExchangeUsdUsecase {
  final PricesRepository pricesRepository;

  UpdateExchangeUsdUsecase({required this.pricesRepository});

  DataResponse<StatusResponseModel> call({required UpdateExchangeParams params}) {
    return pricesRepository.updateExchangeUsd(params: params);
  }
}
