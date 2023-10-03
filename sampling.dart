import 'dart:math';

import 'mean_variance.dart'; 

void main() async {
  final int count = 10;
  final stream = generateRandomGaussianStream(count);
  final pseudoStream = await streamToList(stream);
  
  bernoulliSampling(
    Stream.fromIterable(pseudoStream),
    0.2
  ).then((result) => print('Naive-Bernoulli-Sampling: $result'));
 
  reservoirSampling(
    Stream.fromIterable(pseudoStream),
    0.2, 
    5
  ).then((result) => print('Reservoir-Sampling $result'));

  improvedBernoulliSampling(
    Stream.fromIterable(pseudoStream),
    0.2
  ).then((result) => print('Improved-Bernoulli-Sampling: $result'));
}

Future<List<double>> bernoulliSampling(Stream<double> stream, double q) async {
  Random random = Random();
  List<double> sample = [];
  await for (final value in stream) {
    double r = random.nextDouble();
    if (r <= q) {
      sample.add(value);
    }
  }
  return sample;
}

Future<List<double>> reservoirSampling(Stream<double> stream, double q, int k) async {
  Random random = Random();
  List<double> sample = [];
  int i = 1;
  await for (final value in stream) {
    if (random.nextDouble() <= k / i) {
      if (sample.length >= k) {
        sample.removeAt(random.nextInt(k));
      }
      sample.add(value);
    }
    i++;
  }
  return sample;
}

Future<List<double>> improvedBernoulliSampling(Stream<double> stream, double q) async {
  Random random = Random();
  List<double> sample = [];
  int skips = (log(random.nextDouble()) / log(1 - q)).ceil() - 1;
  await for (final value in stream) {
    if (skips > 0) {
      skips--;
    } 
    else {
      sample.add(value);
      skips = (log(random.nextDouble()) / log(1 - q)).ceil() - 1;
    }
  }
  return sample;
}

