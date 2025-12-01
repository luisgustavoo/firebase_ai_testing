// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

import '../data/repositories/auth_repository.dart' as _i578;
import '../data/repositories/category_repository.dart' as _i136;
import '../data/repositories/firebase_ai_repository.dart' as _i507;
import '../data/repositories/transaction_repository.dart' as _i717;
import '../data/repositories/user_repository.dart' as _i977;
import '../data/services/api/api_service.dart' as _i552;
import '../data/services/firebase_ai_service.dart' as _i39;
import '../data/services/token_storage_service.dart' as _i1020;
import '../ui/auth/logout/view_models/logout_viewmodel.dart' as _i337;
import '../ui/auth/view_models/auth_view_model.dart' as _i934;
import '../ui/category/view_models/category_view_model.dart' as _i277;
import '../ui/core/themes/theme_provider.dart' as _i899;
import '../ui/home/view_models/home_viewmodel.dart' as _i152;
import '../ui/receipt_scanner/view_models/receipt_scanner_view_model.dart'
    as _i39;
import '../ui/splash/view_models/splash_view_model.dart' as _i37;
import '../ui/transaction/view_models/add_transaction_view_model.dart' as _i180;
import '../ui/transaction/view_models/transaction_view_model.dart' as _i712;
import 'dependencies.dart' as _i372;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final thirdPartyModule = _$ThirdPartyModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => thirdPartyModule.secureStorage,
    );
    gh.lazySingleton<_i519.Client>(() => thirdPartyModule.httpClient);
    gh.lazySingleton<_i39.FirebaseAiService>(
      () => _i39.FirebaseAiService()..init(),
    );
    gh.lazySingleton<_i899.ThemeProvider>(() => _i899.ThemeProvider());
    gh.lazySingleton<_i1020.TokenStorageService>(
      () => _i1020.TokenStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingletonAsync<_i552.ApiService>(() {
      final i = _i552.ApiService(gh<_i519.Client>());
      return i.init().then((_) => i);
    });
    gh.lazySingletonAsync<_i136.CategoryRepository>(
      () async => _i136.CategoryRepository(await getAsync<_i552.ApiService>()),
    );
    gh.lazySingletonAsync<_i717.TransactionRepository>(
      () async =>
          _i717.TransactionRepository(await getAsync<_i552.ApiService>()),
    );
    gh.lazySingletonAsync<_i977.UserRepository>(
      () async => _i977.UserRepository(await getAsync<_i552.ApiService>()),
    );
    gh.lazySingletonAsync<_i507.FirebaseAiRepository>(
      () async => _i507.FirebaseAiRepository(
        gh<_i39.FirebaseAiService>(),
        await getAsync<_i552.ApiService>(),
      )..init(),
    );
    gh.factoryAsync<_i152.HomeViewModel>(
      () async => _i152.HomeViewModel(
        userRepository: await getAsync<_i977.UserRepository>(),
      ),
    );
    gh.lazySingletonAsync<_i578.AuthRepository>(
      () async => _i578.AuthRepository(
        await getAsync<_i552.ApiService>(),
        gh<_i1020.TokenStorageService>(),
      ),
    );
    gh.factoryAsync<_i337.LogoutViewModel>(
      () async => _i337.LogoutViewModel(
        authRepository: await getAsync<_i578.AuthRepository>(),
        userRepository: await getAsync<_i977.UserRepository>(),
      ),
    );
    gh.factoryAsync<_i712.TransactionViewModel>(
      () async => _i712.TransactionViewModel(
        await getAsync<_i717.TransactionRepository>(),
      ),
    );
    gh.factoryAsync<_i934.AuthViewModel>(
      () async => _i934.AuthViewModel(await getAsync<_i578.AuthRepository>()),
    );
    gh.factoryAsync<_i277.CategoryViewModel>(
      () async =>
          _i277.CategoryViewModel(await getAsync<_i136.CategoryRepository>()),
    );
    gh.factoryAsync<_i180.AddTransactionViewModel>(
      () async => _i180.AddTransactionViewModel(
        await getAsync<_i717.TransactionRepository>(),
        await getAsync<_i136.CategoryRepository>(),
      ),
    );
    gh.factoryAsync<_i39.ReceiptScannerViewModel>(
      () async => _i39.ReceiptScannerViewModel(
        await getAsync<_i507.FirebaseAiRepository>(),
      ),
    );
    gh.factoryAsync<_i37.SplashViewModel>(
      () async => _i37.SplashViewModel(
        await getAsync<_i578.AuthRepository>(),
        await getAsync<_i977.UserRepository>(),
      ),
    );
    return this;
  }
}

class _$ThirdPartyModule extends _i372.ThirdPartyModule {}
