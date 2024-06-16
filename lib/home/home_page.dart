import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hnpna_0614/login/login.dart';
import '../Notice/notice.dart';
import '../choose_pictures/choose_pictures.dart';
import '../making_print_type/making_print_type.dart';
import '../previous_albums/previous_albums.dart';
import '../rebuild_phone_folders/rebuild_phone_folders.dart';
import '../request_print/request_print.dart';
import '../view_selected_pictures/view_selected_pictures.dart';
import '../chatting/chatting.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('핸드폰 앨범'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );
            },
            icon: const Icon(CupertinoIcons.person),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomePage(),
          RebuildPhoneFolders(),
          ChoosePictures(),
          ViewSelectedPictures(),
          MakingPrintType(),
          RequestPrint(),
//          PreviousAlbums(),
          Chatting(),
          Chatting(),
          Notice(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIconTheme: const IconThemeData(size: 20),
        selectedLabelStyle: const TextStyle(fontSize: 15),
        items: const [
          BottomNavigationBarItem(label: '홈', icon: Icon(CupertinoIcons.home)),
          BottomNavigationBarItem(
              label: '정리', icon: Icon(CupertinoIcons.briefcase)),
          BottomNavigationBarItem(
              label: '선택', icon: Icon(CupertinoIcons.photo)),
          BottomNavigationBarItem(label: '보기', icon: Icon(CupertinoIcons.eye)),
          BottomNavigationBarItem(label: '타입', icon: Icon(CupertinoIcons.book)),
          BottomNavigationBarItem(
              label: '요청', icon: Icon(CupertinoIcons.hand_thumbsup)),
          BottomNavigationBarItem(
              label: 'prev', icon: Icon(CupertinoIcons.photo_on_rectangle)),
          BottomNavigationBarItem(
              label: '채팅', icon: Icon(CupertinoIcons.chat_bubble_2)),
          BottomNavigationBarItem(
              label: '공지', icon: Icon(CupertinoIcons.speaker_2)),
        ],
      ),
    );
  }
}
