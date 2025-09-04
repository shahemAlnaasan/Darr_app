part of 'prices_bloc.dart';

class PricesState extends Equatable {
  final String? errorMessage;
  final Status? getPricesStatus;
  final Status? getExchangeSypStatus;
  final Status? getExchangeUsdStatus;
  final Status? getCursStatus;
  final Status? addExchangeStatus;
  final Status? updateExchangeStatus;
  final Status? getUniPricesStatus;
  final Status? addMsgStatus;
  final Status? showMsgStatus;
  final Status? deleteMsgStatus;
  final Status? changeActivationStatus;
  final Status? checkActivationStatus;
  final GetPricesResponse? getPricesResponse;
  final bool? isRefreshPrices;
  final Status? getUsdPricesStatus;
  final GetPricesResponse? getUsdPricesResponse;
  final GetExchangeResponse? getExchangeSypResponse;
  final GetExchangeResponse? getExchangeUsdResponse;
  final List<GetPricesUniResponse>? getPricesUniResponse;
  final CheckActivationStatusResponse? checkActivationStatusResponse;
  final ShowMsgResponse? showMsgResponse;
  final List<Price>? exchangePrices;
  final bool? isRefreshUsdPrices;
  final GetCursResponse? getCursResponse;
  const PricesState({
    this.errorMessage,
    this.addExchangeStatus,
    this.getPricesStatus,
    this.updateExchangeStatus,
    this.addMsgStatus,
    this.showMsgStatus,
    this.deleteMsgStatus,
    this.changeActivationStatus,
    this.checkActivationStatus,
    this.showMsgResponse,
    this.getPricesResponse,
    this.isRefreshPrices,
    this.getUsdPricesStatus,
    this.getUsdPricesResponse,
    this.isRefreshUsdPrices,
    this.getExchangeSypStatus,
    this.getExchangeUsdStatus,
    this.getExchangeSypResponse,
    this.getExchangeUsdResponse,
    this.getUniPricesStatus,
    this.getPricesUniResponse,
    this.checkActivationStatusResponse,
    this.exchangePrices,
    this.getCursStatus,
    this.getCursResponse,
  });

  PricesState copyWith({
    String? errorMessage,
    Status? getPricesStatus,
    Status? getExchangeSypStatus,
    Status? getExchangeUsdStatus,
    Status? addExchangeStatus,
    Status? updateExchangeStatus,
    Status? getCursStatus,
    Status? getUniPricesStatus,
    Status? addMsgStatus,
    Status? showMsgStatus,
    Status? deleteMsgStatus,
    Status? changeActivationStatus,
    Status? checkActivationStatus,
    GetPricesResponse? getPricesResponse,
    bool? isRefreshPrices,
    Status? getUsdPricesStatus,
    GetPricesResponse? getUsdPricesResponse,
    GetExchangeResponse? getExchangeSypResponse,
    GetExchangeResponse? getExchangeUsdResponse,
    List<GetPricesUniResponse>? getPricesUniResponse,
    ShowMsgResponse? showMsgResponse,
    CheckActivationStatusResponse? checkActivationStatusResponse,
    List<Price>? exchangePrices,
    bool? isRefreshUsdPrices,
    GetCursResponse? getCursResponse,
  }) {
    return PricesState(
      errorMessage: errorMessage ?? this.errorMessage,
      getPricesStatus: getPricesStatus ?? this.getPricesStatus,
      getExchangeSypStatus: getExchangeSypStatus ?? this.getExchangeSypStatus,
      getExchangeUsdStatus: getExchangeUsdStatus ?? this.getExchangeUsdStatus,
      addExchangeStatus: addExchangeStatus ?? this.addExchangeStatus,
      changeActivationStatus: changeActivationStatus ?? this.changeActivationStatus,
      checkActivationStatus: checkActivationStatus ?? this.checkActivationStatus,
      updateExchangeStatus: updateExchangeStatus ?? this.updateExchangeStatus,
      getCursStatus: getCursStatus ?? this.getCursStatus,
      getUniPricesStatus: getUniPricesStatus ?? this.getUniPricesStatus,
      addMsgStatus: addMsgStatus ?? this.addMsgStatus,
      showMsgStatus: showMsgStatus ?? this.showMsgStatus,
      deleteMsgStatus: deleteMsgStatus ?? this.deleteMsgStatus,
      getPricesResponse: getPricesResponse ?? this.getPricesResponse,
      isRefreshPrices: isRefreshPrices ?? this.isRefreshPrices,
      getUsdPricesStatus: getUsdPricesStatus ?? this.getUsdPricesStatus,
      getUsdPricesResponse: getUsdPricesResponse ?? this.getUsdPricesResponse,
      getExchangeSypResponse: getExchangeSypResponse ?? this.getExchangeSypResponse,
      getExchangeUsdResponse: getExchangeUsdResponse ?? this.getExchangeUsdResponse,
      showMsgResponse: showMsgResponse ?? this.showMsgResponse,
      isRefreshUsdPrices: isRefreshUsdPrices ?? this.isRefreshUsdPrices,
      exchangePrices: exchangePrices ?? this.exchangePrices,
      getCursResponse: getCursResponse ?? this.getCursResponse,
      getPricesUniResponse: getPricesUniResponse ?? this.getPricesUniResponse,
      checkActivationStatusResponse: checkActivationStatusResponse ?? this.checkActivationStatusResponse,
    );
  }

  @override
  List<Object?> get props => [
    errorMessage,
    getPricesStatus,
    getExchangeSypStatus,
    getExchangeUsdStatus,
    addExchangeStatus,
    updateExchangeStatus,
    getCursStatus,
    getUniPricesStatus,
    showMsgStatus,
    addMsgStatus,
    deleteMsgStatus,
    changeActivationStatus,
    checkActivationStatus,
    getPricesResponse,
    isRefreshPrices,
    getUsdPricesStatus,
    getUsdPricesResponse,
    getExchangeSypResponse,
    getExchangeUsdResponse,
    showMsgResponse,
    isRefreshUsdPrices,
    exchangePrices,
    getCursResponse,
    getPricesUniResponse,
    checkActivationStatusResponse,
  ];
}
