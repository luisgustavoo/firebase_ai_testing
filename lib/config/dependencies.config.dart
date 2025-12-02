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
import '../data/services/firebase_ai_service/firebase_ai_service.dart' as _i446;
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
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final thirdPartyModule = _$ThirdPartyModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => thirdPartyModule.secureStorage,
    );
    gh.lazySingleton<_i519.Client>(() => thirdPartyModule.httpClient);
    gh.lazySingleton<_i446.FirebaseAiService>(
      () => _i446.FirebaseAiService()..init(),
    );
    gh.lazySingleton<_i899.ThemeProvider>(() => _i899.ThemeProvider());
    gh.lazySingleton<_i1020.TokenStorageService>(
      () => _i1020.TokenStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i552.ApiService>(
      () => _i552.ApiService(gh<_i519.Client>())..init(),
    );
    gh.lazySingleton<_i507.FirebaseAiRepository>(
      () =>
          _i507.FirebaseAiRepository(gh<InvalidType>(), gh<_i552.ApiService>())
            ..init(),
    );
    gh.lazySingleton<_i136.CategoryRepository>(
      () => _i136.CategoryRepository(gh<_i552.ApiService>()),
    );
    gh.lazySingleton<_i717.TransactionRepository>(
      () => _i717.TransactionRepository(gh<_i552.ApiService>()),
    );
    gh.lazySingleton<_i977.UserRepository>(
      () => _i977.UserRepository(gh<_i552.ApiService>()),
    );
    gh.factory<_i39.ReceiptScannerViewModel>(
      () => _i39.ReceiptScannerViewModel(gh<_i507.FirebaseAiRepository>()),
    );
    gh.factory<_i277.CategoryViewModel>(
      () => _i277.CategoryViewModel(
        gh<_i136.CategoryRepository>(),
        gh<_i977.UserRepository>(),
      ),
    );
    await gh.lazySingletonAsync<_i578.AuthRepository>(() {
      final i = _i578.AuthRepository(
        gh<_i552.ApiService>(),
        gh<_i1020.TokenStorageService>(),
      );
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.factory<_i337.LogoutViewModel>(
      () => _i337.LogoutViewModel(
        authRepository: gh<_i578.AuthRepository>(),
        userRepository: gh<_i977.UserRepository>(),
      ),
    );
    gh.factory<_i712.TransactionViewModel>(
      () => _i712.TransactionViewModel(gh<_i717.TransactionRepository>()),
    );
    gh.factory<_i152.HomeViewModel>(
      () => _i152.HomeViewModel(
        userRepository: gh<_i977.UserRepository>(),
        transactionRepository: gh<_i717.TransactionRepository>(),
      ),
    );
    gh.factory<_i180.AddTransactionViewModel>(
      () => _i180.AddTransactionViewModel(
        gh<_i717.TransactionRepository>(),
        gh<_i136.CategoryRepository>(),
        gh<_i977.UserRepository>(),
      ),
    );
    gh.factory<_i934.AuthViewModel>(
      () => _i934.AuthViewModel(
        gh<_i578.AuthRepository>(),
        gh<_i977.UserRepository>(),
      ),
    );
    gh.factory<_i37.SplashViewModel>(
      () => _i37.SplashViewModel(
        gh<_i578.AuthRepository>(),
        gh<_i977.UserRepository>(),
      ),
    );
    return this;
  }
}

class _$ThirdPartyModule extends _i372.ThirdPartyModule {}
