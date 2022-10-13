// ignore_for_file: avoid_print

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:evans/services/local_notification_service.dart';

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  Dio dio = Dio();
  late final LocalNotificationService service;

  bool isON = false;
  bool relayOn = false;

  late Timer timer;

  final CircularSliderAppearance appearance01 =
      const CircularSliderAppearance();

  Stream currentStream() async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      var response = await dio.get(
          'https://ny3.blynk.cloud/external/api/get?token=mrSUJjz1RNXeYlRQla__0fVCSCmHrf0t&v1');
      yield response;
    }
  }

  Stream powerStream() async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      var response = await dio.get(
          'https://ny3.blynk.cloud/external/api/get?token=mrSUJjz1RNXeYlRQla__0fVCSCmHrf0t&v0');
      yield response;
    }
  }

  Stream relayStream() async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      var response = await dio.get(
          'https://ny3.blynk.cloud/external/api/get?token=mrSUJjz1RNXeYlRQla__0fVCSCmHrf0t&v5');
      yield response;
    }
  }

  Future toggleDevice() async {
    await dio.get(
        'https://ny3.blynk.cloud/external/api/update?token=mrSUJjz1RNXeYlRQla__0fVCSCmHrf0t&v5=${relayOn ? 0 : 1}');
  }

  Stream deviceStatus() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      var response = await dio.get(
          'https://ny3.blynk.cloud/external/api/isHardwareConnected?token=mrSUJjz1RNXeYlRQla__0fVCSCmHrf0t');
      yield response;
    }
  }

  Future relayStatus() async {
    var res = await dio.get(
        'https://ny3.blynk.cloud/external/api/get?token=mrSUJjz1RNXeYlRQla__0fVCSCmHrf0t&v5');

    print("relay: ${res.data}");

    if (res.data == 0) {
      setState(() {
        relayOn = false;
      });
    } else {
      setState(() {
        relayOn = true;
      });
    }
  }

  bool showNotif = false;

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();

    super.initState();

    relayStatus().then((response) {
      if (response?.data == 1) {
        setState(() {
          relayOn = true;
        });
      }
    });

    _initializeTimer();
  }

  void _initializeTimer() {
    timer = Timer.periodic(const Duration(seconds: 20), (__) async {
      if (showNotif) {
        await service.showScheduledNotification(
          id: 0,
          title: 'Smart Appliance Control',
          body: 'Power is being used at home now!',
          seconds: 5,
        );
      }

      // print("timer working");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(
            height: 100,
          ),
          StreamBuilder(
            stream: deviceStatus(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                isON = snapshot.data!.data;

                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            isON ? "Online " : "Offline ",
                            style: const TextStyle(),
                          ),
                          Icon(
                            Icons.online_prediction,
                            color: isON ? Colors.green : Colors.red,
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }

              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: const [
                        Text(
                          "Offline ",
                          style: TextStyle(),
                        ),
                        Icon(
                          Icons.online_prediction,
                          color: Colors.red,
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text('Current'),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                    stream: currentStream(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData && isON) {
                        return SleekCircularSlider(
                          onChangeStart: (double value) {},
                          onChangeEnd: (double value) {},
                          innerWidget: (double value) {
                            return Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    value.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text("A"),
                                ],
                              ),
                            );
                          },
                          appearance: appearance01,
                          min: 0,
                          max: 40,
                          initialValue: snapshot.data.data.toDouble(),
                        );
                      }

                      return SleekCircularSlider(
                        onChangeStart: (double value) {},
                        onChangeEnd: (double value) {},
                        innerWidget: (double value) {
                          return Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text("A"),
                              ],
                            ),
                          );
                        },
                        appearance: appearance01,
                        min: 0,
                        max: 40,
                        initialValue: 0,
                      );
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Power'),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                    stream: powerStream(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      // print(snapshot.data.data);

                      if (snapshot.hasData && isON) {
                        if (snapshot.data.data.toDouble() > 50) {
                          showNotif = true;
                        } else {
                          showNotif = false;
                        }

                        // print(snapshot.data.data);
                        return SleekCircularSlider(
                          onChangeStart: (double value) {},
                          onChangeEnd: (double value) {},
                          innerWidget: (double value) {
                            return Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${value.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text("W"),
                                ],
                              ),
                            );
                          },
                          appearance: appearance01,
                          min: 0,
                          max: 5000,
                          initialValue: snapshot.data.data.toDouble(),
                        );
                      }

                      return SleekCircularSlider(
                        onChangeStart: (double value) {},
                        onChangeEnd: (double value) {},
                        innerWidget: (double value) {
                          return Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text("W"),
                              ],
                            ),
                          );
                        },
                        appearance: appearance01,
                        min: 0,
                        max: 5000,
                        initialValue: 0,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
              onPressed: () async {
                await toggleDevice();
                await relayStatus();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                side: BorderSide(
                  color: relayOn ? Colors.green : Colors.red,
                  width: 2,
                ),
                textStyle: TextStyle(
                    color: relayOn
                        ? Colors.green
                        : const Color.fromARGB(255, 107, 102, 102)),
                fixedSize: const Size(50, 70),
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                relayOn ? 'Fridge On' : 'Fridge Off',
                style: TextStyle(
                  color: relayOn ? Colors.green : Colors.red,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await toggleDevice();
                await relayStatus();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                side: BorderSide(
                  color: relayOn ? Colors.green : Colors.red,
                  width: 2,
                ),
                textStyle: TextStyle(
                    color: relayOn
                        ? Colors.green
                        : const Color.fromARGB(255, 107, 102, 102)),
                fixedSize: const Size(50, 70),
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                relayOn ? 'TV On' : 'TV Off',
                style: TextStyle(
                  color: relayOn ? Colors.green : Colors.red,
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
