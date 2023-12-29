import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:tiny_human_app/common/component/image_container.dart';
import 'package:tiny_human_app/common/view/root_screen.dart';

import '../../common/constant/colors.dart';
import '../../common/constant/data.dart';
import '../../common/enum/update_delete_menu.dart';
import '../model/baby_model.dart';
import '../provider/baby_provider.dart';
import '../view/baby_update_screen.dart';

class BabyCardTwo extends ConsumerStatefulWidget {
  final BabyModel model;

  const BabyCardTwo({required this.model, super.key});

  @override
  ConsumerState<BabyCardTwo> createState() => _BabyCardTwoState();
}

class _BabyCardTwoState extends ConsumerState<BabyCardTwo> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey menuButtonKey = GlobalKey();

    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: ImageContainer(
                      url: widget.model.profileImgKeyName == ""
                          ? SAMPLE_BABY_IMAGE_URL
                          : '$S3_BASE_URL${widget.model.profileImgKeyName}',
                      width: 400,
                      height: 300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 14.0,
                      left: 14.0,
                      right: 14.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.model.name,
                          style: const TextStyle(
                              fontSize: 26.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 3.0),
                        ),
                        InkWell(
                          key: menuButtonKey,
                          onTap: () {
                            RenderBox renderBox = menuButtonKey.currentContext!
                                .findRenderObject() as RenderBox;
                            Offset buttonOffset =
                                renderBox.localToGlobal(Offset.zero);
                            _showPopupMenu(buttonOffset, context, widget.model);
                            // await _diaryDetailMenuDialog(state);
                          },
                          child: Align(
                              child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border:
                                    Border.all(width: 2, color: Colors.white)),
                            child: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.model.dayOfBirth} ${widget.model.timeOfBirth}시',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.model.gender == 'FEMALE'
                                ? const Icon(
                                    Icons.female_outlined,
                                    color: Colors.pink,
                                    size: 20.0,
                                  )
                                : const Icon(
                                    Icons.male_outlined,
                                    color: Colors.blueAccent,
                                    size: 20.0,
                                  ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              widget.model.gender == 'FEMALE' ? '여아' : '남아',
                              style: widget.model.gender == 'FEMALE'
                                  ? const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.pink,
                                      fontWeight: FontWeight.w600,
                                    )
                                  : const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      widget.model.description,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: () {
                        context.goNamed(RootScreen.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: PRIMARY_COLOR,
                        elevation: 4,
                      ),
                      child: Text(
                        "선택",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPopupMenu(
      Offset buttonOffset, BuildContext context, BabyModel state) {
    showMenu(
      context: context,
      position:
          RelativeRect.fromLTRB(buttonOffset.dx, buttonOffset.dy + 10, 60, 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.0),
          bottomLeft: Radius.circular(14.0),
          bottomRight: Radius.circular(14.0),
        ),
      ),
      items: BabyUpdateDeleteMenu.values
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
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              onTap: () async {
                https: //stackoverflow.com/questions/67713122/navigator-inside-popupmenuitem-does-not-work
                await Future.delayed(Duration.zero);
                if (BabyUpdateDeleteMenu.UPDATE == value) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BabyUpdateScreen(model: state),
                    ),
                  );
                } else if (BabyUpdateDeleteMenu.DELETE == value) {
                  await _checkDeleteMenuDialog(state);
                }
              },
            ),
          )
          .toList(),
    );
  }

  Future<void> _checkDeleteMenuDialog(BabyModel state) async {
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
      msg: '정말 삭제하시겠습니까? 삭제된 아기는 복구할 수 없습니다.',
      msgStyle: msgTextStyle,
      title: "아기 삭제",
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
            print('delete baby?');
            ref.read(babyProvider.notifier).delete(widget.model.id);
            if (mounted) {
              Navigator.of(context).pop();
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
}
