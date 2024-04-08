import 'package:app_restaurant/bloc/bill_table/bill_table_bloc.dart';
import 'package:app_restaurant/bloc/brought_receipt/brought_receipt_bloc.dart';
import 'package:app_restaurant/bloc/list_bill_shop/list_bill_shop_bloc.dart';
import 'package:app_restaurant/bloc/login/staff_login_bloc.dart';
import 'package:app_restaurant/bloc/manager/manager_login/manager_login_bloc.dart';
import 'package:app_restaurant/bloc/manager/room/list_room_bloc.dart';
import 'package:app_restaurant/bloc/manager/tables/table_bloc.dart';
import 'package:app_restaurant/bloc/network/network_cubit.dart';
import 'package:app_restaurant/bloc/payment/payment_bloc.dart';

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
          create: (_) => LoginBloc(),
        ),
        BlocProvider(
          create: (_) => ListRoomBloc(),
        ),
        BlocProvider(
          create: (_) => TableBloc(),
        ),
        BlocProvider(create: (_) => ManagerLoginBloc()),
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
        BlocProvider(create: (_) => PrintBroughtReceiptBloc()),
        BlocProvider(create: (_) => ListBillShopBloc()),
      ],
      child: child,
    );
  }
}
