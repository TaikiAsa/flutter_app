import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart' as fs;
import 'package:flutter/rendering.dart';

import '../header.dart';

class Shops extends StatefulWidget {
  @override
  _ShopsState createState() => new _ShopsState();
}

class _ShopsState extends State<Shops> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<fs.QuerySnapshot>(
            stream: firestore().collection('shops').onSnapshot,
            builder: (BuildContext context,
                AsyncSnapshot<fs.QuerySnapshot> snapshot) {
              if (!snapshot.hasError) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading...');
                  default:
                    return ListView(
                      children: snapshot.data.docs
                          .map((fs.DocumentSnapshot document) {
                        return Card(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: FlutterLogo(size: 72.0),
                                    title: Text(
                                        "【 " + document.get('shop_name') + " 】"),
                                    subtitle: Text('カテゴリ ： ' +
                                        document.get('category') +
                                        "\n説明 ： " +
                                        document.get('details')),
                                  ),
                                  ButtonBar(children: <Widget>[
                                    FlatButton(
                                      child: const Text('編集'),
                                      onPressed: () {
                                        print("編集ボタンを押しました");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              settings: const RouteSettings(
                                                  name: "/edit"),
                                              builder: (BuildContext context) =>
                                                  MyInputForm(document)),
                                        );
                                      },
                                    ),
                                  ])
                                ]));
                      }).toList(),
                    );
                }
              } else {
                return Text('Error: ${snapshot.error}');
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          print("新規作成ボタンを押しました");
          Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: "/new"),
                builder: (BuildContext context) => MyInputForm(null),
              ));
        },
      ),
      //bottomNavigationBar: (),
    );
  }
}

class MyInputForm extends StatefulWidget {
  // MyInputFormに引数を追加
  MyInputForm(this.document);
  final fs.DocumentSnapshot document;

  @override
  _MyInputFormState createState() => new _MyInputFormState();
}

class _FormData {
  String shop_name;
  String category;
  String details;
}

class _MyInputFormState extends State<MyInputForm> {
  // ほかのwidgetからアクセスしたいkey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _FormData _data = _FormData();

  @override
  Widget build(BuildContext context) {
    // firebaseに登録するコンストラクタ
    fs.DocumentReference _mainReference = firestore().collection('shops').doc();
    // 削除フラグ
    bool deleteFlg = false;
    // 編集データの作成
    if (widget.document != null) {
      // 引数で渡したデータがあるかどうか
      if (_data.shop_name == null && _data.category == null) {
        _data.shop_name = widget.document.get('shop_name');
        _data.category = widget.document.get('category');
        _data.details = widget.document.get('details');
      } else {
        _mainReference =
            firestore().collection('shops').doc(widget.document.id);
        // 削除フラグ
        deleteFlg = true;
      }
      // 削除フラグ
      //deleteFlg = true;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('新規店舗登録'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  print("保存ボタンを押しました");
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _mainReference.set({
                      'shop_name': _data.shop_name,
                      'category': _data.category,
                      'details': _data.details,
                    });
                    Navigator.pop(context);
                  }
                }),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                print("削除ボタンを押しました");
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.add_location),
                    hintText: '店舗名',
                    labelText: 'ShopName',
                  ),
                  onSaved: (String value) {
                    _data.shop_name = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return '店舗名は必須入力項目です';
                    }
                  },
                  initialValue: _data.shop_name,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.attach_money),
                    hintText: 'カテゴリ',
                    labelText: 'category',
                  ),
                  onSaved: (String value) {
                    _data.category = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'カテゴリは必須入力項目です';
                    }
                  },
                  initialValue: _data.shop_name,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.add_location),
                    hintText: '説明',
                    labelText: 'details',
                  ),
                  onSaved: (String value) {
                    _data.details = value;
                  },
                )
              ],
            ),
          ),
        ));
  }
}