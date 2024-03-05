import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:mime/mime.dart';
import 'package:tiny_human_app/album/model/album_delete_request_model.dart';
import 'package:tiny_human_app/album/model/album_response_model.dart';
import 'package:tiny_human_app/album/provider/album_pagination_provider.dart';
import 'package:tiny_human_app/baby/provider/baby_provider.dart';
import 'package:tiny_human_app/baby/view/baby_screen.dart';
import 'package:tiny_human_app/common/component/image_container.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_model.dart';
import 'package:tiny_human_app/common/utils/date_convertor.dart';
import 'package:tiny_human_app/common/utils/s3_url_generator.dart';

import '../../common/constant/colors.dart';
import '../../common/dio/dio.dart';
import '../../common/enum/update_delete_menu.dart';
import '../../common/utils/pagination_utils.dart';
import '../model/album_model.dart';

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

  final ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(albumPaginationProvider.notifier),
    );
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final albumList = ref.watch(albumPaginationProvider);
    String orderBy = ref.read(albumPaginationProvider.notifier).order;

    if (albumList is CursorPaginationLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
            child: CircularProgressIndicator(
          color: PRIMARY_COLOR,
          strokeWidth: 8.0,
        )),
      );
    }

    if (albumList is CursorPaginationError) {
      return Center(
        child: Text("에러가 발생했습니다. ${albumList.message}"),
      );
    }

    final cp = albumList as CursorPagination;
    final data = cp.body;
    final s3ImageUrls = data.map((e) => S3UrlGenerator.getThumbnailUrlWith1000wh(e.keyName)).toList();

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
      body: RefreshIndicator(
        edgeOffset: 100.0,
        color: PRIMARY_COLOR,
        onRefresh: () async {
          ref.read(albumPaginationProvider.notifier).paginate(forceRefetch: true);
        },
        child: GestureDetector(
          onScaleUpdate: onScaleUpdate,
          onScaleEnd: onScaleEnd,
          child: CustomScrollView(
            controller: controller,
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
                            showModalBottomSheet<void>(
                              backgroundColor: Colors.white,
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 150,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: ListTile(
                                          onTap: () {
                                            if (orderBy != 'uploadedAt') {
                                              ref.read(albumOrderByProvider.notifier).update((state) => 'uploadedAt');
                                            }

                                            Navigator.of(context).pop();
                                          },
                                          title: orderBy == 'uploadedAt'
                                              ? const Text('업로드 날짜 순', style: TextStyle(fontWeight: FontWeight.w600))
                                              : const Text('업로드 날짜 순'),
                                        ),
                                      ),
                                      ListTile(
                                          onTap: () {
                                            if (orderBy != 'createdAt') {
                                              ref.read(albumOrderByProvider.notifier).update((state) => 'createdAt');
                                            }
                                            Navigator.of(context).pop();
                                          },
                                          title: orderBy == 'createdAt'
                                              ? const Text('사진 찍은 날짜 순', style: TextStyle(fontWeight: FontWeight.w600))
                                              : const Text('사진 찍은 날짜 순')),
                                    ],
                                  ),
                                );
                              },
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          icon: const Icon(
                            Icons.sort_outlined,
                            color: PRIMARY_COLOR,
                          )),
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
                                RenderBox renderBox = _menuButtonKey.currentContext!.findRenderObject() as RenderBox;
                                Offset buttonOffset = renderBox.localToGlobal(Offset.zero);
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
                                  int babyId = ref.read(selectedBabyProvider.notifier).state;

                                  List<AlbumModel> albumsWithPreSignedUrl = await ref
                                      .read(albumPaginationProvider.notifier)
                                      .addAlbums(babyId, selectedImages);

                                  final dio = ref.watch(dioProvider);

                                  await Future.wait(
                                      selectedImages.asMap().entries.map((entry) async {
                                        int index = entry.key;
                                        var selectedImage = entry.value;
                                        String preSignedUrl = albumsWithPreSignedUrl[index].preSignedUrl;
                                        File file = File(selectedImage.path);
                                        String? mimeType = lookupMimeType(file.path);
                                        return dio.put(
                                          preSignedUrl,
                                          data: file.openRead(),
                                          options: Options(
                                            headers: {
                                              Headers.contentLengthHeader: file.lengthSync(),
                                            },
                                            contentType: mimeType,
                                          ),
                                        );
                                      }).toList(),
                                      eagerError: false);
                                }
                                var duration = Duration(milliseconds: 200 * selectedImages.length);
                                await Future.delayed(duration);

                                ref.read(albumPaginationProvider.notifier).addAlbumsToState();

                                setState(() {
                                  isLoading = false;
                                });
                              })
                    ],
                  )
                ],
              ),
              isLoading
                  ? SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 200, // sliver app bar default height
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: PRIMARY_COLOR,
                            strokeWidth: 8.0,
                          ),
                        ),
                      ),
                    )
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
                                    final selectedModel = (data[index] as AlbumResponseModel);
                                    setState(() {
                                      if (selectedIds.where((id) => id == data[index].id).isEmpty) {
                                        selectedIds = [...selectedIds, selectedModel.id];
                                      } else {
                                        selectedIds.remove(data[index].id);
                                      }
                                    });
                                  },
                                  child: ImageContainer(
                                    url: s3ImageUrls[index],
                                    width: null,
                                    height: null,
                                    selected: selectedIds.where((id) => id == data[index].id).isNotEmpty,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    final selectedModel = (data[index] as AlbumResponseModel);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PhotoRoute(
                                          image: s3ImageUrls[index],
                                          date: DateConvertor.dateTimeToKoreanDateString(
                                              selectedModel.originalCreatedAt!),
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
      ),
    );
  }

  void _showAlbumPopupMenu(Offset buttonOffset, BuildContext buildContext) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(buttonOffset.dx, buttonOffset.dy + 20, 20, 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18.0)),
      ),
      surfaceTintColor: Colors.white,
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
                  await _checkDeleteMenuDialog(buildContext);
                }
              },
            ),
          )
          .toList(),
    );
  }

  Future<void> _checkDeleteMenuDialog(BuildContext buildContext) async {
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
            int babyId = ref.read(selectedBabyProvider.notifier).state;
            ref.read(albumPaginationProvider.notifier).deleteAlbums(
                  babyId,
                  AlbumDeleteRequestModel(ids: selectedIds),
                );

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

  Future<List<XFile>> uploadImages() async {
    List<XFile>? images = await imagePicker.pickMultipleMedia();
    debugPrint('[ALBUM UPLOAD] selected images count: ${images.length}');
    return images;
  }
}

class PhotoRoute extends StatelessWidget {
  final String image;
  final String date;

  const PhotoRoute({
    required this.image,
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            date,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height - 200, // sliver app bar default height,
          child: Center(
            child: CachedNetworkImage(
              imageUrl: image,
            ),
          ),
        ),
      ),
    );
  }
}
