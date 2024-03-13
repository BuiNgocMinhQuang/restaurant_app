import 'package:app_restaurant/bloc/login/login_bloc.dart';
import 'package:app_restaurant/bloc/manager/room/list_room_bloc.dart';
import 'package:app_restaurant/bloc/manager/tables/table_bloc.dart';
import 'package:app_restaurant/bloc/network/network_cubit.dart';
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
          create: (_) => ListRoomBloc()..add(const ListRoomInit()),
        ),
        BlocProvider(
          create: (_) => TableBloc(),
        ),
        BlocProvider(
          create: (_) => InternetCubit(),
        ),
      ],
      child: child,
    );
  }
}
