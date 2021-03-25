
import 'package:get_it/get_it.dart';
import 'package:real_estate/providers/auth.dart';
import 'package:real_estate/providers/location_provider.dart';
import 'package:real_estate/providers/mainprovider.dart';
import 'package:real_estate/providers/property_provider.dart';
import 'package:real_estate/services/navigationService.dart';

GetIt getIt = GetIt.instance;
void setupLocator() {
  
getIt.registerLazySingleton(() => NavigationService());
getIt.registerLazySingleton(() => MainProvider());
getIt.registerLazySingleton(() => Auth());
getIt.registerLazySingleton(() => PropertiesProvider());
getIt.registerLazySingleton(() => LocationProvider());




}