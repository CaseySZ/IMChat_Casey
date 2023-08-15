import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import '../../utils/screen.dart';

class MainBottomBarView extends StatefulWidget {
  final List<String> titleArr;
  final PageController? pageController;

  const MainBottomBarView(
      {super.key, required this.titleArr, this.pageController});

  @override
  State<StatefulWidget> createState() {
    return _MainBottomBarViewState();
  }
}

class _MainBottomBarViewState extends State<MainBottomBarView> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight + screen.paddingBottom,
      padding: EdgeInsets.only(bottom: screen.paddingBottom),
      child: Row(
        children: [
          _buildItem(0, currentIndex == 0),
          _buildItem(1, currentIndex == 1),
          _buildItem(2, currentIndex == 2),
          _buildItem(3, currentIndex == 3),
       //   _buildItem(4, currentIndex == 4),
        ],
      ),
    );
  }

  Widget _buildItem(int index, bool isSelected) {
    return InkWell(
        onTap: () {
          if (index != currentIndex) {
            widget.pageController?.jumpToPage(index);
            currentIndex = index;
            setState(() {});
          }

        },
        child: SizedBox(
          width: screen.screenWidth / widget.titleArr.length,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   "assets/assets/root_menu_$index${(isSelected ? 1 : 0)}.png",
              //   width: 20,
              //   height: 20,
              // ),
              Container(
                width: 20,
                height: 20,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
              const SizedBox(height: 3),
              Text(
                widget.titleArr[index],
                style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                        isSelected ? FontWeight.w500 : FontWeight.normal,
                    color: isSelected ? Colors.blue : const Color(0xff434343)),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
