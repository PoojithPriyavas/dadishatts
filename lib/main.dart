import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_to_speech/core/colors.dart';
import 'package:text_to_speech/core/constants.dart';
import 'package:text_to_speech/firebase_options.dart';
import 'package:text_to_speech/presentation/auth/wrapper.dart';
import 'package:text_to_speech/presentation/screen_tts.dart';
import 'package:text_to_speech/core/style.dart';
import 'package:text_to_speech/provider/voice_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => VoiceProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dadisha TTS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: blackColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Wrapper(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: blackColor,
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        decoration: const BoxDecoration(color: blackColor),
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
              child: SizedBox(
                  height: deviceHeight - 90,
                  width: deviceWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DelayedDisplay(
                        delay: const Duration(seconds: 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: Text(
                            "Text to Speech. Redefined by AI.",
                            textAlign: TextAlign.center,
                            style: t20SemiBoldBlack.copyWith(
                              color: whiteColor,
                              fontSize: 100,
                            ),
                          ),
                        ),
                      ),
                      kHeight50,
                      DelayedDisplay(
                        fadeIn: true,
                        slidingBeginOffset: const Offset(0, 0),
                        delay: const Duration(seconds: 2),
                        child: Text(
                          "Dadisha TTS helps you create high-quality, multilingual voice experiences effortlessly.",
                          style: t20SemiBoldBlack.copyWith(color: Colors.white),
                        ),
                      ),
                      kHeight50,
                      DelayedDisplay(
                          fadeIn: true,
                          slidingBeginOffset: const Offset(0, 0),
                          delay: const Duration(seconds: 2),
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                        ContinuousRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                    surfaceTintColor:
                                        const WidgetStatePropertyAll(
                                            Color.fromARGB(255, 0, 85, 154)),
                                    backgroundColor:
                                        const WidgetStatePropertyAll(
                                            Color.fromARGB(255, 11, 100, 255))),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => ScreenTts(),
                                      transitionDuration:
                                          const Duration(seconds: 1),
                                      transitionsBuilder: (_, a, __, c) =>
                                          FadeTransition(opacity: a, child: c),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Create UnImaginable",
                                  style: t16SemiBoldBlack.copyWith(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold),
                                )),
                          )),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
