import 'package:educationdashboard/providers/simple_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/ui.dart';

enum reference { region, classes, subject, group }

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Ui.color,
        width: 250,
        child: ListView(
          children: [
            DrawerHeader(
                child: Center(
                    child: Text(
              "Меню",
              style: TextStyle(
                  fontSize: 20, fontFamily: Ui.font, color: Colors.white),
            ))),
            Divider(
              color: Colors.white,
            ),
            ListTile(
                title: PopupMenuButton<reference>(
                    offset: const Offset(237, -20),
                    elevation: 0,
                    color: Ui.color,
                    child: Text(
                      "Студенты",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: Ui.font,
                          color: Colors.white),
                    ),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<reference>>[
                          PopupMenuItem(
                              textStyle: TextStyle(fontSize: 20),
                              onTap: () {
                                context
                                    .read<SimpleProvider>()
                                    .changeindexpage(1);
                              },
                              value: reference.region,
                              child: Column(
                                children: [
                                  Container(
                                    child: Text("Группы",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: Ui.font,
                                            color: Colors.white)),
                                    width: 200,
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: Colors.white,
                                  )
                                ],
                              )),
                          PopupMenuItem(
                              textStyle: TextStyle(fontSize: 20),
                              onTap: () {
                                context
                                    .read<SimpleProvider>()
                                    .changeindexpage(2);
                              },
                              value: reference.region,
                              child: Column(
                                children: [
                                  Text("Студенты",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: Ui.font,
                                          color: Colors.white)),
                                  Divider(
                                    color: Colors.white,
                                  )
                                ],
                              )),
                        ])),
            Divider(
              color: Colors.white,
            ),
            ListTile(
                title: PopupMenuButton<reference>(
                    offset: const Offset(237, -20),
                    elevation: 0,
                    color: Ui.color,
                    child: Text(
                      "Оброзование",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: Ui.font,
                          color: Colors.white),
                    ),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<reference>>[
                          PopupMenuItem(
                              textStyle: TextStyle(fontSize: 20),
                              onTap: () {
                                context
                                    .read<SimpleProvider>()
                                    .changeindexpage(3);
                              },
                              value: reference.region,
                              child: Column(
                                children: [
                                  Text("Предметы и темы",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: Ui.font,
                                          color: Colors.white)),
                                  Divider(
                                    color: Colors.white,
                                  )
                                ],
                              )),
                          PopupMenuItem(
                              textStyle: TextStyle(fontSize: 20),
                              onTap: () {
                                context
                                    .read<SimpleProvider>()
                                    .changeindexpage(4);
                              },
                              value: reference.region,
                              child: Column(
                                children: [
                                  Text("Задание по теме (Тест)",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: Ui.font,
                                          color: Colors.white)),
                                  Divider(
                                    color: Colors.white,
                                  )
                                ],
                              )),
                        ])),
          ],
        ));
  }
}
