

import 'package:cinemapedia/infraestructure/datasource/isar_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/local_storage_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageProvider = Provider((ref) => 
  LocalStorageRepositoryImpl( IsarDatasource()));