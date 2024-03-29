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
import '../../common/enum/album_sort.dart';
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
  final GlobalKey _sortButtonKey = GlobalKey();
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

  void onScaleUpdate(ScaleUpdateDetails details) {
    // 제스처에 따라 그리드 수를 동적으로 조절
    endScale = details.scale;
  }

  void onScaleEnd(ScaleEndDetails details) {
    setState(() {
      if (endScale == 1.0) {
        return;
      }

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

  @override
  Widget build(BuildContext context) {
    final albumList = ref.watch(albumPaginationProvider);
    String orderBy = ref.read(albumPaginationProvider.notifier).order;

    final babyId = ref.watch(selectedBabyProvider);
    final babies = ref.watch(babyProvider);
    final selectedBaby = babies.where((baby) => baby.id == babyId).first;

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
                toolbarHeight: 64.0,
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
                          key: _sortButtonKey,
                          onPressed: () {
                            _showAlbumSortPopupMenu(context, orderBy);
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
                                _showAlbumModifyPopupMenu(context);
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
                                  int babyId = ref.read(selectedBabyProvider);

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
                                            daysAfterBirth: DateConvertor.calculateDaysAfterBaseDate(
                                                selectedBaby.dayOfBirth, selectedModel.originalCreatedAt!)),
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

  void _showAlbumSortPopupMenu(BuildContext context, String orderBy) {
    RenderBox renderBox = _sortButtonKey.currentContext!.findRenderObject() as RenderBox;
    Offset buttonOffset = renderBox.localToGlobal(Offset.zero);
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(buttonOffset.dx, buttonOffset.dy + 30, 20, 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18.0)),
      ),
      surfaceTintColor: Colors.white,
      items: AlbumSorting.values
          .map(
            (value) => PopupMenuItem(
              value: value,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(value.disPlayIcon),
                  ),
                  orderBy == value.name
                      ? Text(
                          value.displayName,
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                        )
                      : Text(
                          value.displayName,
                          style: const TextStyle(fontSize: 18.0),
                        )
                ],
              ),
              onTap: () {
                if (orderBy != value.name) {
                  if (AlbumSorting.UPLOAD == value) {
                    ref.read(albumOrderByProvider.notifier).update((state) => AlbumSorting.UPLOAD.name);
                  } else {
                    // createdAt
                    ref.read(albumOrderByProvider.notifier).update((state) => AlbumSorting.CREATE.name);
                  }
                }
              },
            ),
          )
          .toList(),
    );
  }

  void _showAlbumModifyPopupMenu(BuildContext buildContext) {
    RenderBox renderBox = _menuButtonKey.currentContext!.findRenderObject() as RenderBox;
    Offset buttonOffset = renderBox.localToGlobal(Offset.zero);
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(buttonOffset.dx, buttonOffset.dy + 30, 20, 0),
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
            int babyId = ref.read(selectedBabyProvider);
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
    return images;
  }
}

class PhotoRoute extends StatelessWidget {
  final String image;
  final String date;
  final int daysAfterBirth;

  const PhotoRoute({
    required this.image,
    required this.date,
    required this.daysAfterBirth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              // Text(
              //   '+$daysAfterBirth일',
              //   style: const TextStyle(
              //     fontSize: 14.0,
              //     color: PRIMARY_COLOR,
              //   ),
              // )
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  color: PRIMARY_COLOR,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    '+$daysAfterBirth일',
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
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
