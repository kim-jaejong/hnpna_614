import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../login/login.dart';
import '../Notice/notice.dart';
import '../choose_pictures/choose_pictures.dart';
import '../making_print_type/making_print_type.dart';
//import '../previous_albums/previous_albums.dart';
import '../rebuild_folders/rebuild_folders.dart';
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
//          HomePage(),
          RebuildFolders(),
// 주제에 따라 사진 선택하기
// 날짜별 (년 월 기간 )
          // 위치별 (지역별)
// 사람. 꽃, 해변, 산, 동물, 건물, 음식, 물건, 풍경, 기타
//          ChoosePictures(),
          ChoosePictures(),
          ChoosePictures(),
          ViewSelectedPictures(),
          MakingPrintType(),
          RequestPrint(),
//     PreviousAlbums(),
//     다른 사람 작품 보기
          //    다른 사람에게  보여주기(무료)
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
