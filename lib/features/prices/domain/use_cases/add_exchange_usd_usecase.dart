import 'package:exchange_darr/features/prices/domain/use_cases/add_exchange_syp_usecase.dart';

import '../../../../common/consts/typedef.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddExchangeUsdUsecase {
  final PricesRepository pricesRepository;

  AddExchangeUsdUsecase({required this.pricesRepository});

  DataResponse<void> call({required AddExchangeParams params}) {
    return pricesRepository.addExchangeUsd(params: params);
  }
}
