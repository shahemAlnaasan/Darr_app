// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/data_sources/auth_remote_data_source.dart'
    as _i25;
import '../../features/auth/data/repositories/auth_repository_imp.dart'
    as _i872;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/use_cases/login_usecase.dart' as _i1012;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/home/presentation/bloc/home_bloc.dart' as _i202;
import '../../features/prices/data/data_sources/prices_remote_data_source.dart'
    as _i129;
import '../../features/prices/data/repositories/prices_repository_imp.dart'
    as _i426;
import '../../features/prices/domain/repositories/prices_repository.dart'
    as _i535;
import '../../features/prices/domain/use_cases/add_exchange_syp_usecase.dart'
    as _i349;
import '../../features/prices/domain/use_cases/add_exchange_usd_usecase.dart'
    as _i554;
import '../../features/prices/domain/use_cases/avg_prices_usecase.dart'
    as _i419;
import '../../features/prices/domain/use_cases/get_curs_usecase.dart' as _i508;
import '../../features/prices/domain/use_cases/get_exchange_syp_usecase.dart'
    as _i480;
import '../../features/prices/domain/use_cases/get_exchange_usd_usecase.dart'
    as _i605;
import '../../features/prices/domain/use_cases/get_prices_usecase.dart'
    as _i960;
import '../../features/prices/domain/use_cases/get_usd_prices_usecase.dart'
    as _i913;
import '../../features/prices/presentation/bloc/prices_bloc.dart' as _i191;
import '../datasources/hive_helper.dart' as _i330;
import '../network/http_client.dart' as _i1069;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i330.HiveHelper>(() => _i330.HiveHelper());
    gh.lazySingleton<_i1069.HTTPClient>(() => _i1069.DioClient());
    gh.factory<_i25.AuthRemoteDataSource>(
      () => _i25.AuthRemoteDataSource(httpClient: gh<_i1069.HTTPClient>()),
    );
    gh.factory<_i129.PricesRemoteDataSource>(
      () => _i129.PricesRemoteDataSource(httpClient: gh<_i1069.HTTPClient>()),
    );
    gh.factory<_i787.AuthRepository>(
      () => _i872.AuthRepositoryImp(
        authRemoteDataSource: gh<_i25.AuthRemoteDataSource>(),
      ),
    );
    gh.factory<_i535.PricesRepository>(
      () => _i426.PricesRepositoryImp(
        pricesRemoteDataSource: gh<_i129.PricesRemoteDataSource>(),
      ),
    );
    gh.factory<_i419.AvgPricesUsecase>(
      () => _i419.AvgPricesUsecase(
        pricesRepository: gh<_i535.PricesRepository>(),
      ),
    );
    gh.factory<_i508.GetCursUsecase>(
      () =>
          _i508.GetCursUsecase(pricesRepository: gh<_i535.PricesRepository>()),
    );
    gh.factory<_i480.GetExchangeSypUsecase>(
      () => _i480.GetExchangeSypUsecase(
        pricesRepository: gh<_i535.PricesRepository>(),
      ),
    );
    gh.factory<_i605.GetExchangeUsdUsecase>(
      () => _i605.GetExchangeUsdUsecase(
        pricesRepository: gh<_i535.PricesRepository>(),
      ),
    );
    gh.factory<_i960.GetPricesUsecase>(
      () => _i960.GetPricesUsecase(
        pricesRepository: gh<_i535.PricesRepository>(),
      ),
    );
    gh.factory<_i913.GetUsdPricesUsecase>(
      () => _i913.GetUsdPricesUsecase(
        pricesRepository: gh<_i535.PricesRepository>(),
      ),
    );
    gh.factory<_i349.AddExchangeSypUsecase>(
      () => _i349.AddExchangeSypUsecase(
        pricesRepository: gh<_i535.PricesRepository>(),
      ),
    );
    gh.factory<_i554.AddExchangeUsdUsecase>(
      () => _i554.AddExchangeUsdUsecase(
        pricesRepository: gh<_i535.PricesRepository>(),
      ),
    );
    gh.factory<_i1012.LoginUsecase>(
      () => _i1012.LoginUsecase(authRepository: gh<_i787.AuthRepository>()),
    );
    gh.factory<_i191.PricesBloc>(
      () => _i191.PricesBloc(
        getPricesUsecase: gh<_i960.GetPricesUsecase>(),
        getUsdPricesUsecase: gh<_i913.GetUsdPricesUsecase>(),
        getExchangeSypUsecase: gh<_i480.GetExchangeSypUsecase>(),
        getExchangeUsdUsecase: gh<_i605.GetExchangeUsdUsecase>(),
        getCursUsecase: gh<_i508.GetCursUsecase>(),
        addExchangeSypUsecase: gh<_i349.AddExchangeSypUsecase>(),
        addExchangeUsdUsecase: gh<_i554.AddExchangeUsdUsecase>(),
      ),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(loginUsecase: gh<_i1012.LoginUsecase>()),
    );
    gh.factory<_i202.HomeBloc>(
      () => _i202.HomeBloc(avgPricesUsecase: gh<_i419.AvgPricesUsecase>()),
    );
    return this;
  }
}
