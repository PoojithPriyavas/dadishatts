import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_to_speech/core/colors.dart';
import 'package:text_to_speech/core/constants.dart';
import 'package:text_to_speech/core/style.dart';
import 'package:text_to_speech/main.dart';
import 'package:text_to_speech/provider/voice_provider.dart';
import 'package:text_to_speech/services/auth_service.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    final voiceProvider = Provider.of<VoiceProvider>(context);

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: blackColor,
            body: Center(
              child: CircularProgressIndicator(
                color: whiteColor,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        } else {
          if (snapshot.data == null) {
            return Scaffold(
              backgroundColor: blackColor,
              body: SizedBox(
                width: deviceWidth,
                height: deviceHeight,
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
                    SizedBox(
                      height: deviceHeight,
                      width: deviceWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 150,
                              child: Image.asset("assets/logo.png"),
                            ),
                            Container(
                              width: 500,
                              height: 400,
                              decoration: BoxDecoration(
                                color: const Color(0xFF171717),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white12,
                                  width: 0.5,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0xFF171717),
                                      offset: Offset(0, 0),
                                      blurRadius: 2,
                                      spreadRadius: 2)
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Sign in to continue",
                                          style: t18SemiBoldBlack.copyWith(
                                              color: whiteColor),
                                        )
                                      ],
                                    ),
                                    kHeight50,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Email Id",
                                          style: t16SemiBoldBlack.copyWith(
                                              color: whiteColor),
                                        ),
                                        kHeight10,
                                        CupertinoTextField(
                                          controller:
                                              voiceProvider.emailIdController,
                                          style: t16SemiBoldBlack.copyWith(
                                              color: whiteColor),
                                          placeholderStyle:
                                              t16SemiBoldBlack.copyWith(
                                                  color: whiteColor
                                                      .withOpacity(0.4)),
                                          placeholder: "Registered Email id",
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                  color: Colors.white24,
                                                  width: 0.5)),
                                        )
                                      ],
                                    ),
                                    kHeight20,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Password",
                                          style: t16SemiBoldBlack.copyWith(
                                              color: whiteColor),
                                        ),
                                        kHeight10,
                                        CupertinoTextField(
                                          controller:
                                              voiceProvider.passwrodController,
                                          obscureText: true,
                                          style: t16SemiBoldBlack.copyWith(
                                              color: whiteColor),
                                          placeholderStyle:
                                              t16SemiBoldBlack.copyWith(
                                                  color: whiteColor
                                                      .withOpacity(0.4)),
                                          placeholder: "Password",
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                  color: Colors.white24,
                                                  width: 0.5)),
                                        )
                                      ],
                                    ),
                                    kHeight30,
                                    SizedBox(
                                      width: 480,
                                      height: 45,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                            shape: WidgetStatePropertyAll(
                                                ContinuousRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10))),
                                            backgroundColor:
                                                const WidgetStatePropertyAll(
                                              Colors.blueAccent,
                                            ),
                                            foregroundColor:
                                                const WidgetStatePropertyAll(
                                              whiteColor,
                                            ),
                                          ),
                                          onPressed: () async {
                                            try {
                                              final email = voiceProvider
                                                  .emailIdController.text;
                                              final password = voiceProvider
                                                  .passwrodController.text;

                                              if (email.isNotEmpty &&
                                                  password.isNotEmpty) {
                                                await voiceProvider
                                                    .setAuthStatus(true);
                                                await authService
                                                    .signInWithEmail(
                                                        email,
                                                        password,
                                                        context,
                                                        voiceProvider);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: whiteColor,
                                                    content: Text(
                                                      "All fields are required",
                                                      style: t14RegularBlack,
                                                    ),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              log(e.toString());
                                            }
                                          },
                                          child: voiceProvider.authChecking ==
                                                  false
                                              ? const Text("Login")
                                              : const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            kHeight30,
                            Text(
                              "@2025 Dadisha TTS",
                              style:
                                  t14RegularBlack.copyWith(color: whiteColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const MyHomePage();
          }
        }
      },
    );
  }
}
