// lib/core/muscle_group_detector.dart
class MuscleGroupDetector {
  static const _map = <String, List<String>>{
    'Pecho': [
      'press plano', 'press inclinado', 'press declinado', 'press con mancuernas',
      'apertura', 'aperturas', 'pec deck', 'maquina pecho', 'cable pecho',
      'cruce de poleas', 'crossover', 'fondos pecho', 'press banca', 'press de banca',
    ],
    'Espalda': [
      'peso muerto rumano', 'peso muerto', 'jalon al pecho', 'jalon en polea',
      'jalon con agarre', 'jalon frontal', 'jalon invertido',
      'remo con barra', 'remo con mancuerna', 'remo en maquina', 'remo sentado',
      'remo cable', 'remo unilateral', 'dominadas', 'pull-up', 'pullup',
      'chin-up', 'chinup', 'pullover', 'hiperextensiones', 'face pull',
      'encogimientos', 'trapecio', 'jalon', 'remo',
    ],
    'Hombros': [
      'press militar', 'press arnold',
      'elevaciones laterales', 'elevacion lateral',
      'elevaciones frontales', 'elevacion frontal',
      'pajaros', 'pajaro', 'manguito rotador', 'rotaciones', 'deltoides', 'hombros',
    ],
    'Piernas': [
      'hip thrust', 'peso bulgaro', 'sentadilla bulgara',
      'extensiones de cuadriceps', 'extensiones cuadriceps',
      'femoral camilla', 'femorales camilla', 'femorales con swiss ball',
      'femorales swiss ball', 'curl femoral', 'prensa inclinada', 'prensa 45',
      'sentadillas', 'sentadilla', 'estocadas', 'zancadas', 'lunge', 'lunges',
      'prensa', 'femoral', 'isquiotibial', 'gemelos', 'soleo', 'pantorrillas',
      'abductores', 'aductores', 'gluteo', 'gluteos', 'cuadriceps',
    ],
    'Biceps': [
      'biceps barra', 'biceps con barra', 'biceps mancuerna', 'biceps con mancuerna',
      'biceps predicador', 'curl martillo', 'curl predicador', 'curl barra',
      'curl mancuerna', 'curl concentrado', 'biceps', 'curl',
    ],
    'Triceps': [
      'triceps polea', 'triceps cuerda', 'press cerrado', 'fondos triceps',
      'extension triceps', 'extensiones triceps', 'jaloneos triceps',
      'paralelas triceps', 'triceps', 'paralelas',
    ],
    'Abdomen': [
      'plancha abdominal', 'elevacion de piernas', 'elevacion de rodillas',
      'rueda abdominal', 'abdominales con polea', 'crunch con polea',
      'crunch', 'sit-up', 'sit up', 'oblicuos', 'vacio abdominal',
      'abdomen', 'abdominal',
    ],
    'Cardio': [
      'saltos con cuerda', 'caminata en cinta', 'bicicleta estatica',
      'caminata', 'correr', 'bicicleta', 'eliptica', 'saltos', 'cuerda',
      'burpees', 'sprints',
    ],
  };

  static String? detect(String exerciseName) {
    final n = _normalise(exerciseName);
    for (final entry in _map.entries) {
      for (final kw in entry.value) {
        if (n.contains(kw)) return entry.key;
      }
    }
    return null;
  }

  static String _normalise(String s) => s
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ü', 'u');
}
