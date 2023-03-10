import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_app_wear/home/bloc/home_bloc.dart';
import 'package:log_app_wear/strings.dart';
import 'package:log_app_wear/widgets/button.dart';

class PinView extends StatelessWidget {
  const PinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
            child: Text(
              Strings.connectMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          WatchButton(
            onTap: () {
              BlocProvider.of<HomeBloc>(context).add(RequestPin());
            },
            title: Strings.cont,
          ),
        ],
      ),
    );
  }
}
