import 'dart:collection';

void main() {
  print(misraGriesMajor([9,3,9,4,9,6,9,9,7]));
  //print(misraGries([5,3,5,4,5,6,9,9,7], 2));
}

///Implements the misra-gries algorithm for the majority-element.
double? misraGriesMajor(List<double> nbrs) {
  double? c;
  int v = 1;

  //finding candidate
  for (int i = 0; i < nbrs.length; i++) {
    if (nbrs[i] == c) {
      v++;
    }
    else if (c == null) {
      c = nbrs[i];
      v = 1;
    }
    else {
      v--;
      if (v == 0) {
        c = null;
      }
    }
    print('xi: ' + nbrs[i].toString() + ' | c: ' + c.toString() + ' | v: ' + v.toString());
  }

  //checking candidate
  v = 0;
  for (int i = 0; i < nbrs.length; i++) {
    if (c == nbrs[i]) {
      v++;
    }
  }

  return v > nbrs.length / 2 ? c : null;
}

///Implements the extended misra-gries algorithm.
Map<double, int> misraGries(List<double> nbrs, int k) {
  HashMap<double, int> d = HashMap();

  //determine candidates
  for (int i = 0; i < nbrs.length; i++) {
    if (d.containsKey(nbrs[i])) {
      d[nbrs[i]] = d[nbrs[i]]! + 1;
    }
    else if (d.length < k - 1) {
      d[nbrs[i]] = 1;
    }
    else {
      d.keys.forEach((key) {
        d[key] = d[key]! - 1;
        if (d[key] == 0) {
          d.remove(key);
        }
      });
    }
    print('----');
    print('xi: ' + nbrs[i].toString() + ' | ' + d.toString());
  }
   
  //checking candidates
  for (double key in d.keys) {
    d[key] = 0;
  }
  for (int i = 0; i < nbrs.length; i++) {
    d[nbrs[i]] = d[nbrs[i]]! + 1;
  }
  return d;
}

