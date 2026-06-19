import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// ============================================================================
// REACTIVE APP STATE - Menggunakan StateNotifier (mutable, efficient)
// ============================================================================

@immutable
class AppState {
  final bool isNetworkAvailable;
  final bool isMaintenanceMode;
  final String? syncStatus;
  final int pendingSyncCount;
  final DateTime? lastSyncTime;

  const AppState({
    this.isNetworkAvailable = true,
    this.isMaintenanceMode = false,
    this.syncStatus,
    this.pendingSyncCount = 0,
    this.lastSyncTime,
  });

  AppState copyWith({
    bool? isNetworkAvailable,
    bool? isMaintenanceMode,
    String? syncStatus,
    int? pendingSyncCount,
    DateTime? lastSyncTime,
  }) {
    return AppState(
      isNetworkAvailable: isNetworkAvailable ?? this.isNetworkAvailable,
      isMaintenanceMode: isMaintenanceMode ?? this.isMaintenanceMode,
      syncStatus: syncStatus ?? this.syncStatus,
      pendingSyncCount: pendingSyncCount ?? this.pendingSyncCount,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          isNetworkAvailable == other.isNetworkAvailable &&
          isMaintenanceMode == other.isMaintenanceMode &&
          syncStatus == other.syncStatus &&
          pendingSyncCount == other.pendingSyncCount;

  @override
  int get hashCode => Object.hash(
      isNetworkAvailable, isMaintenanceMode, syncStatus, pendingSyncCount);
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState()) {
    _monitorConnectivity();
  }

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  void _monitorConnectivity() {
    _connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final hasConnection =
          results.any((r) => r != ConnectivityResult.none);
      state = state.copyWith(
        isNetworkAvailable: hasConnection,
        syncStatus: hasConnection ? 'online' : 'offline',
      );

      if (hasConnection && state.pendingSyncCount > 0) {
        _syncPendingData();
      }
    });
  }

  void setMaintenanceMode(bool enabled) {
    state = state.copyWith(isMaintenanceMode: enabled);
  }

  void incrementPendingSync() {
    state = state.copyWith(pendingSyncCount: state.pendingSyncCount + 1);
  }

  Future<void> _syncPendingData() async {
    state = state.copyWith(syncStatus: 'syncing');
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      syncStatus: 'synced',
      pendingSyncCount: 0,
      lastSyncTime: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }
}

/// Provider utama untuk state aplikasi global.
final appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

// ============================================================================
// NETWORK STATUS PROVIDER
// ============================================================================

final networkStatusProvider =
    StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(networkStatusProvider);
  return connectivity.whenOrNull(
        data: (results) => results.any((r) => r != ConnectivityResult.none),
      ) ??
      true;
});

// ============================================================================
// GLOBAL REFRESH KEY PROVIDER
// ============================================================================

/// Provider untuk trigger refresh global.
/// Screen manapun bisa `ref.read(globalRefreshKeyProvider).value++` untuk
/// memicu refresh di semua screen yang watch provider ini.
final globalRefreshKeyProvider =
    StateProvider<ValueNotifier<int>>((ref) => ValueNotifier(0));

// ============================================================================
// PERSISTENT CACHE CONFIG
// ============================================================================

/// Konfigurasi cache duration untuk berbagai jenis data.
class CacheDuration {
  static const Duration transactionTypes = Duration(hours: 1);
  static const Duration userProfiles = Duration(minutes: 5);
  static const Duration students = Duration(minutes: 3);
  static const Duration transactions = Duration(minutes: 1);
  static const Duration dashboard = Duration(minutes: 2);
}

// ============================================================================
// ERROR HANDLING PROVIDER
// ============================================================================

/// Provider untuk menyimpan dan menampilkan error global.
final globalErrorProvider = StateProvider<String?>((ref) => null);
