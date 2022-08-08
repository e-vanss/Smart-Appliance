import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  Dio dio = Dio();

  bool isON = false;
  bool relayOn = false;

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

  // Future deviceStatus() async {
  //   return await dio.get(
  //       'https://ny3.blynk.cloud/external/api/isHardwareConnected?token=mrSUJjz1RNXeYlRQla__0fVCSCmHrf0t');
  // }

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

  @override
  void initState() {
    super.initState();
    // deviceStatus().then((response) {
    //   if (response.statusCode == 200) {
    //     setState(() {
    //       isON = true;
    //     });
    //   }
    // });

    relayStatus().then((response) {
      if (response.data == 1) {
        setState(() {
          relayOn = true;
        });
      }
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

          // Center(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Row(
          //         children: [
          //           Text(
          //             isON ? "Online " : "Offline ",
          //             style: const TextStyle(),
          //           ),
          //           Icon(
          //             Icons.online_prediction,
          //             color: isON ? Colors.green : Colors.red,
          //           )
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 20,
          ),
          // Center(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //           'Date: ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
          //           style: const TextStyle())
          //     ],
          //   ),
          // ),
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
                      if (snapshot.hasData) {
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
                      if (snapshot.hasData) {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: ElevatedButton(
              onPressed: () async {
                await toggleDevice();
                await relayStatus();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                elevation: 0,
                side: BorderSide(
                  color: relayOn ? Colors.green : Colors.red,
                  width: 2,
                ),
                textStyle:
                    TextStyle(color: relayOn ? Colors.green : Colors.red),
                fixedSize: const Size(50, 70),
                minimumSize: const Size(70, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                relayOn ? 'Relay On' : 'Relay Off',
                style: TextStyle(
                  color: relayOn ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
