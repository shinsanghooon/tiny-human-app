import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';
import 'package:tiny_human_app/common/utils/date_convertor.dart';
import 'package:tiny_human_app/diary/model/diary_picture_model.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';
import 'package:tiny_human_app/diary/provider/diary_pagination_provider.dart';
import 'package:tiny_human_app/diary/view/diary_update_screen.dart';

import '../../common/constant/data.dart';
import '../../common/enum/update_delete_menu.dart';
import 'diary_screen.dart';

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
  DiaryUpdateDeleteMenu? updateDeleteSelection;

  String? accessToken;

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async {
    accessToken = (await storage.read(key: ACCESS_TOKEN_KEY))!;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryDetailProvider(widget.model.id));

    if (state == null) {
      return const DefaultLayout(
          child: Center(
              child: CircularProgressIndicator(
        color: PRIMARY_COLOR,
      )));
    }

    return DefaultLayout(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
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
        physics: const AlwaysScrollableScrollPhysics(),
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
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: _diaryDateTitle(state),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                state.sentences.first.sentence,
                style: const TextStyle(
                  fontSize: 20.0,
                  height: 1.8,
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            state.letter != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'From. 티니',
                          style: TextStyle(
                            fontSize: 20.0,
                            height: 1.8,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          state.letter!,
                          style: const TextStyle(
                            fontSize: 16.0,
                            height: 1.8,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      )
                    ],
                  )
                : const SizedBox(
                    height: 10.0,
                  )
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
          DateConvertor.dateTimeToKoreanDateString(state.date),
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            color: Colors.deepOrange,
          ),
        ),
        Text(
          '+${state.daysAfterBirth.toString()}일',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: Colors.deepOrange,
          ),
        ),
      ],
    );
  }

  Future<void> _checkDeleteMenuDialog(DiaryResponseModel state) async {
    const msgTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    );

    const buttonTextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 18.0,
    );

    return Dialogs.materialDialog(
      msg: '일기를 삭제하시겠습니까? 삭제된 일기는 복구할 수 없습니다.',
      msgStyle: msgTextStyle,
      title: "일기 삭제",
      titleStyle: msgTextStyle.copyWith(fontWeight: FontWeight.w600),
      color: Colors.white,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
          text: '돌아가기',
          color: PRIMARY_COLOR,
          iconData: Icons.cancel_outlined,
          textStyle: buttonTextStyle,
          iconColor: Colors.white,
        ),
        IconsButton(
          onPressed: () async {
            ref.read(diaryPaginationProvider.notifier).deleteDiary(diaryId: state.id);
            if (mounted) {
              context.goNamed(DiaryScreen.routeName);
            }
          },
          text: '삭제하기',
          iconData: Icons.delete,
          color: PRIMARY_COLOR,
          textStyle: buttonTextStyle,
          iconColor: Colors.white,
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
        onPressed: () async {
          RenderBox renderBox = _menuButtonKey.currentContext!.findRenderObject() as RenderBox;
          Offset buttonOffset = renderBox.localToGlobal(Offset.zero);
          _showPopupMenu(buttonOffset, context, state);
          // await _diaryDetailMenuDialog(state);
        },
        icon: const Icon(
          Icons.more_horiz,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showPopupMenu(Offset buttonOffset, BuildContext context, DiaryResponseModel state) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(buttonOffset.dx, buttonOffset.dy + 5, 25, 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18.0)),
      ),
      surfaceTintColor: Colors.white,
      items: DiaryUpdateDeleteMenu.values
          .map(
            (value) => PopupMenuItem(
              value: value,
              textStyle: const TextStyle(
                color: Colors.black,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(value.disPlayIcon),
                  ),
                  Text(
                    value.displayName,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              onTap: () async {
                https: //stackoverflow.com/questions/67713122/navigator-inside-popupmenuitem-does-not-work
                await Future.delayed(Duration.zero);
                if (DiaryUpdateDeleteMenu.UPDATE == value) {
                  if (mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: "/updateDiary"),
                        builder: (_) => DiaryUpdateScreen(id: state.id),
                      ),
                    );
                  }
                } else if (DiaryUpdateDeleteMenu.DELETE == value) {
                  await _checkDeleteMenuDialog(state);
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
