// ignore: prefer_generic_function_type_aliases
typedef T InstanceCreator<T>();

class DependencyInjection {
  DependencyInjection._();
  static final instance = DependencyInjection._();
  factory DependencyInjection() => instance;

  final _instanceMap = <Type, _InstanceGenerator<Object>>{};

  void register<T extends Object>(InstanceCreator<T> instance,
          {bool isSingleton = false}) =>
      _instanceMap[T] = _InstanceGenerator(instance, isSingleton);

  T get<T extends Object>() {
    final instance = _instanceMap[T]?.getInstance();
    if (instance != null && instance is T) return instance;
    throw Exception('[ERROR] -> Instance ${instance.toString()} not found');
  }

  call<T extends Object>() => get<T>();
}

class _InstanceGenerator<T> {
  T? _instance;
  bool _isFirstGet = false;
  final InstanceCreator<T> _instanceCreator;
  _InstanceGenerator(this._instanceCreator, bool isSingleton)
      : _isFirstGet = isSingleton;

  T? getInstance() {
    if (_isFirstGet) {
      _instance = _instanceCreator();
      _isFirstGet = false;
    }
    return _instance ?? _instanceCreator();
  }
}
