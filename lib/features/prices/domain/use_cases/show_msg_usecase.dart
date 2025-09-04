import '../../../../common/consts/typedef.dart';
import '../../data/models/show_msg_response.dart';
import '../repositories/prices_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShowMsgUsecase {
  final PricesRepository pricesRepository;

  ShowMsgUsecase({required this.pricesRepository});

  DataResponse<ShowMsgResponse> call({required ShowMsgParams params}) {
    return pricesRepository.showMsg(params: params);
  }
}

class ShowMsgParams with Params {
  final int id;

  ShowMsgParams({required this.id});

  @override
  BodyMap getBody() => {"id": id};
}
