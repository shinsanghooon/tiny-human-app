import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';
import 'package:tiny_human_app/common/utils/data_utils.dart';
import 'package:tiny_human_app/diary/model/diary_picture_model.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';
import 'package:tiny_human_app/diary/provider/diary_pagination_provider.dart';
import 'package:tiny_human_app/diary/view/diary_update_screen.dart';

import '../../common/constant/data.dart';
import '../../common/enum/update_delete_menu.dart';

class DiaryDetailScreen extends ConsumerStatefulWidget {
  final DiaryResponseModel model;

  const DiaryDetailScreen({super.key, required this.model});

  @override
  ConsumerState<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends ConsumerState<DiaryDetailScreen> {
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
    ref.read(diaryPaginationProvider.notifier).getDetail(id: widget.model.id);
  }

  void checkToken() async {
    accessToken = (await storage.read(key: ACCESS_TOKEN_KEY))!;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryDetailProvider(widget.model.id));
    print('Diary Detail Screen');

    if (state == null) {
      return DefaultLayout(child: Center(child: CircularProgressIndicator()));
    }

    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {},
            child: _moreFeatureIcon(context, state),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                state.pictures.length > 1
                    ? CarouselSlider(
                        items: state.pictures.map((image) {
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
                    : _diaryImage(state.pictures.first, context),
                if (state.pictures.length > 1)
                  Positioned(
                    bottom: 5.0,
                    child: AnimatedSmoothIndicator(
                      activeIndex: photoCurrentIndex,
                      count: state.pictures.length,
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
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Icon(
                Icons.horizontal_rule_outlined,
                color: PRIMARY_COLOR.withOpacity(0.7),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: _diaryDateTitle(state),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                state.sentences.first.sentence,
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

  Widget _diaryDateTitle(DiaryResponseModel state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DataUtils.dateTimeToKoreanDateString(state.date),
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Text(
          '+ ${state.daysAfterBirth.toString()}일',
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Colors.deepOrange,
          ),
        ),
      ],
    );
  }

  Container _moreFeatureIcon(BuildContext context, DiaryResponseModel state) {
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
          _showPopupMenu(buttonOffset, context, state);
        },
        icon: const Icon(
          Icons.more_horiz,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showPopupMenu(
      Offset buttonOffset, BuildContext context, DiaryResponseModel state) {
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
                      builder: (_) => DiaryUpdateScreen(id: state.id),
                    ),
                  );
                } else if (UpdateDeleteMenu.DELETE == value) {
                  print("delete this diary");
                  final response = await dio.delete(
                    'http://$ip/api/v1/diaries/${state.id}',
                    options: Options(headers: {
                      'Authorization': 'Bearer $accessToken',
                    }),
                  );
                  ref
                      .read(diaryPaginationProvider.notifier)
                      .deleteDetail(id: state.id);
                  if (mounted) {
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
      ],
    );
  }
}
