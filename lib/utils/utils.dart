extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

num lbsToKg(num lbs){
  return (lbs * 0.45359237);
}