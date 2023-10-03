import 'dart:math';

void main() {
  List<double> numbers = [3, 48];

  print('Sum:   ' + sum(numbers).toString());
  print('Kahan: ' + kahanSum(numbers).toString());
}

double sum(List<double> numbers) {
  double sum = 0;
  
  for (double n in numbers) {
    sum += n;
  }

  return sum;
}

double kahanSum(List<double> numbers) {
  double sum = 0;
  double c = 0;
  for (double n in numbers) {
    double y = n - c;
    double t = sum + y;
    c = (t - sum) - y;
    sum = t;
  }
  return sum;
}

List<double> generateNumbers() {
  List<double> numbers = [];
  Random ran = new Random();
  numbers.add(ran.nextDouble());
  return numbers;
}

