import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:text_to_speech/core/colors.dart';
import 'package:text_to_speech/core/constants.dart';
import 'package:text_to_speech/core/style.dart';
import 'package:text_to_speech/provider/voice_provider.dart';
import 'package:text_to_speech/services/auth_service.dart';
import 'package:text_to_speech/services/voice_service.dart';

class ScreenTts extends StatefulWidget {
  const ScreenTts({super.key});

  @override
  State<ScreenTts> createState() => _ScreenTtsState();
}

class _ScreenTtsState extends State<ScreenTts> {
  final TextEditingController _controller = TextEditingController();
  int _characterCount = 0;
  late AudioPlayer audioPlayer;
  late VoiceProvider _voiceProvider;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _voiceProvider = VoiceProvider();
    setDefault();
    // voiceOver("this is the text");
    _controller.addListener(() {
      setState(() {
        _characterCount = _controller.text.length;
      });
    });
  }

  Future<void> setDefault() async {
    // print("Setting default language and model...");
    await _voiceProvider.chooseLanguage("English");

    await _voiceProvider.chooseModelList(_voiceProvider.englishModels);
    // print("Language set to English.");

    // print("model list is ${_voiceProvider.modelList}");
    await _voiceProvider.chooseModel("en-US-Neural2-F");
    // print("Model set to en-US-Neural2-F.");

    setState(() {});
  }

  Future<void> voiceOver(
      String? audioContent, VoiceProvider voiceProvider) async {
    if (audioContent != null) {
      voiceProvider.playerStatus(true);

      // Decode the Base64-encoded audio content into bytes
      final audioBytes = base64Decode(audioContent);

      // Initialize the audio player

      final completer = Completer<void>();
      audioPlayer.onPlayerComplete.listen(
        (event) {
          completer.complete();
        },
      );

      await audioPlayer.play(BytesSource(audioBytes));

      await completer.future;
      voiceProvider.playerStatus(false);
    } else {
      print("Failed to generate speech.");
    }
  }

  void stopVoice(VoiceProvider voiceProvider) {
    voiceProvider.playerStatus(false);
    audioPlayer.stop();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final TextToSpeechService textToSpeechService =
        TextToSpeechService("AIzaSyCEvbRdINamKVEm2lllEGG-xn-w1rIiIQo");

    final AuthService authService = AuthService();

    return Scaffold(
      backgroundColor: blackColor,
      body: Consumer<VoiceProvider>(builder: (context, voiceProvider, child) {
        return SizedBox(
          height: deviceHeight,
          width: deviceWidth,
          child: Stack(
            children: [
              Positioned(
                top: -((deviceWidth * 0.5)),
                left: 0,
                right: 0,
                child: Container(
                  width: deviceWidth + 400,
                  height: deviceWidth + 400,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      tileMode: TileMode.clamp,
                      colors: [
                        primaryColor,
                        Colors.black,
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: deviceHeight,
                width: deviceWidth,
                color: transparentColor,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: deviceWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "assets/logo.png",
                              height: 100,
                            ),
                            TextButton.icon(
                                onPressed: () async {
                                  await authService.signOut(context);
                                },
                                icon: const Icon(
                                  Icons.login_outlined,
                                  color: whiteColor,
                                ),
                                label: Text(
                                  "Sign Out",
                                  style: t14SemiBoldBlack.copyWith(
                                      color: whiteColor),
                                ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight - 100,
                      width: deviceWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: deviceWidth * 0.5,
                              height: deviceHeight - 140,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Language",
                                              style: t14SemiBoldBlack.copyWith(
                                                  color: whiteColor,
                                                  fontSize: 17),
                                            ),
                                            kHeight20,
                                            DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: voiceProvider
                                                    .selectedLanguage, // Add a variable to track selected language
                                                elevation: 0,
                                                dropdownColor: Colors.black,
                                                style: t16MediumBlack.copyWith(
                                                    color: whiteColor),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                items: voiceProvider.languages
                                                    .map((language) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                          value: language,
                                                          child: Text(
                                                            language,
                                                            style: t16MediumBlack
                                                                .copyWith(
                                                                    color:
                                                                        whiteColor),
                                                          ),
                                                        ))
                                                    .toList(),
                                                onChanged: (value) async {
                                                  await voiceProvider
                                                      .chooseLanguage(value!);

                                                  if (voiceProvider
                                                          .selectedLanguage ==
                                                      "English") {
                                                    await voiceProvider
                                                        .chooseModelList(
                                                            voiceProvider
                                                                .englishModels);

                                                    await voiceProvider
                                                        .chooseModel(
                                                            "en-US-Neural2-F");
                                                  } else if (voiceProvider
                                                          .selectedLanguage ==
                                                      "Malayalam") {
                                                    await voiceProvider
                                                        .chooseModelList(
                                                            voiceProvider
                                                                .malayalamModels);

                                                    await voiceProvider
                                                        .chooseModel(
                                                            "ml-IN-Standard-A");
                                                  } else if (voiceProvider
                                                          .selectedLanguage ==
                                                      "Hindi") {
                                                    await voiceProvider
                                                        .chooseModelList(
                                                            voiceProvider
                                                                .hindiModels);

                                                    await voiceProvider
                                                        .chooseModel(
                                                            "hi-IN-Wavenet-D");
                                                  } else if (voiceProvider
                                                          .selectedLanguage ==
                                                      "Arabic") {
                                                    await voiceProvider
                                                        .chooseModelList(
                                                            voiceProvider
                                                                .arabicModels);

                                                    await voiceProvider
                                                        .chooseModel(
                                                            "ar-XA-Wavenet-D");
                                                  } else if (voiceProvider
                                                          .selectedLanguage ==
                                                      "German") {
                                                    await voiceProvider
                                                        .chooseModelList(
                                                            voiceProvider
                                                                .germanModels);

                                                    await voiceProvider
                                                        .chooseModel(
                                                            "de-DE-Wavenet-G");
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        kWidth30,
                                        kWidth30,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Model",
                                              style: t14SemiBoldBlack.copyWith(
                                                  color: whiteColor,
                                                  fontSize: 17),
                                            ),
                                            kHeight20,
                                            DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: voiceProvider
                                                    .selectedModel, // Add a variable to track selected language
                                                elevation: 0,
                                                dropdownColor: Colors.black26,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                items: voiceProvider.modelList
                                                    .map((language) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                          value: language,
                                                          child: Text(
                                                            language,
                                                            style: t16MediumBlack
                                                                .copyWith(
                                                                    color:
                                                                        whiteColor),
                                                          ),
                                                        ))
                                                    .toList(),
                                                onChanged: (value) {
                                                  // Handle language selection
                                                  voiceProvider
                                                      .chooseModel(value!);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    kHeight10,
                                    SizedBox(
                                      width: deviceWidth * 0.5,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Speed",
                                            style: t14SemiBoldBlack.copyWith(
                                                color: whiteColor,
                                                fontSize: 17),
                                          ),
                                          Expanded(
                                            child: Slider(
                                              value: voiceProvider.currentSpeed,
                                              min: 0.6,
                                              max: 1.2,
                                              activeColor: Colors.blueAccent,
                                              label: voiceProvider.currentSpeed
                                                  .toStringAsFixed(2),
                                              onChanged: (value) {
                                                voiceProvider
                                                    .setVoiceSpeed(value);
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: 60,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white12),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              voiceProvider.currentSpeed
                                                  .toStringAsFixed(2),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    kHeight30,
                                    SizedBox(
                                      height: deviceHeight - 450,
                                      child: CupertinoTextField(
                                        maxLines: 30,
                                        controller: _controller,
                                        cursorColor: whiteColor,
                                        style: t14RegularBlack.copyWith(
                                            color: whiteColor, fontSize: 17),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.white12)),
                                      ),
                                    ),
                                    kHeight30,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Characters: $_characterCount',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  shape: WidgetStatePropertyAll(
                                                      ContinuousRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15))),
                                                  surfaceTintColor:
                                                      const WidgetStatePropertyAll(
                                                          Color.fromARGB(
                                                              255, 0, 85, 154)),
                                                  backgroundColor:
                                                      const WidgetStatePropertyAll(
                                                          Color.fromARGB(255,
                                                              11, 100, 255))),
                                              onPressed: () async {
                                                try {
                                                  await audioPlayer.stop();
                                                  await voiceProvider
                                                      .audioGenerating(true);
                                                  final String characters =
                                                      _controller.text;

                                                  final String code = voiceProvider
                                                              .selectedLanguage ==
                                                          "English"
                                                      ? 'en-US'
                                                      : voiceProvider
                                                                  .selectedLanguage ==
                                                              "Malayalam"
                                                          ? "ml-IN"
                                                          : voiceProvider
                                                                      .selectedLanguage ==
                                                                  "Arabic"
                                                              ? "ar-XA"
                                                              : voiceProvider
                                                                          .selectedLanguage ==
                                                                      "German"
                                                                  ? "de-DE"
                                                                  : "hi-IN";

                                                  if (voiceProvider
                                                          .audioGenerated ==
                                                      true) {
                                                    await voiceProvider
                                                        .audioGeneratedOrNot(
                                                            false);

                                                    if (characters.isNotEmpty) {
                                                      await voiceProvider
                                                          .addText(characters);
                                                      final audioContent =
                                                          await textToSpeechService
                                                              .synthesizeSpeech(
                                                                speakingRate: voiceProvider.currentSpeed,
                                                                  languageCode:
                                                                      code,
                                                                  voiceName:
                                                                      voiceProvider
                                                                          .selectedModel,
                                                                  text:
                                                                      characters,
                                                                  voiceProvider:
                                                                      voiceProvider);

                                                      await voiceProvider
                                                          .audioGenerating(
                                                              false);

                                                      if (audioContent != "") {
                                                        await voiceProvider
                                                            .saveGeneratedAudio(
                                                                audioContent!);
                                                      }
                                                    } else {
                                                      voiceProvider
                                                          .audioGenerating(
                                                              false);
                                                    }
                                                  } else {
                                                    if (characters.isNotEmpty) {
                                                      await voiceProvider
                                                          .addText(characters);
                                                      final audioContent =
                                                          await textToSpeechService
                                                              .synthesizeSpeech(speakingRate: voiceProvider.currentSpeed,
                                                        languageCode: code,
                                                        voiceName: voiceProvider
                                                            .selectedModel,
                                                        text: characters,
                                                        voiceProvider:
                                                            voiceProvider,
                                                      );

                                                      await voiceProvider
                                                          .audioGenerating(
                                                              false);

                                                      if (audioContent != "") {
                                                        await voiceProvider
                                                            .saveGeneratedAudio(
                                                                audioContent!);
                                                      }
                                                    } else {
                                                      voiceProvider
                                                          .audioGenerating(
                                                              false);
                                                    }
                                                  }
                                                } catch (e) {
                                                  if (kDebugMode) {
                                                    print(e);
                                                  }
                                                }
                                              },
                                              child: voiceProvider
                                                          .genratingAudio ==
                                                      true
                                                  ? Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: whiteColor,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        Text(
                                                          "Unleash the Voice!",
                                                          style: t16SemiBoldBlack
                                                              .copyWith(
                                                                  color:
                                                                      whiteColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        kWidth5,
                                                        const Icon(
                                                          Icons.flash_on_sharp,
                                                          color: whiteColor,
                                                        )
                                                      ],
                                                    )),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ).asGlass(
                              clipBorderRadius: BorderRadius.circular(20),
                            ),
                            Container(
                              width: (deviceWidth * 0.5) - 100,
                              height: deviceHeight - 140,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Generated Audios",
                                    style: t14SemiBoldBlack.copyWith(
                                      color: whiteColor,
                                      fontSize: 17,
                                    ),
                                  ),
                                  kHeight50,
                                  if (voiceProvider.audioGenerated == true)
                                    Container(
                                      height: 100,
                                      width: (deviceWidth * 0.5) - 150,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 0.2,
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                if (voiceProvider
                                                        .voicePlaying ==
                                                    true) {
                                                  stopVoice(
                                                    voiceProvider,
                                                  );
                                                } else {
                                                  voiceOver(
                                                    voiceProvider
                                                        .generatedAudioLog,
                                                    voiceProvider,
                                                  );
                                                }
                                              },
                                              child: voiceProvider
                                                          .voicePlaying ==
                                                      true
                                                  ? const Icon(
                                                      Icons.stop_outlined,
                                                      color: whiteColor,
                                                    )
                                                  : const Icon(
                                                      Icons.play_arrow_outlined,
                                                      color: whiteColor,
                                                    ),
                                            ),
                                            kWidth20,
                                            Expanded(
                                              child: Text(
                                                voiceProvider
                                                    .generatedCharacters,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: t14RegularBlack.copyWith(
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ),
                                            TextButton.icon(
                                              onPressed: () {
                                                textToSpeechService
                                                    .downloadAudioFile(
                                                        voiceProvider
                                                            .generatedAudioLog,
                                                        "audio.mp3");
                                              },
                                              icon: const Icon(
                                                Icons.download,
                                                color: Color.fromARGB(
                                                    255, 11, 100, 255),
                                              ),
                                              label: Text(
                                                "Download",
                                                style:
                                                    t16SemiBoldBlack.copyWith(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 54, 126, 252),
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ).asGlass(
                              clipBorderRadius: BorderRadius.circular(20),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
