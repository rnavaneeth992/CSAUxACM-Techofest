import 'package:fpdart/fpdart.dart';

//Failure Class
import './failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

typedef FutureVoid = FutureEither<void>;

