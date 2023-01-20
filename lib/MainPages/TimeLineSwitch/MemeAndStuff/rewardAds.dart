
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardAds extends StatefulWidget {
  @override
  _RewardAdsState createState() => _RewardAdsState();
}

class _RewardAdsState extends State<RewardAds> {

  @override
  void initState() {
    createInterAds();
    super.initState();
  }

  // This is ad Area for Switch Shot Meme
  late InterstitialAd myInterAd1;
  bool isInterAdLoaded = false;
  int numberOfAttempts = 0;

  void createInterAds() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-5525086149175557/8057335255',
      request: AdRequest(),
      adLoadCallback:
      InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
        myInterAd1 = ad;
        numberOfAttempts = 0;
      }, onAdFailedToLoad: (LoadAdError error) {
        numberOfAttempts = numberOfAttempts + 1;
        myInterAd1.dispose();

        if (numberOfAttempts <= 2) {
          createInterAds();
        }
      }),
    );
  }

  static const AdRequest request = AdRequest(
    // keywords: ['', ''],
    // contentUrl: '',
    // nonPersonalizedAds: false
  );

  void showInterAds() {
    if (myInterAd1 == null) {
      print("...ad null");
      return;
    } else {
      myInterAd1.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (InterstitialAd ad) {
            print("On Adshown Full screen");
          }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad OnAdFailed $error');
        ad.dispose();
        createInterAds();
      });
      myInterAd1.show();
      myInterAd1.dispose();
    }

    myInterAd1.show();
    myInterAd1.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Testing Area",

        style: TextStyle(
          color: Colors.blue,
          fontFamily: 'cute',
          fontSize: 18
        ),),
elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(

                    height: MediaQuery.of(context).size.height/3,
                    child: Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Reward Task will be available Soon!",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "cute",
                                color: Colors.blue),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 15, right: 15),
                          child: Text(
                            "This feature will only available in PAKISTAN. Later, we will add it to more countries.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "cutes",
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),),

                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 8, right: 8),
                          child: Text(
                            "Reward Withdraw will be available through JazzCash.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: "cutes",
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold),
                          ),),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 8, right: 8),
                          child: Text(
                            "One of many reward task will be watching ads 2 times a day to earn 2 to 5 pkr.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: "cutes",
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold),
                          ),),



                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 8, right: 8),
                          child: Text(
                            "Stay Tuned!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "cutes",
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold),
                          ),),



                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){

                  Future.delayed(const Duration(seconds: 1), () {
                    showInterAds();

                    print("show ad");
                  });

                },

                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          "Click here to test it.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: "cutes",
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold),
                        ),
                      ),),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
