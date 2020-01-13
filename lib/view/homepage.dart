import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:http/http.dart' as http;
import 'package:instatag/model/hashgroup.dart';

import 'constants.dart';

class HomePage extends StatelessWidget {
  List<HashGroup> hashGroup = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainThemeColor,
        title: Text('InstaTags'),
      ),
      body: Container(
          color: Colors.grey[100],
          child: new FutureBuilder(
              future: loadAsset(),
              builder: (context, snapshot) {
                return gotDataAction(snapshot, context);
              })),
    );
  }

  Widget gotDataAction(AsyncSnapshot snapshot, BuildContext context) {
    //debugPrint("populating data");
    hashGroup.clear();
    if (snapshot.hasData) {
      //debugPrint("Data - " + snapshot.data.toString());
      var data = json.decode(snapshot.data);
      var rest = data["categories"];
      for (var model in rest) {
        hashGroup.add(new HashGroup.fromJson(model));
      }
      return Center(
          child: Container(
        child: buildCategoriesGridView(context, hashGroup),
      ));
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  GridView buildCategoriesGridView(
      BuildContext context, List<HashGroup> hashgroup) {
    return GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 3,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(hashgroup.length, (index) {
          return getCategoryItem(context, hashgroup[index]);
        }));
  }

  Future<String> loadAsset() async {
    //debugPrint("Loading Assests");
    var data;
    final response =
        await http.get('https://instatag-896dd.firebaseapp.com/instatags.html');
    if (response.statusCode == 200) {
      data = response.body;
      //debugPrint("Fetched data" +data.toString());
    } else {
      debugPrint("Fetching data failed");
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
    //return await rootBundle.loadString('assets/tags.json');
    return data.toString();
  }
}

class _TagDetailsPage extends State<TagDetailsPage> {
  HashGroup hashGroup;
  BannerAd _bannerAd;
  bool _adShown = false;
  static final MobileAdTargetingInfo targetingInfo =
      new MobileAdTargetingInfo(testDevices: [
    "DEVICE_ID_EMULATOR",
    "cecc0612aa7e985d",
    "86b4fc0a9cfda365",
    "091960031BA6E7BEA19460085A8D905B"
  ]);

  BannerAd createBannerAd() {
    return new BannerAd(
      size: AdSize.largeBanner,
      adUnitId: getBannerAdUnitId(),
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          debugPrint("Ad----loaded");
          _adShown = true;
          setState(() {});
        } else if (event == MobileAdEvent.failedToLoad) {
          debugPrint("Ad----failed");
          _adShown = false;
          setState(() {});
        }
      },
    );
  }

  @override
  void initState() {
    _adShown = false;
    _bannerAd = createBannerAd()
      ..load()
      ..show();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  _TagDetailsPage(HashGroup hashgroup) {
    hashGroup = hashgroup;
    print("Construct _TagDetailsPage Received - " + hashGroup.name);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fakeBottomButtons = new List<Widget>();
    fakeBottomButtons.add(
      new Container(
        height: _bannerAd.size.height.ceilToDouble(),
      ),
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainThemeColor,
          title: Text(hashGroup.name),
          actions: <Widget>[
            // action button
            IconButton(
              icon: new Image.asset('assets/instagram.png'),
              tooltip: 'Open Instagram',
              onPressed: () {
                launchInsta();
              },
            ),
          ],
        ),
        body: Builder(
          builder: (context) => Container(
            color: Colors.grey[300],
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: buildTagsGridView(context, hashGroup),
                ),
              ],
            ),
          ),
        ),
        persistentFooterButtons: _adShown ? fakeBottomButtons : null);
  }

  buildTagsGridView(BuildContext context, HashGroup hashgroup) {
    return GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        childAspectRatio: 3 / 4,
        crossAxisCount: 3,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(hashgroup.tagTitle.length, (index) {
          return getTagsCategoryItem(context, hashgroup.tagTitle[index]);
        }));
  }

  void launchInsta() {
    AppAvailability.launchApp("com.instagram.android");
  }

  getBannerAdUnitId() {
    return "ca-app-pub-9079381335168661/3516819478";
  }
}

class TagDetailsPage extends StatefulWidget {
  HashGroup hashGroup;

  TagDetailsPage(HashGroup hashgroup) {
    hashGroup = hashgroup;
    print("Construct _TagDetailsPage Received - " + hashGroup.name);
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TagDetailsPage(hashGroup);
  }
}

Card getCategoryItem(BuildContext context, HashGroup hashgroup) {
  return Card(
      color: Colors.white,
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            categoryItemPressed(context, hashgroup);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                flex: 8,
                child: Container(
                  child: new CachedNetworkImage(
                    fit: BoxFit.fill,
                    height: 100,
                    placeholder: (context, url) => new Image.asset(
                        "assets/place.png",
                        fit: BoxFit.fitWidth),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    imageUrl: hashgroup.imageurl,
                  ),
                ),
              ),
              new Expanded(
                  flex: 2,
                  child: Container(
                    height: 25,
                    child: Center(
                        child: Text(
                      hashgroup.name,
                      style: styleCardTextCat,
                    )),
                  )),
            ],
          )));
}

Card getTagsCategoryItem(BuildContext context, TagTitle tagsTitle) {
  debugPrint("Creating tags sub item");
  return Card(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Expanded(
            flex: 3,
            child: Container(
                color: Color.fromRGBO(214, 41, 118, 1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      child: Text(
                        tagsTitle.name,
                        style: styleCardText,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ))),
        new Expanded(
          flex: 10,
          child: new SingleChildScrollView(
              child: Text(getAllTags(tagsTitle.tags),
                  style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87))),
        ),
        new Expanded(
            flex: 3,
            child: Container(
              height: 25,
              child: Center(
                child: ButtonTheme(
                  minWidth: 200.0,
                  height: 100.0,
                  child: RaisedButton(
                    color: Color.fromRGBO(214, 41, 118, 1.0),
                    textColor: Colors.white70,
                    onPressed: () {
                      Clipboard.setData(
                          new ClipboardData(text: getAllTags(tagsTitle.tags)));

                      final snackBar = new SnackBar(
                          content: new Text("Tags copied"),
                          backgroundColor: Colors.red);

                      // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                    child: Text("Copy"),
                  ),
                ),
              ),
            )),
      ],
    ),
  );
}

String getAllTags(List<String> tags) {
  String finalTag = "";
  for (String val in tags) {
    finalTag = finalTag + " " + val;
  }
  return finalTag;
}

categoryItemPressed(BuildContext context, HashGroup hashgroup) {
  Navigator.push(context,
      CupertinoPageRoute(builder: (context) => TagDetailsPage(hashgroup)));
}
