import 'package:flutter/cupertino.dart';

class VoiceProvider extends ChangeNotifier {
  String _generatedCharacters = '';
  String get generatedCharacters => _generatedCharacters;

  String _generatedAudioLog = '';
  String get generatedAudioLog => _generatedAudioLog;

  bool _generatingAudio = false;
  bool get genratingAudio => _generatingAudio;

  bool _audioGenerated = false;
  bool get audioGenerated => _audioGenerated;

  bool _voicePlaying = false;
  bool get voicePlaying => _voicePlaying;

  String _selectedLanguage = "English";
  String get selectedLanguage => _selectedLanguage;

  double _currentSpeed = 0.9;
  double get currentSpeed => _currentSpeed;

  final List<String> languages = [
    'English',
    'Malayalam',
    'Hindi',
    'Arabic',
    'German',
  ];

  // final List<String> models = [
  //   'English',
  //   'Malayalam',
  //   'Hindi',
  //   'Arabic',
  //   'German',
  //   'Urdu'
  // ];

  List<String> englishModels = ["en-US-Neural2-F", "en-US-Neural2-J"];
  List<String> malayalamModels = ["ml-IN-Standard-A", "ml-IN-Standard-B"];
  List<String> hindiModels = ["hi-IN-Wavenet-D", "hi-IN-Wavenet-C"];
  List<String> arabicModels = ["ar-XA-Wavenet-D", "ar-XA-Wavenet-C"];
  List<String> germanModels = ["de-DE-Wavenet-G", "de-DE-Wavenet-H"];

  List _modelList = ["en-US-Neural2-F", "en-US-Neural2-J"];
  List get modelList => _modelList;

  String _selectedModel = "en-US-Neural2-F";
  String get selectedModel => _selectedModel;

  setVoiceSpeed(double value) {
    _currentSpeed = value;
    notifyListeners();
  }

  addText(String text) {
    _generatedCharacters = text;
    notifyListeners();
  }

  saveGeneratedAudio(String audio) {
    _generatedAudioLog = audio;
    notifyListeners();
  }

  audioGenerating(bool value) {
    _generatingAudio = value;
    notifyListeners();
  }

  audioGeneratedOrNot(bool value) {
    _audioGenerated = value;
    notifyListeners();
  }

  playerStatus(bool status) {
    _voicePlaying = status;
    notifyListeners();
  }

  chooseLanguage(String value) {
    _selectedLanguage = value;
    notifyListeners();
  }

  chooseModel(String value) {
    _selectedModel = value;
    notifyListeners();
  }

  chooseModelList(List list) {
    _modelList = list;
    notifyListeners();
  }

  TextEditingController emailIdController = TextEditingController();
  TextEditingController passwrodController = TextEditingController();

  bool _authChecking = false;
  bool get authChecking => _authChecking;

  setAuthStatus(bool value) {
    _authChecking = value;
    notifyListeners();
  }
}
