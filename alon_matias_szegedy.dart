import 'dart:math';
import 'dart:collection';

import 'mean_variance.dart';

void main() async {
  final int count = 10;
  final stream = generateRandomGaussianStream(count);
  final pseudoStream = await streamToList(stream);
  
  alonMatiasSzegedy(
    Stream.fromIterable(pseudoStream),
    3
  ).then((result) => print('Alon Matias Szegedy: $result'));
  
  secondFrequencyMoment(
    Stream.fromIterable(pseudoStream)
  ).then((result) => print('M2: $result'));
}


Future<double> alonMatiasSzegedy(Stream<double> stream, int s) async {

  await for (final value in stream) {
    // TODO reservoir
  }
  return Future.value(0);
}

Future<double> secondFrequencyMoment(Stream<double> stream) async {
  HashMap<double, int> d = HashMap();

  await for (final value in stream) {
    if (d.containsKey(value)) {
      d[value] = d[value] !+ 1;
    }
    else {
      d[value] = 1;
    }
  }

  double m2 = 0;
  for (final amount in d.values) {
    m2 += pow(amount, 2);
  }

  return m2;
}
