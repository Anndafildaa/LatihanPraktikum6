import 'dart:convert';

void main() {
  // Transkrip dalam format JSON
  String jsonTranscript = '''
    {
      "nama": "Filda Dwi Meirina",
      "nim": "22082010025",
      "matkul": [
        {
          "nama": "Matematika",
          "sks": 4,
          "nilai": "A"
        },
        {
          "nama": "Bahasa Inggris",
          "sks": 3,
          "nilai": "B+"
        },
        {
          "nama": "Fisika",
          "sks": 4,
          "nilai": "A-"
        },
        {
          "nama": "Kimia",
          "sks": 3,
          "nilai": "B"
        },
        {
          "nama": "Biologi",
          "sks": 3,
          "nilai": "A"
        },
        {
          "nama": "Pengantar Komputer",
          "sks": 3,
          "nilai": "A"
        },
        {
          "nama": "Pendidikan Jasmani",
          "sks": 3,
          "nilai": "B+"
        }
      ]
    }
  ''';

  // Mengonversi JSON ke map
  Map<String, dynamic> transcript = jsonDecode(jsonTranscript);

  // Fungsi untuk menghitung IPK
  double calculateIPK(Map<String, dynamic> transcript) {
    Map<String, double> gradePoints = {
      "A": 4.0,
      "A-": 3.7,
      "B+": 3.3,
      "B": 3.0,
      "B-": 2.7,
      "C+": 2.3,
      "C": 2.0,
      "C-": 1.7,
      "D+": 1.3,
      "D": 1.0,
      "E": 0.0
    };
    double totalPoints = 0.0;
    int totalSks = 0;

    // Menghitung total poin dan total SKS
    for (var course in transcript["matkul"]) {
      int sks = course["sks"];
      String grade = course["nilai"];
      double point = gradePoints[grade] ?? 0.0;
      totalPoints += point * sks;
      totalSks += sks;
    }

    // Menghitung IPK
    return totalPoints / totalSks;
  }

  // Menghitung IPK
  double ipk = calculateIPK(transcript);
  int totalSks =
      transcript['matkul'].fold(0, (sum, course) => sum + course['sks']);

  // Menampilkan output
  print('Nama: ${transcript['nama']}');
  print('NIM: ${transcript['nim']}');
  print('Jumlah SKS: $totalSks');
  print('IPK: ${ipk.toStringAsFixed(2)}');
}
