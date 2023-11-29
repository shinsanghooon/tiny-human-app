import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';
import 'package:tiny_human_app/common/utils/data_utils.dart';
import 'package:tiny_human_app/diary/model/diary_picture_model.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';
import 'package:tiny_human_app/diary/view/diary_register_screen.dart';
import 'package:tiny_human_app/diary/view/diary_update_screen.dart';

import '../../common/constant/data.dart';
import '../../common/enum/update_delete_menu.dart';

class DiaryDetailScreen extends StatefulWidget {
  final DiaryResponseModel model;

  const DiaryDetailScreen({super.key, required this.model});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  final GlobalKey _menuButtonKey = GlobalKey();
  final dio = Dio();

  int photoCurrentIndex = 0;
  UpdateDeleteMenu? updateDeleteSelection;

  String? accessToken;

  @override
  void initState() {
    super.initState();
    // initState에서는 async가 안되기 때문에 함수로 분리한다.
    checkToken();
  }

  void checkToken() async {
    accessToken = (await storage.read(key: ACCESS_TOKEN_KEY))!;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0.0,
        title: _diaryAppBarTitle(),
        actions: [
          TextButton(
            onPressed: () {},
            child: _moreFeatureIcon(context, widget.model),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                widget.model.pictures.length > 1
                    ? CarouselSlider(
                        items: widget.model.pictures.map((image) {
                          return _diaryImage(image, context);
                        }).toList(),
                        options: CarouselOptions(
                            viewportFraction: 1.0,
                            height: MediaQuery.of(context).size.height / 1.8,
                            onPageChanged: (index, _) {
                              setState(() {
                                photoCurrentIndex = index;
                              });
                            }),
                      )
                    : _diaryImage(widget.model.pictures.first, context),
                if (widget.model.pictures.length > 1)
                  Positioned(
                    bottom: 5.0,
                    child: AnimatedSmoothIndicator(
                      activeIndex: photoCurrentIndex,
                      count: widget.model.pictures.length,
                      effect: JumpingDotEffect(
                        verticalOffset: 10.0,
                        jumpScale: 2.0,
                        dotColor: Colors.white.withOpacity(0.3),
                        activeDotColor: Colors.deepOrange.withOpacity(0.6),
                        dotWidth: 14.0,
                        dotHeight: 14.0,
                        spacing: 8.0,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Icon(
              Icons.horizontal_rule_outlined,
              color: PRIMARY_COLOR.withOpacity(0.7),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                widget.model.sentences.first.sentence,
                style: const TextStyle(
                  fontSize: 18.0,
                  height: 1.8,
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }

  Column _diaryAppBarTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          DataUtils.dateTimeToKoreanDateString(widget.model.date),
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Text(
          '+ ${widget.model.daysAfterBirth.toString()}일',
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Container _moreFeatureIcon(BuildContext context, DiaryResponseModel model) {
    return Container(
      height: 28.0,
      width: 28.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.8),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.bottomCenter,
      child: IconButton(
        key: _menuButtonKey,
        padding: const EdgeInsets.only(bottom: 0.0),
        onPressed: () {
          RenderBox renderBox =
              _menuButtonKey.currentContext!.findRenderObject() as RenderBox;
          Offset buttonOffset = renderBox.localToGlobal(Offset.zero);
          _showPopupMenu(buttonOffset, context, model);
        },
        icon: const Icon(
          Icons.more_horiz,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showPopupMenu(Offset buttonOffset, BuildContext context, DiaryResponseModel model) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(buttonOffset.dx, buttonOffset.dy, 0, 0),
      items: UpdateDeleteMenu.values
          .map(
            (value) => PopupMenuItem(
              value: value,
              textStyle: const TextStyle(
                color: Colors.black,
              ),
              child: Text(value.displayName),
              onTap: () async {
                https: //stackoverflow.com/questions/67713122/navigator-inside-popupmenuitem-does-not-work
                await Future.delayed(Duration.zero);
                if (UpdateDeleteMenu.UPDATE == value) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      settings: const RouteSettings(name: "/updateDiary"),
                      builder: (_) => DiaryUpdateScreen(model: model),
                    ),
                  );
                } else if (UpdateDeleteMenu.DELETE == value) {
                  print("delete this diary");
                  final response = await dio.delete(
                    'http://$ip/api/v1/diaries/${widget.model.id}',
                    options: Options(headers: {
                      'Authorization': 'Bearer $accessToken',
                    }),
                  );

                  if(mounted) {
                    Navigator.of(context).pop();
                  }

                }
              },
            ),
          )
          .toList(),
    );
  }

  Stack _diaryImage(DiaryPictureModel image, BuildContext context) {
    return Stack(
      children: [
        Image.network(
          '$S3_BASE_URL${image.keyName}',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.8,
          fit: BoxFit.cover,
        ),
        // Positioned(
        //   top: 50.0,
        //   child: SizedBox(
        //     width: MediaQuery.of(context).size.width,
        //     child: Padding(
        //       padding: const EdgeInsets.all(16.0),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Text(
        //             DataUtils.dateTimeToKoreanDateString(widget.model.date),
        //             style: const TextStyle(
        //               fontSize: 20.0,
        //               fontWeight: FontWeight.w600,
        //               color: Colors.white,
        //             ),
        //           ),
        //           const SizedBox(
        //             height: 4.0,
        //           ),
        //           Text(
        //             '+ ${widget.model.daysAfterBirth.toString()}일',
        //             style: const TextStyle(
        //               fontSize: 14.0,
        //               fontWeight: FontWeight.w600,
        //               color: Colors.white,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
