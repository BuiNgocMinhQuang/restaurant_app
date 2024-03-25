import 'package:app_restaurant/bloc/bill/bill_bloc.dart';
import 'package:app_restaurant/bloc/brought_receipt/brought_receipt_bloc.dart';
import 'package:app_restaurant/bloc/login/login_bloc.dart';
import 'package:app_restaurant/bloc/manager/room/list_room_bloc.dart';
import 'package:app_restaurant/bloc/manager/tables/table_bloc.dart';
import 'package:app_restaurant/bloc/network/network_cubit.dart';
import 'package:app_restaurant/bloc/payment/payment_bloc.dart';
import 'package:app_restaurant/bloc/staff/infor/staff_infor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocProvider extends StatelessWidget {
  const AppBlocProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoginBloc()..add(const LoginAppInit()),
        ),
        BlocProvider(
          create: (_) => StaffInforBloc(),
        ),
        BlocProvider(
          create: (_) => ListRoomBloc()..add(const ListRoomInit()),
        ),
        BlocProvider(
          create: (_) => TableBloc(),
        ),
        BlocProvider(create: (_) => TableCancleBloc()),
        BlocProvider(create: (_) => TableSaveInforBloc()),
        BlocProvider(create: (_) => SwitchTableBloc()),
        BlocProvider(create: (_) => BillInforBloc()),
        BlocProvider(create: (_) => PaymentInforBloc()),
        BlocProvider(create: (_) => BroughtReceiptBloc()),
        BlocProvider(create: (_) => ManageBroughtReceiptBloc()),
        BlocProvider(
          create: (_) => InternetCubit(),
        ),
        BlocProvider(create: (_) => CancleBroughtReceiptBloc()),
        BlocProvider(create: (_) => QuantityBroughtReceiptBloc()),
      ],
      child: child,
    );
  }
}
