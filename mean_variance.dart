import 'dart:math';

void main() async {
  final int count = 10000000;
  final stream = generateRandomGaussianStream(count);
  final pseudoStream = await streamToList(stream);

  naiveSum(
    Stream.fromIterable(pseudoStream)
  ).then((result) => print('Naive-Sum: $result'));
  
  naiveMean(
    Stream.fromIterable(pseudoStream)
  ).then((result) => print('Naive-Mean: $result'));

  kahanSum(
    Stream.fromIterable(pseudoStream)
  ).then((result) => print('Kahan-Sum: $result'));
  
  kahanMean(
    Stream.fromIterable(pseudoStream)
  ).then((result) => print('Kahan-Mean: $result'));

  naiveVariance(
    Stream.fromIterable(pseudoStream)
  ).then((result) => print('Naive-Variance $result'));
  
  improvedVariance(
    Stream.fromIterable(pseudoStream)
  ).then((result) => print('Improved-Variance: $result'));

}


// Naive algorithm

Future<double> naiveSum(Stream<double> stream) async {
  double sum = 0;

  await for (final value in stream) {
    sum += value;
  }
  return sum;
}

Future<double> naiveMean(Stream<double> stream) async {
  double mean = 0;
  int n = 1;

  await for (final value in stream) {
    mean = ((mean * n) + value) / (n + 1);
    n++;
  }
  return mean;
}

// Algorithms using the Kahan summation algorithm

Future<double> kahanSum(Stream<double> stream) async {
  double sum = 0;
  double c = 0;

  await for (final value in stream) {
    double y = value - c;
    double t = sum + y;
    c = (t - sum) - y;
    sum = t;
  }
  return sum;
}

Future<double> kahanMean(Stream<double> stream) async {
  double mean = 0;
  int n = 1;
  double c = 0;

  await for (final value in stream) {
    double sum = mean * n;
    double y = value - c;
    double t = sum + y;
    c = (t - sum) - y;
    mean = t / (n + 1);
    n++;
  }
  return mean;
}

// One pass variance algorithm

Future<double> naiveVariance(Stream<double> stream) async {
  double sum = 0;
  double sumOfSquares = 0;
  int n = 0;

  await for (final value in stream) {
    sumOfSquares += pow(value, 2);
    sum += value;
    n++;
  }
  return (1 / n) * (sumOfSquares - (1 / n) * pow(sum, 2));
}

Future<double> improvedVariance(Stream<double> stream) async {
  double s = 0;
  double mean = 0;
  int n = 1;

  await for (final value in stream) {
    double newMean = ((n * mean) + value) / (n + 1);
    s = s + ((value - mean) * (value - newMean));
    n++;
    mean = newMean;
  }
  n--;
  return (1 / n) * s;
}

// Recursive mean

// Recursive variance

// Utilities for creating a Stream

Stream<double> generateRandomGaussianStream(int count) async* {
  final random = Random();
  for (int i = 0; i < count / 2; i++) {
    List<double> values = randomGaussian(random);
    yield values[0];
    yield values[1];
  }
}

List<double> randomGaussian(Random random) {
  double u = random.nextDouble(); // Uniform random numbers between [0,1)
  double v = random.nextDouble();
  
  // Box-Muller transform
  double x = sqrt((-2) * log(u)) * cos(2 * pi * v);
  double y = sqrt((-2) * log(u)) * sin(2 * pi * v);
  return [x, y];
}

Future<List<T>> streamToList<T>(Stream<T> stream) async {
  final List<T> list = [];
  await for (final item in stream) {
    list.add(item);
  }
  return list;
}

