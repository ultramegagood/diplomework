import 'package:diplome_aisha/action_store.dart';
import 'package:get_it/get_it.dart';

GetIt serviceLocator = GetIt.instance;

Future<void> serviceLocatorSetup() async {
  serviceLocator.registerSingleton<LocalStore>(LocalStore());
}
