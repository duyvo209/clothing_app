part of 'yourorder_bloc.dart';

abstract class YourorderEvent extends Equatable {
  const YourorderEvent();

  @override
  List<Object> get props => [];
}

class GetListOrder extends YourorderEvent {
  final BuildContext context;
  GetListOrder(this.context);
}
