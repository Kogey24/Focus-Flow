// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionNotifierHash() => r'77d889035e5b5a1728063a521d5cd9cc08b02bf9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SessionNotifier
    extends BuildlessAutoDisposeAsyncNotifier<SessionViewState> {
  late final String? materialId;
  late final String? chapterId;

  FutureOr<SessionViewState> build({String? materialId, String? chapterId});
}

/// See also [SessionNotifier].
@ProviderFor(SessionNotifier)
const sessionNotifierProvider = SessionNotifierFamily();

/// See also [SessionNotifier].
class SessionNotifierFamily extends Family<AsyncValue<SessionViewState>> {
  /// See also [SessionNotifier].
  const SessionNotifierFamily();

  /// See also [SessionNotifier].
  SessionNotifierProvider call({String? materialId, String? chapterId}) {
    return SessionNotifierProvider(
      materialId: materialId,
      chapterId: chapterId,
    );
  }

  @override
  SessionNotifierProvider getProviderOverride(
    covariant SessionNotifierProvider provider,
  ) {
    return call(materialId: provider.materialId, chapterId: provider.chapterId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sessionNotifierProvider';
}

/// See also [SessionNotifier].
class SessionNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          SessionNotifier,
          SessionViewState
        > {
  /// See also [SessionNotifier].
  SessionNotifierProvider({String? materialId, String? chapterId})
    : this._internal(
        () => SessionNotifier()
          ..materialId = materialId
          ..chapterId = chapterId,
        from: sessionNotifierProvider,
        name: r'sessionNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sessionNotifierHash,
        dependencies: SessionNotifierFamily._dependencies,
        allTransitiveDependencies:
            SessionNotifierFamily._allTransitiveDependencies,
        materialId: materialId,
        chapterId: chapterId,
      );

  SessionNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.materialId,
    required this.chapterId,
  }) : super.internal();

  final String? materialId;
  final String? chapterId;

  @override
  FutureOr<SessionViewState> runNotifierBuild(
    covariant SessionNotifier notifier,
  ) {
    return notifier.build(materialId: materialId, chapterId: chapterId);
  }

  @override
  Override overrideWith(SessionNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SessionNotifierProvider._internal(
        () => create()
          ..materialId = materialId
          ..chapterId = chapterId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        materialId: materialId,
        chapterId: chapterId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SessionNotifier, SessionViewState>
  createElement() {
    return _SessionNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionNotifierProvider &&
        other.materialId == materialId &&
        other.chapterId == chapterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, materialId.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SessionNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<SessionViewState> {
  /// The parameter `materialId` of this provider.
  String? get materialId;

  /// The parameter `chapterId` of this provider.
  String? get chapterId;
}

class _SessionNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SessionNotifier,
          SessionViewState
        >
    with SessionNotifierRef {
  _SessionNotifierProviderElement(super.provider);

  @override
  String? get materialId => (origin as SessionNotifierProvider).materialId;
  @override
  String? get chapterId => (origin as SessionNotifierProvider).chapterId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
