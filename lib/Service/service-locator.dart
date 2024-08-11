import 'package:get_it/get_it.dart';
import 'package:talya_flutter/Service/api-service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<APIService>(() => APIService());
}
