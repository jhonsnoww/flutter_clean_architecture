import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:demo_clean_architecture/core/network/network_info.dart';
import 'package:demo_clean_architecture/core/presentation/utils/input_converter.dart';
import 'package:demo_clean_architecture/features/number_trivia/data/datasource/number_triva_remote_datasource.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/respositories/number_tirvia_respositoryImpl.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/respositories/number_trivia_respository.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number.dart';
import 'package:demo_clean_architecture/features/number_trivia/domain/usecases/get_random_number_triviar.dart';
import 'package:demo_clean_architecture/features/number_trivia/presentations/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/number_trivia/data/datasource/number_trivia_local_data_source.dart';

final sl = GetIt.instance;
Future<void> init() async {
  sl.registerFactory(() =>
      NumberTriviaBloc(concrete: sl(), random: sl(), inputConverter: sl()));

  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  sl.registerLazySingleton<NumberTriviaReqpository>(() =>
      NumberTriviaRespositoryImpl(
          localDataSource: sl(), networkInfo: sl(), remoteDataSource: sl()));

  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sl()));

  // core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
