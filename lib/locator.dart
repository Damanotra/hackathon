import 'package:get_it/get_it.dart';
import 'package:hackathon/src/resources/provider/api/action_api.dart';

GetIt locator = GetIt.instance;

void setupLocator() async {

  locator.registerLazySingleton(() => ActionAPI());

}