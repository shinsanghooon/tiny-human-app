import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiny_human_app/album/model/album_response_model.dart';
import 'package:tiny_human_app/album/provider/album_pagination_provider.dart';
import 'package:tiny_human_app/album/provider/album_provider.dart';
import 'package:tiny_human_app/common/component/image_container.dart';
import 'package:tiny_human_app/common/constant/data.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_model.dart';

import '../../common/constant/colors.dart';

class AlbumScreen extends ConsumerStatefulWidget {
  static String get routeName => 'album';

  const AlbumScreen({super.key});

  @override
  ConsumerState<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends ConsumerState<AlbumScreen> {
  double gridCount = 4;
  double endScale = 1.0;

  bool isSelectMode = false;
  List<int> selectedIds = List.empty();

  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final albums = ref.watch(albumProvider.notifier);
    final albumPagination = ref.watch(albumPaginationProvider);

    if (albumPagination is CursorPaginationLoading) {
      return const Center(
          child: CircularProgressIndicator(
        color: PRIMARY_COLOR,
      ));
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
                onPressed: () => Navigator.of(context).pop(),
              ),
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
                            icon: const Icon(
                              Icons.more_horiz,
                              color: PRIMARY_COLOR,
                            ),
                            onPressed: () async {
                              debugPrint('Show Menu Button');
                            },
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: PRIMARY_COLOR,
                            ),
                            onPressed: () async {
                              List<XFile> selectedImages = await uploadImages();
                              if (selectedImages.isNotEmpty) {
                                albums.addAlbums(1, selectedImages);
                              }
                              ref
                                  .read(albumPaginationProvider.notifier)
                                  .addAlbums();
                            },
                          ),
                  ],
                )
              ],
            ),
            SliverGrid(
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
                            print('Select Model ID : ${selectedModel.id}');
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
                            print('Selected IDs : ${selectedIds.toString()}');
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
        body: Center(child: CachedNetworkImage(imageUrl: image)),
      ),
    );
  }
}
