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
import '../data/services/api/api_service.dart' as _i552;
import '../data/services/firebase_ai_service.dart' as _i39;
import '../data/services/token_storage_service.dart' as _i1020;
import '../ui/auth/view_models/auth_view_model.dart' as _i934;
import '../ui/camera_preview/view_models/camera_preview_view_model.dart'
    as _i897;
import '../ui/category/view_models/category_view_model.dart' as _i277;
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
    gh.lazySingleton<_i1020.TokenStorageService>(
      () => _i1020.TokenStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingletonAsync<_i552.ApiService>(() {
      final i = _i552.ApiService(
        gh<_i1020.TokenStorageService>(),
        gh<_i519.Client>(),
      );
      return i.init().then((_) => i);
    });
    gh.lazySingletonAsync<_i136.CategoryRepository>(
      () async => _i136.CategoryRepository(await getAsync<_i552.ApiService>()),
    );
    gh.lazySingletonAsync<_i717.TransactionRepository>(
      () async =>
          _i717.TransactionRepository(await getAsync<_i552.ApiService>()),
    );
    gh.factory<_i507.FirebaseAiRepository>(
      () => _i507.FirebaseAiRepository(aiService: gh<_i39.FirebaseAiService>()),
    );
    gh.lazySingletonAsync<_i578.AuthRepository>(
      () async => _i578.AuthRepository(
        await getAsync<_i552.ApiService>(),
        gh<_i1020.TokenStorageService>(),
      ),
    );
    gh.factoryAsync<_i934.AuthViewModel>(
      () async => _i934.AuthViewModel(await getAsync<_i578.AuthRepository>()),
    );
    gh.factoryAsync<_i277.CategoryViewModel>(
      () async =>
          _i277.CategoryViewModel(await getAsync<_i136.CategoryRepository>()),
    );
    gh.lazySingleton<_i897.CameraPreviewViewModel>(
      () => _i897.CameraPreviewViewModel(
        firebaseAiRepository: gh<_i507.FirebaseAiRepository>(),
      )..init(),
    );
    return this;
  }
}

class _$ThirdPartyModule extends _i372.ThirdPartyModule {}
