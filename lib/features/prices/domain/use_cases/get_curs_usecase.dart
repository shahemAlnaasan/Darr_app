import '../../../../common/consts/typedef.dart';
import '../../data/models/get_curs_response.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCursUsecase {
  final PricesRepository pricesRepository;

  GetCursUsecase({required this.pricesRepository});

  DataResponse<GetCursResponse> call() {
    return pricesRepository.getCurs();
  }
}
