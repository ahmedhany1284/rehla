part of 'home_cubit.dart';

enum HomeStatus { initial, loading, loaded, empty, error }

const _undefined = Object();

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.data,
    this.errorMessage,
  });

  final HomeStatus status;
  final HomeData? data;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    Object? data = _undefined,
    Object? errorMessage = _undefined,
  }) {
    return HomeState(
      status: status ?? this.status,
      data: identical(data, _undefined) ? this.data : data as HomeData?,
      errorMessage: identical(errorMessage, _undefined)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage];
}
