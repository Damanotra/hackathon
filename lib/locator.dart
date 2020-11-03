import 'package:get_it/get_it.dart';
import 'package:hackathon/src/resources/provider/api/action_api.dart';
import 'package:hackathon/src/resources/provider/shared_preference.dart';

GetIt locator = GetIt.instance;

void setupLocator() async {
  final prefs = await Preference.getInstance();
  locator.registerLazySingleton(() => prefs);


  locator.registerLazySingleton(() => ActionAPI());

}