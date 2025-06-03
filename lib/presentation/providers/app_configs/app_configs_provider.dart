// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/repositories/repositories.dart';

final appConfigsRepositoryProvider = Provider<AppconfigsRepository>((ref) {
  final appConfigRepo = AppConfigsRepositoryImpl();
  return appConfigRepo;
});

final appConfigsFutureProvider = FutureProvider<AppConfigs>((ref) async {
  final appConfigRepo = ref.watch(appConfigsRepositoryProvider);
  return appConfigRepo.getAppConfigs();
});

final appConfigsProvider =
    StateNotifierProvider<AppConfigsNotifier, AppConfgsState>((ref) {
  final appConfigsRepo = ref.watch(appConfigsRepositoryProvider);
  final appConfigsNotfier = AppConfigsNotifier(appConfigsRepo);
  return appConfigsNotfier;
});

class AppConfigsNotifier extends StateNotifier<AppConfgsState> {
  final AppconfigsRepository appconfigsRepo;

  AppConfigsNotifier(this.appconfigsRepo)
      : super(AppConfgsState(configs: AppConfigs.empty()));

  Future<AppConfigs> loadAppConfigs() async {
    if (state.isLoading) return AppConfigs.empty();
    state = state.copyWith(isLoading: true);
    final configs = await appconfigsRepo.getAppConfigs();
    state = state.copyWith(isLoading: false, configs: configs);
    return state.configs;
  }
}

class AppConfgsState {
  final AppConfigs configs;
  final bool isLoading;

  AppConfgsState({required this.configs, this.isLoading = false});

  @override
  bool operator ==(covariant AppConfgsState other) {
    if (identical(this, other)) return true;

    return other.configs == configs && other.isLoading == isLoading;
  }

  @override
  int get hashCode => configs.hashCode ^ isLoading.hashCode;

  AppConfgsState copyWith({
    AppConfigs? configs,
    bool? isLoading,
  }) {
    return AppConfgsState(
      configs: configs ?? this.configs,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
