import 'package:duyvo/blocs/jeans/jeans_bloc.dart';
import 'package:duyvo/blocs/login/login_bloc.dart';
import 'package:duyvo/blocs/new_arrivals/new_arrivals_bloc.dart';
import 'package:duyvo/blocs/order/order_bloc.dart';
import 'package:duyvo/blocs/products/products_bloc.dart';
import 'package:duyvo/blocs/shirts/shirt_bloc.dart';
import 'package:duyvo/blocs/tshirts/tshirt_bloc.dart';
import 'package:duyvo/blocs/yourorder/yourorder_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:duyvo/pages/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'blocs/cart/cart_bloc.dart';
import 'blocs/register/register_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => LoginBloc()),
            BlocProvider(create: (context) => RegisterBloc()),
            BlocProvider(create: (context) => ProductsBloc()),
            BlocProvider(create: (context) => TshirtBloc()),
            BlocProvider(create: (context) => ShirtBloc()),
            BlocProvider(create: (context) => JeansBloc()),
            BlocProvider(create: (context) => NewArrivalsBloc()),
            BlocProvider(create: (context) => CartBloc()),
            BlocProvider(create: (context) => OrderBloc()),
            BlocProvider(create: (context) => YourorderBloc()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(),
            theme: ThemeData(
              fontFamily: "poppins",
              scaffoldBackgroundColor: Colors.white,
              dividerColor: Colors.transparent,
            ),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          ),
        ));
  }
}

// class AppBlocObserver extends BlocObserver {
//   @protected
//   @mustCallSuper
//   void onEvent(Bloc bloc, Object event) {
//     super.onEvent(bloc, event);
//     print('onEvent:: ${bloc.runtimeType} -> $event');
//   }

//   /// Called whenever a [Change] occurs in any [cubit]
//   /// A [change] occurs when a new state is emitted.
//   /// [onChange] is called before a cubit's state has been updated.
//   @protected
//   @mustCallSuper
//   void onChange(Cubit cubit, Change change) {
//     super.onChange(cubit, change);
//     print('onChange:: ${cubit.runtimeType} -> $change');
//   }

//   /// Called whenever a transition occurs in any [bloc] with the given [bloc]
//   /// and [transition].
//   /// A [transition] occurs when a new `event` is `added` and `mapEventToState`
//   /// executed.
//   /// [onTransition] is called before a [bloc]'s state has been updated.
//   @protected
//   @mustCallSuper
//   void onTransition(Bloc bloc, Transition transition) {
//     super.onTransition(bloc, transition);
//     print('onTransition:: ${bloc.runtimeType} -> $transition');
//   }

//   /// Called whenever an [error] is thrown in any [Bloc] or [Cubit].
//   /// The [stackTrace] argument may be `null` if the state stream received
//   /// an error without a [stackTrace].
//   @protected
//   @mustCallSuper
//   void onError(Cubit cubit, Object error, StackTrace stackTrace) {
//     super.onError(cubit, error, stackTrace);
//     print('onError:: ${cubit.runtimeType} -> $error');
//   }
// }
