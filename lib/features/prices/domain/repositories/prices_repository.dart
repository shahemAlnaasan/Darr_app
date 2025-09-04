import 'package:exchange_darr/common/consts/typedef.dart';
import 'package:exchange_darr/core/models/status_response_model.dart';
import 'package:exchange_darr/features/prices/data/models/avg_prices_response.dart';
import 'package:exchange_darr/features/prices/data/models/check_activation_status_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_exchage_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_uni_response.dart';
import 'package:exchange_darr/features/prices/data/models/show_msg_response.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/add_exchange_syp_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/add_msg_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/change_activation_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/check_activation_status_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/delete_msg_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_exchange_syp_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_exchange_usd_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/show_msg_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/update_exchange_syp_usecase.dart';

abstract class PricesRepository {
  DataResponse<AvgPricesResponse> avgPrices();
  DataResponse<GetPricesResponse> getPrices();
  DataResponse<GetPricesResponse> getUsdPrices();
  DataResponse<GetExchangeResponse> getExchangeSyp({required GetExchangeSypParams params});
  DataResponse<GetExchangeResponse> getExchangeUsd({required GetExchangeUsdParams params});
  DataResponse<GetCursResponse> getCurs();
  DataResponse<StatusResponseModel> addExchangeUsd({required AddExchangeParams params});
  DataResponse<StatusResponseModel> addExchangeSyp({required AddExchangeParams params});
  DataResponse<StatusResponseModel> updateExchangeSyp({required UpdateExchangeParams params});
  DataResponse<StatusResponseModel> updateExchangeUsd({required UpdateExchangeParams params});
  DataResponse<List<GetPricesUniResponse>> getPricesUni();
  DataResponse<StatusResponseModel> changeActivation({required ChangeActivationParams params});
  DataResponse<StatusResponseModel> addMsg({required AddMsgParams params});
  DataResponse<ShowMsgResponse> showMsg({required ShowMsgParams params});
  DataResponse<StatusResponseModel> deleteMsg({required DeleteMsgParams params});
  DataResponse<CheckActivationStatusResponse> checkActivationStatus({required CheckActivationStatusParams params});
}
