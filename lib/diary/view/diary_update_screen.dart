import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tiny_human_app/diary/enum/save_type.dart';
import 'package:tiny_human_app/diary/model/diary_file_model.dart';
import 'package:tiny_human_app/diary/model/diary_picture_model.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';
import 'package:tiny_human_app/diary/model/diary_sentence_model.dart';
import 'package:tiny_human_app/diary/model/sentence_request_model.dart';
import 'package:tiny_human_app/diary/provider/diary_pagination_provider.dart';

import '../../common/component/alert_dialog.dart';
import '../../common/component/custom_long_text_form_field.dart';
import '../../common/constant/colors.dart';
import '../../common/constant/data.dart';
import '../../common/layout/default_layout.dart';
import '../model/photo_with_savetype_model.dart';

class DiaryUpdateScreen extends ConsumerStatefulWidget {
  final int id;

  const DiaryUpdateScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<DiaryUpdateScreen> createState() => _DiaryUpdateScreenState();
}

class _DiaryUpdateScreenState extends ConsumerState<DiaryUpdateScreen> {
  final dio = Dio();
  final GlobalKey<FormState> formKey = GlobalKey();
  final ImagePicker imagePicker = ImagePicker(); //ImagePicker 초기화
  String? accessToken;

  int photoCurrentIndex = 0;

  // previous data
  int? daysAfterBirth;
  DateTime? diaryDate;
  List<String> fileNames = [];
  String? sentence;

  DateTime? baseDiaryDate;
  int? baseDaysAfterBirth;
  List<DiaryPictureModel> baseFiles = [];
  List<DiarySentenceModel> baseSentence = [];

  List<PhotoWithSaveTypeModel> saveModels = [];
  List<PhotoWithSaveTypeModel> deletedFiles = [];

  @override
  void initState() {
    super.initState();
    // initState에서는 async가 안되기 때문에 함수로 분리한다.
    checkToken();
    ref.read(diaryPaginationProvider.notifier).getDetail(id: widget.id);
  }

  void checkToken() async {
    accessToken = (await storage.read(key: ACCESS_TOKEN_KEY))!;
  }

  void calculateDaysAfterBirth(DateTime selectedDate) {
    final birthday = DateTime(2022, 9, 27);
    daysAfterBirth = selectedDate
        .difference(birthday)
        .inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryDetailProvider(widget.id));

    if (state == null) {
      return const DefaultLayout(
          child: Center(
              child: CircularProgressIndicator(
                color: PRIMARY_COLOR,
              )));
    }

    if (saveModels.isEmpty) {
      for (var picture in state.pictures) {
        saveModels.add(PhotoWithSaveTypeModel(
            id: picture.id, type: SaveType.URL, path: picture.keyName));
      }
    }

    diaryDate = state.date;
    calculateDaysAfterBirth(diaryDate!);

    // base data
    baseDiaryDate = state.date;
    baseDaysAfterBirth = state.daysAfterBirth;
    baseFiles = state.pictures;
    baseSentence = state.sentences;

    return DefaultLayout(
      appBar: diaryAppBar(context),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _diaryImageCarousel(context, saveModels, deletedFiles),
                const SizedBox(height: 20.0),
                _diaryDate(context),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Form(
                    key: formKey,
                    child: diaryTextCard(1, 1, state.sentences.first),
                  ),
                ),
                _updateDiaryActionButton(
                    context, state, saveModels, deletedFiles),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _diaryDate(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        datePickerButton(context),
        const SizedBox(width: 14.0),
        if (daysAfterBirth != null)
          Text(
            '+${daysAfterBirth.toString()}일',
            style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
            ),
          ),
      ],
    );
  }

  GestureDetector _diaryImageCarousel(BuildContext context,
      List<PhotoWithSaveTypeModel> models,
      List<PhotoWithSaveTypeModel> deletedFiles) {
    return models.isEmpty
        ? GestureDetector(
      onTap: () async {
        List<XFile> selectedImages = await uploadImages();
        if ((models.length + selectedImages.length) > 5) {
          throw const Expanded(child: Text("사진은 5장까지만 선택이 가능합니다."));
        }

        setState(() {
          List<PhotoWithSaveTypeModel> temp = selectedImages.map((image) {
            return PhotoWithSaveTypeModel(
                type: SaveType.LOCAL, path: image.path, name: image.name);
          }).toList();

          saveModels = [
            ...models,
            ...temp,
          ];
        });
      },
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .width / 1.2,
        width: MediaQuery
            .of(context)
            .size
            .width / 1.2,
        color: Colors.deepOrange.shade500,
        child: _uploadPhotoLabel(),
      ),
    )
        : GestureDetector(
      onTap: () async {
        List<XFile> selectedImages = await uploadImages();
        print('selected images length : ${selectedImages.length}');

        if ((models.length + selectedImages.length) > 5) {
          throw const Expanded(child: Text("사진은 5장까지만 선택이 가능합니다."));
        }

        setState(() {
          List<PhotoWithSaveTypeModel> temp = selectedImages.map((image) {
            return PhotoWithSaveTypeModel(
                type: SaveType.LOCAL, path: image.path, name: image.name);
          }).toList();

          // 여기서 setState를 하니까 위젯이 다시 빌드되고 이미지는 다시 1개가 된다...
          saveModels = [
            ...models,
            ...temp,
          ];
        });
      },
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .width / 1.2,
        width: MediaQuery
            .of(context)
            .size
            .width / 1.2,
        color: Colors.transparent,
        child: _uploadPhotoCarousel(
            MediaQuery
                .of(context)
                .size
                .width / 1.2,
            models,
            deletedFiles),
      ),
    );
  }

  Future<List<XFile>> uploadImages() async {
    List<XFile>? images = await imagePicker.pickMultipleMedia();
    print('[DIARY IMAGE UPLOAD] selected images count: ${images.length}');
    return images;
  }

  Widget _uploadPhotoLabel() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.photo_outlined,
          size: 100.0,
        ),
        Text(
          "사진을 업로드 해주세요.",
          style: TextStyle(
            fontSize: 20.0,
          ),
        )
      ],
    );
  }

  Widget _uploadPhotoCarousel(double size, List<PhotoWithSaveTypeModel> models,
      List<PhotoWithSaveTypeModel> deletedFiles) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
            items: models.map((image) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: image.type == SaveType.LOCAL
                        ? Image.asset(
                      image.path,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    )
                        : Image.network(
                      '$S3_BASE_URL${image.path}',
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.cancel),
                      color: Colors.deepOrange.withOpacity(0.9),
                      onPressed: () {
                        setState(() {
                          PhotoWithSaveTypeModel deleteModel =
                          models.removeAt(photoCurrentIndex);
                          deletedFiles.add(deleteModel);
                          if (deleteModel.type == SaveType.URL) {
                            print("삭제 요청 API를 호출한다");
                          } else {
                            print("로컬 이미지를 제거한다");
                          }
                        });
                      },
                    ),
                  )
                ],
              );
            }).toList(),
            options: CarouselOptions(
                height: size,
                viewportFraction: 1.0,
                onPageChanged: (index, _) {
                  setState(() {
                    photoCurrentIndex = index;
                  });
                })),
        Positioned(
          bottom: 5.0,
          child: AnimatedSmoothIndicator(
            activeIndex: photoCurrentIndex,
            count: models.length,
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
    );
  }

  // 입력 폼 위젯 생성
  Widget diaryTextCard(int id, diaryLength,
      DiarySentenceModel originalSentence) {
    return SizedBox(
      height: 250,
      child: CustomLongTextFormField(
        keyName: 'update_description_$id',
        onSaved: (String? value) {
          sentence = value;
        },
        initialValue: originalSentence.sentence,
      ),
    );
  }

  SizedBox _updateDiaryActionButton(BuildContext context,
      DiaryResponseModel state,
      List<PhotoWithSaveTypeModel> models,
      List<PhotoWithSaveTypeModel> deletedFiles) {
    return SizedBox(
      height: 46.0,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: ElevatedButton(
        onPressed: () async {
          // 서버에 요청을 보낸다.
          print('[Request] Update Diary');
          print(accessToken);

          if (formKey.currentState == null) {
            return;
          }

          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
          } else {
            return;
          }

          int userId = 1;
          int babyId = 1;
          int diaryId = state.id;

          // 기존 데이터와 비교해서 달라졌으면 Patch 요청
          if (isSentenceChanged()) {
            print("일기 글(${state.sentences.first.id})이 수정됨.");
            print(sentence);
            try {
              final response = await dio.patch(
                'http://$ip/api/v1/diaries/$diaryId/sentences/${state.sentences
                    .first.id}',
                options: Options(headers: {
                  'Authorization': 'Bearer $accessToken',
                }),
                data: SentenceRequestModel(sentence: sentence!),
              );
            } catch (e) {
              if (mounted) {
                showDialogWhenResponseFail(context);
              }
            }
          }

          // 날짜가 수정된 경우
          if (isDateChanged()) {
            print("날짜가 수정됨.");
            // TODO: 백엔드 API 개발 필요함.
          }

          // 기존에 삭제된 이미지는 서버에 삭제 요청
          print('기존 사진에서 삭제 요청 ${deletedFiles.length}개');
          for (var deletedFile in deletedFiles) {
            print('- 서버에 삭제 요청 id: ${deletedFile.id}');

            try {
              final response = await dio.delete(
                'http://$ip/api/v1/diaries/$diaryId/pictures/${deletedFile.id}',
                options: Options(headers: {
                  'Authorization': 'Bearer $accessToken',
                }),
              );

              if (response.statusCode != 204) {
                throw Exception("요청 결과를 확인해주세요.");
              }
            } catch (e) {
              if (mounted) {
                showDialogWhenResponseFail(context);
              }
            }
          }

          // 이미지는 새로 업로드된 이미지만 수정
          List<PhotoWithSaveTypeModel> newImages =
          models.where((image) => image.type == SaveType.LOCAL).toList();
          print('새로 업로드된 사진 ${newImages.length}개');

          try {
            Response response = await dio.post(
              'http://$ip/api/v1/diaries/$diaryId/pictures',
              options: Options(headers: {
                'Authorization': 'Bearer $accessToken',
              }),
              data: newImages
                  .map((image) => DiaryFileModel(fileName: image.name!))
                  .toList(),
            );

            if (response.statusCode != 201) {
              throw Exception("요청에 문제가 발생했습니다.");
            }

            List<String> preSignedUrls = (response.data['pictures'] as List)
                .where((e) => e['preSignedUrl'] != null)
                .map((e) => e['preSignedUrl'] as String)
                .toList();

            List<PhotoWithSaveTypeModel> localImages =
            models.where((model) => model.type == SaveType.LOCAL).toList();

            for (int i = 0; i < localImages.length; i++) {
              File file = File(localImages[i].path!);

              String? mimeType = lookupMimeType(file.path);

              await dio.put(preSignedUrls[i],
                  data: file.openRead(),
                  options: Options(
                    headers: {
                      Headers.contentLengthHeader: file.lengthSync(),
                    },
                    contentType: mimeType,
                  ));
            }

            ref.read(diaryPaginationProvider.notifier).getDetail(id: widget.id);
          } catch (e) {
            print(e);
            if (mounted) {
              showDialogWhenResponseFail(context);
            }
          }
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
        ),
        child: const Text(
          "수정 하기",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void showDialogWhenResponseFail(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const CustomAlertDialog(
            title: '등록 실패',
            content: '등록에 실패하였습니다. 잠시 후에 다시 시도해주세요.',
            buttonText: '확인',
          );
        });
  }

  bool isDateChanged() => baseDiaryDate != diaryDate;

  bool isSentenceChanged() => baseSentence.first.sentence != sentence;

  AppBar diaryAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "일기 수정",
        style: TextStyle(
          color: Colors.deepOrange,
          fontWeight: FontWeight.w800,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: PRIMARY_COLOR),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  Widget datePickerButton(BuildContext context) {
    return SizedBox(
      height: 46.0,
      child: OutlinedButton(
        onPressed: () {
          showDatePicker(
            context: context,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          ).then((value) {
            setState(() {
              print('date picket set state');
              print(value);
              diaryDate = value;
              print(diaryDate);
              calculateDaysAfterBirth(diaryDate!);
            });
          });
        },
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              color: Colors.black54,
            ),
            const SizedBox(
              width: 5.0,
            ),
            Text(
              DateFormat('yyyy-MM-dd').format(diaryDate!).toString(),
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
