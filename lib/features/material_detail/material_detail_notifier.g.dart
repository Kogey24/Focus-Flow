// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$materialDetailNotifierHash() =>
    r'07ccfa210d18528f92d77c6c6c483f68632b32fe';

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

abstract class _$MaterialDetailNotifier
    extends BuildlessAutoDisposeAsyncNotifier<MaterialDetailState> {
  late final String materialId;

  FutureOr<MaterialDetailState> build(String materialId);
}

/// See also [MaterialDetailNotifier].
@ProviderFor(MaterialDetailNotifier)
const materialDetailNotifierProvider = MaterialDetailNotifierFamily();

/// See also [MaterialDetailNotifier].
class MaterialDetailNotifierFamily
    extends Family<AsyncValue<MaterialDetailState>> {
  /// See also [MaterialDetailNotifier].
  const MaterialDetailNotifierFamily();

  /// See also [MaterialDetailNotifier].
  MaterialDetailNotifierProvider call(String materialId) {
    return MaterialDetailNotifierProvider(materialId);
  }

  @override
  MaterialDetailNotifierProvider getProviderOverride(
    covariant MaterialDetailNotifierProvider provider,
  ) {
    return call(provider.materialId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'materialDetailNotifierProvider';
}

/// See also [MaterialDetailNotifier].
class MaterialDetailNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          MaterialDetailNotifier,
          MaterialDetailState
        > {
  /// See also [MaterialDetailNotifier].
  MaterialDetailNotifierProvider(String materialId)
    : this._internal(
        () => MaterialDetailNotifier()..materialId = materialId,
        from: materialDetailNotifierProvider,
        name: r'materialDetailNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$materialDetailNotifierHash,
        dependencies: MaterialDetailNotifierFamily._dependencies,
        allTransitiveDependencies:
            MaterialDetailNotifierFamily._allTransitiveDependencies,
        materialId: materialId,
      );

  MaterialDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.materialId,
  }) : super.internal();

  final String materialId;

  @override
  FutureOr<MaterialDetailState> runNotifierBuild(
    covariant MaterialDetailNotifier notifier,
  ) {
    return notifier.build(materialId);
  }

  @override
  Override overrideWith(MaterialDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MaterialDetailNotifierProvider._internal(
        () => create()..materialId = materialId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        materialId: materialId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    MaterialDetailNotifier,
    MaterialDetailState
  >
  createElement() {
    return _MaterialDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MaterialDetailNotifierProvider &&
        other.materialId == materialId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, materialId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MaterialDetailNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<MaterialDetailState> {
  /// The parameter `materialId` of this provider.
  String get materialId;
}

class _MaterialDetailNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          MaterialDetailNotifier,
          MaterialDetailState
        >
    with MaterialDetailNotifierRef {
  _MaterialDetailNotifierProviderElement(super.provider);

  @override
  String get materialId =>
      (origin as MaterialDetailNotifierProvider).materialId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
