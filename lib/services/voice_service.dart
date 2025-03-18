import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:text_to_speech/provider/voice_provider.dart';
import 'dart:html' as html;

class TextToSpeechService {
  final String apiKey;

  // Constructor to accept the API key
  TextToSpeechService(this.apiKey);

  // Function to make the API call
  Future<String?> synthesizeSpeech({
    required String text,
    required VoiceProvider voiceProvider,
    // String languageCode = "en-US",
    required String languageCode,
    // String voiceName = "en-US-Standard-C",
    required String voiceName,
    String audioEncoding = "LINEAR16",
    double pitch = 0.0,
    required double speakingRate,
    List<String> effectsProfileId = const [
      "small-bluetooth-speaker-class-device"
    ],
  }) async {
    const String apiUrl =
        "https://texttospeech.googleapis.com/v1beta1/text:synthesize";

    final headers = {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": apiKey,
    };

    final body = {
      "input": {"text": text},
      "voice": {"languageCode": languageCode, "name": voiceName},
      "audioConfig": {
        "audioEncoding": audioEncoding,
        "pitch": pitch,
        "speakingRate": speakingRate,
        "effectsProfileId": effectsProfileId
      }
    };

    try {
      // Sending the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        await voiceProvider.audioGeneratedOrNot(true);

        // Return the audio content as Base64 string
        return jsonResponse["audioContent"];
      } else {
        // Handle errors
        print("Error: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (e) {
      // Handle network errors
      print("Exception: $e");
      return null;
    }
  }

  Future<void> downloadAudioFile(String? audioContent, String fileName) async {
    if (audioContent != null) {
      // Decode the Base64-encoded audio content into bytes
      final audioBytes = base64Decode(audioContent);

      // Convert the bytes into a Blob
      final blob = html.Blob([audioBytes]);

      // Create a URL for the Blob
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create an anchor element and set the download attribute
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = fileName;

      // Programmatically click the anchor to trigger the download
      anchor.click();

      // Revoke the object URL to free up memory
      html.Url.revokeObjectUrl(url);
    } else {
      print("Audio content is null, unable to download.");
    }
  }
}
