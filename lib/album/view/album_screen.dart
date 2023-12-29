import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:tiny_human_app/album/model/album_response_model.dart';
import 'package:tiny_human_app/album/provider/album_pagination_provider.dart';
import 'package:tiny_human_app/album/provider/album_provider.dart';
import 'package:tiny_human_app/baby/view/baby_screen.dart';
import 'package:tiny_human_app/common/component/image_container.dart';
import 'package:tiny_human_app/common/constant/data.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_model.dart';

import '../../common/constant/colors.dart';
import '../../common/enum/update_delete_menu.dart';

class AlbumScreen extends ConsumerStatefulWidget {
  static String get routeName => 'album';

  const AlbumScreen({super.key});

  @override
  ConsumerState<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends ConsumerState<AlbumScreen> {
  final GlobalKey _menuButtonKey = GlobalKey();
  double gridCount = 4;
  double endScale = 1.0;
  bool isLoading = false;

  bool isSelectMode = false;
  List<int> selectedIds = List.empty();

  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final albums = ref.watch(albumProvider.notifier);
    final albumPagination = ref.watch(albumPaginationProvider);

    if (albumPagination is CursorPaginationLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
            child: CircularProgressIndicator(
          color: PRIMARY_COLOR,
          strokeWidth: 8.0,
        )),
      );
    }

    if (albumPagination is CursorPaginationError) {
      return Center(
        child: Text("에러가 있습니다. ${albumPagination.message}"),
      );
    }

    final cp = albumPagination as CursorPagination;
    final data = cp.body;

    final s3ImageUrls = data.map((e) => '${S3_BASE_URL}${e.keyName}').toList();

    void onScaleUpdate(ScaleUpdateDetails details) {
      // 제스처에 따라 그리드 수를 동적으로 조절
      endScale = details.scale;
    }

    void onScaleEnd(ScaleEndDetails details) {
      setState(() {
        if (endScale < 1) {
          gridCount += 1;
        } else {
          gridCount -= 1;
        }

        if (gridCount == 0) {
          gridCount = 1;
        }

        if (gridCount == 11) {
          gridCount = 10;
        }
      });
    }

    return Scaffold(
      body: GestureDetector(
        onScaleUpdate: onScaleUpdate,
        onScaleEnd: onScaleEnd,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              title: const Text(
                "ALBUM",
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w800,
                ),
              ),
              leading: IconButton(
                  icon: const Icon(
                    Icons.home_outlined,
                    color: PRIMARY_COLOR,
                  ),
                  onPressed: () => context.goNamed(BabyScreen.routeName)),
              actions: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isSelectMode = !isSelectMode;
                          if (!isSelectMode) {
                            selectedIds = List.empty();
                          }
                        });
                      },
                      icon: isSelectMode
                          ? const Icon(
                              Icons.check_circle,
                              color: PRIMARY_COLOR,
                            )
                          : const Icon(
                              Icons.check_circle_outline_outlined,
                              color: PRIMARY_COLOR,
                            ),
                    ),
                    isSelectMode
                        ? IconButton(
                            key: _menuButtonKey,
                            icon: const Icon(
                              Icons.more_horiz,
                              color: PRIMARY_COLOR,
                            ),
                            onPressed: () async {
                              debugPrint('Show Menu Button');
                              RenderBox renderBox = _menuButtonKey
                                  .currentContext!
                                  .findRenderObject() as RenderBox;
                              Offset buttonOffset =
                                  renderBox.localToGlobal(Offset.zero);
                              _showAlbumPopupMenu(buttonOffset, context);
                            },
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: PRIMARY_COLOR,
                            ),
                            onPressed: () async {
                              List<XFile> selectedImages = await uploadImages();

                              setState(() {
                                isLoading = true;
                              });

                              if (selectedImages.isNotEmpty) {
                                albums.addAlbums(1, selectedImages);
                              }
                              var duration =
                                  Duration(seconds: 1 * selectedImages.length);
                              await Future.delayed(duration);

                              ref
                                  .read(albumPaginationProvider.notifier)
                                  .addAlbums();

                              setState(() {
                                isLoading = false;
                              });
                            },
                          ),
                  ],
                )
              ],
            ),
            isLoading
                ? SliverToBoxAdapter(
                    child: Container(
                    height: MediaQuery.of(context).size.height -
                        200, // sliver app bar default height
                    child: Center(
                        child: CircularProgressIndicator(
                      color: PRIMARY_COLOR,
                      strokeWidth: 8.0,
                    )),
                  ))
                : SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index + 1 > s3ImageUrls.length) {
                        return null;
                      }
                      return Padding(
                        padding: EdgeInsets.all(8 / gridCount),
                        child: isSelectMode
                            ? GestureDetector(
                                onTap: () {
                                  final selectedModel =
                                      (data[index] as AlbumResponseModel);
                                  setState(() {
                                    if (selectedIds
                                        .where((id) => id == data[index].id)
                                        .isEmpty) {
                                      selectedIds = [
                                        ...selectedIds,
                                        selectedModel.id
                                      ];
                                    } else {
                                      selectedIds.remove(data[index].id);
                                    }
                                  });
                                },
                                child: ImageContainer(
                                  url: s3ImageUrls[index],
                                  width: null,
                                  height: null,
                                  selected: selectedIds
                                      .where((id) => id == data[index].id)
                                      .isNotEmpty,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PhotoRoute(
                                        image: s3ImageUrls[index],
                                      ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6.0),
                                  child: ImageContainer(
                                    url: s3ImageUrls[index],
                                    width: null,
                                    height: null,
                                  ),
                                ),
                              ),
                      );
                    }),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCount.toInt(),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  void _showAlbumPopupMenu(Offset buttonOffset, BuildContext context) {
    showMenu(
      context: context,
      position:
          RelativeRect.fromLTRB(buttonOffset.dx, buttonOffset.dy + 20, 20, 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.0),
          bottomLeft: Radius.circular(14.0),
          bottomRight: Radius.circular(14.0),
        ),
      ),
      items: AlbumPopUpMenu.values
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
                if (AlbumPopUpMenu.DELETE == value) {
                  await _checkDeleteMenuDialog();
                }
              },
            ),
          )
          .toList(),
    );
  }

  Future<void> _checkDeleteMenuDialog() async {
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
      msg: '앨범을 삭제하시겠습니까? 삭제된 앨범은 복구할 수 없습니다.',
      msgStyle: msgTextStyle,
      title: "앨범 삭제",
      titleStyle: msgTextStyle.copyWith(fontWeight: FontWeight.w600),
      color: Colors.white,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            if (mounted) {
              // TODO: Go to DiaryDetailScreen
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
            // final response = await dio.delete(
            //   'http://$ip/api/v1/diaries/${state.id}',
            //   options: Options(headers: {
            //     'Authorization': 'Bearer $accessToken',
            //   }),
            // );
            // ref
            //     .read(diaryPaginationProvider.notifier)
            //     .deleteDetail(id: state.id);
            // if (mounted) {
            //   // TODO: Go to DiaryScreen
            //   context.goNamed(DiaryScreen.routeName);
            // }
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

  Future<List<XFile>> uploadImages() async {
    List<XFile>? images = await imagePicker.pickMultipleMedia();
    debugPrint('[ALBUM UPLOAD] selected images count: ${images.length}');
    return images;
  }
}

class PhotoRoute extends StatelessWidget {
  final image;

  const PhotoRoute({
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Scaffold(
        appBar: AppBar(),
        body: SizedBox(
            height: MediaQuery.of(context).size.height -
                200, // sliver app bar default height,
            child: Center(child: CachedNetworkImage(imageUrl: image))),
      ),
    );
  }
}
