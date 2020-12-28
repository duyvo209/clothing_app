import 'package:duyvo/blocs/authencation/authencation_bloc.dart';
import 'package:duyvo/blocs/jeans/jeans_bloc.dart';
import 'package:duyvo/blocs/login/login_bloc.dart';
import 'package:duyvo/blocs/new_arrivals/new_arrivals_bloc.dart';
import 'package:duyvo/blocs/order/order_bloc.dart';
import 'package:duyvo/blocs/products/products_bloc.dart';
import 'package:duyvo/blocs/shirts/shirt_bloc.dart';
import 'package:duyvo/blocs/tshirts/tshirt_bloc.dart';
import 'package:duyvo/blocs/yourorder/yourorder_bloc.dart';
import 'package:duyvo/pages/theme_changer.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:duyvo/pages/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'blocs/cart/cart_bloc.dart';
import 'blocs/register/register_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'blocs/user/user_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // if (!kReleaseMode) {
  //   Bloc.observer = AppBlocObserver();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(EasyLocalization(
    child: (MyApp()),
    path: "assets/langs",
    saveLocale: true,
    supportedLocales: [
      Locale('vi', 'VN'),
      Locale('en', 'US'),
    ],
    fallbackLocale: Locale('en', 'US'),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;
  void initializeFlutterFire() async {
    setState(() {
      isLoading = true;
    });
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    // initializeFlutterFire();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Bloc.observer = SimpleBlocObserver();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => RegisterBloc()),
          BlocProvider(create: (context) => ProductsBloc()),
          BlocProvider(create: (context) => TshirtBloc()),
          BlocProvider(create: (context) => ShirtBloc()),
          BlocProvider(create: (context) => JeansBloc()),
          BlocProvider(create: (context) => NewArrivalsBloc()),
          BlocProvider(create: (context) => CartBloc()),
          BlocProvider(create: (context) => OrderBloc()),
          BlocProvider(create: (context) => YourorderBloc()),
          BlocProvider(create: (context) => UserBloc()),
          BlocProvider(create: (context) => LoginBloc()),
          BlocProvider(
              create: (context) => AuthencationBloc(
                  loginBloc: BlocProvider.of<LoginBloc>(context),
                  cartBloc: BlocProvider.of<CartBloc>(context),
                  userBloc: BlocProvider.of<UserBloc>(context))
                ..add(StartApp())),
        ],
        child: ThemeBuilder(
            defaultBrightness: Brightness.light,
            builder: (context, _brightness) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  fontFamily: "poppins",
                  // scaffoldBackgroundColor: Colors.white,
                  dividerColor: Colors.transparent,
                  // primarySwatch: Colors.blue,
                  brightness: _brightness,
                ),
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: BlocBuilder<AuthencationBloc, AuthencationState>(
                  builder: (context, state) {
                    if (state is AuthencationLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is AuthenticationAuthenticated ||
                        state is AuthenticationUnauthenticated) {
                      return HomePage();
                    }
                    if (state is AuthenticationUnVerifyPhone) {
                      //return Verfiyh phone page;
                    }
                    return Container();
                  },
                ),
              );
            }),
      ),
    );
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    print(change);
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}
