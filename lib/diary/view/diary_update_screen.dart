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
import 'package:tiny_human_app/diary/model/date_request_model.dart';
import 'package:tiny_human_app/diary/model/diary_file_model.dart';
import 'package:tiny_human_app/diary/model/diary_picture_model.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';
import 'package:tiny_human_app/diary/model/diary_sentence_model.dart';
import 'package:tiny_human_app/diary/model/sentence_request_model.dart';
import 'package:tiny_human_app/diary/provider/diary_pagination_provider.dart';

import '../../baby/model/baby_model.dart';
import '../../baby/provider/baby_provider.dart';
import '../../common/component/alert_dialog.dart';
import '../../common/component/custom_long_text_form_field.dart';
import '../../common/constant/colors.dart';
import '../../common/constant/data.dart';
import '../../common/layout/default_layout.dart';
import '../../common/utils/date_convertor.dart';
import '../../common/utils/s3_url_generator.dart';
import '../model/diary_response_with_presigned_model.dart';
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

  DiaryResponseModel? diaryResponseModel;

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async {
    accessToken = (await storage.read(key: ACCESS_TOKEN_KEY))!;
  }

  void calculateDaysAfterBirth(BabyModel baby, DateTime selectedDate) {
    final birthday = DateConvertor.stringToDateTime(baby.dayOfBirth);
    daysAfterBirth = selectedDate.difference(birthday!).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    final babyId = ref.watch(selectedBabyProvider);
    final babies = ref.watch(babyProvider);
    final selectedBaby = babies.where((baby) => baby.id == babyId).first;
    final diaryState = ref.watch(diaryDetailProvider(widget.id));

    if (diaryState == null) {
      return const DefaultLayout(
          child: Center(
              child: CircularProgressIndicator(
        color: PRIMARY_COLOR,
      )));
    }

    if (saveModels.isEmpty) {
      for (var picture in diaryState.pictures) {
        saveModels.add(PhotoWithSaveTypeModel(id: picture.id, type: SaveType.URL, path: picture.keyName));
      }
    }

    // base data
    baseDiaryDate = diaryState.date;
    baseDaysAfterBirth = diaryState.daysAfterBirth;
    baseFiles = diaryState.pictures;
    baseSentence = diaryState.sentences;

    calculateDaysAfterBirth(selectedBaby, diaryDate ?? baseDiaryDate!);

    return DefaultLayout(
      appBar: _diaryAppBar(context),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _diaryImageCarousel(context, saveModels, deletedFiles),
                const SizedBox(height: 20.0),
                _diaryDate(context, selectedBaby),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Form(
                    key: formKey,
                    child: _diaryTextCard(1, 1, diaryState.sentences.first),
                  ),
                ),
                _updateDiaryActionButton(context, diaryState, saveModels, deletedFiles),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _diaryDate(BuildContext context, BabyModel selectedBaby) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _datePickerButton(context, selectedBaby),
        const SizedBox(width: 14.0),
        Text(
          '+${(daysAfterBirth ?? baseDaysAfterBirth).toString()}일',
          style: const TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  GestureDetector _diaryImageCarousel(
      BuildContext context, List<PhotoWithSaveTypeModel> models, List<PhotoWithSaveTypeModel> deletedFiles) {
    return models.isEmpty
        ? GestureDetector(
            onTap: () async {
              List<XFile> selectedImages = await uploadImages();
              if ((models.length + selectedImages.length) > 5) {
                throw const Expanded(child: Text("사진은 5장까지만 선택이 가능합니다."));
              }

              setState(() {
                List<PhotoWithSaveTypeModel> temp = selectedImages.map((image) {
                  return PhotoWithSaveTypeModel(type: SaveType.LOCAL, path: image.path, name: image.name);
                }).toList();

                saveModels = [
                  ...models,
                  ...temp,
                ];
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.width / 1.2,
              width: MediaQuery.of(context).size.width / 1.2,
              color: Colors.deepOrange.shade500,
              child: _uploadPhotoLabel(),
            ),
          )
        : GestureDetector(
            onTap: () async {
              List<XFile> selectedImages = await uploadImages();
              if ((models.length + selectedImages.length) > 5) {
                throw const Expanded(child: Text("사진은 5장까지만 선택이 가능합니다."));
              }

              setState(() {
                List<PhotoWithSaveTypeModel> temp = selectedImages.map((image) {
                  return PhotoWithSaveTypeModel(type: SaveType.LOCAL, path: image.path, name: image.name);
                }).toList();

                // 여기서 setState를 하니까 위젯이 다시 빌드되고 이미지는 다시 1개가 된다...
                saveModels = [
                  ...models,
                  ...temp,
                ];
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.width / 1.2,
              width: MediaQuery.of(context).size.width / 1.2,
              color: Colors.transparent,
              child: _uploadPhotoCarousel(MediaQuery.of(context).size.width / 1.2, models, deletedFiles),
            ),
          );
  }

  Future<List<XFile>> uploadImages() async {
    List<XFile>? images = await imagePicker.pickMultipleMedia();
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

  Widget _uploadPhotoCarousel(
      double size, List<PhotoWithSaveTypeModel> models, List<PhotoWithSaveTypeModel> deletedFiles) {
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
                            S3UrlGenerator.getThumbnailUrlWith1000wh(image.path),
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
                          PhotoWithSaveTypeModel deleteModel = models.removeAt(photoCurrentIndex);
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
                enableInfiniteScroll: false,
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
  Widget _diaryTextCard(int id, diaryLength, DiarySentenceModel originalSentence) {
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

  SizedBox _updateDiaryActionButton(BuildContext context, DiaryResponseModel state, List<PhotoWithSaveTypeModel> models,
      List<PhotoWithSaveTypeModel> deletedFiles) {
    return SizedBox(
      height: 46.0,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        child: const Text(
          "수정 하기",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        onPressed: () async {
          if (formKey.currentState == null) {
            return;
          }
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
          } else {
            return;
          }

          int diaryId = state.id;

          // 기존 데이터와 비교해서 달라졌으면 Patch 요청
          // TODO sentence onSaved 함수로 이동
          if (isSentenceChanged()) {
            print("일기 글(${state.sentences.first.id})이 수정됨.");
            ref.read(diaryPaginationProvider.notifier).updateSentence(
                diaryId: diaryId,
                sentenceId: state.sentences.first.id,
                model: SentenceRequestModel(sentence: sentence!));
          }

          // 날짜가 수정된 경우
          if (isDateChanged()) {
            print("날짜가 수정됨.");
            ref
                .read(diaryPaginationProvider.notifier)
                .updateDate(diaryId: diaryId, model: DateRequestModel(updatedDate: diaryDate!));
          }

          // 시간이 수정된 경우

          // 기존에 삭제된 이미지는 서버에 삭제 요청
          for (var deletedFile in deletedFiles) {
            print("삭제 이미지 존재");
            ref.read(diaryPaginationProvider.notifier).deleteImages(diaryId: diaryId, imageId: deletedFile.id!);
          }

          // 이미지는 새로 업로드된 이미지만 수정
          List<PhotoWithSaveTypeModel> newImages = models.where((image) => image.type == SaveType.LOCAL).toList();

          if (newImages.isNotEmpty) {
            print("신규 이미지 존재");
            DiaryResponseWithPresignedModel preSignedUrlResponse =
                await ref.read(diaryPaginationProvider.notifier).addImages(
                      diaryId: diaryId,
                      diaryFileModels: newImages.map((image) => DiaryFileModel(fileName: image.name!)).toList(),
                    );

            List<String> preSignedUrls = preSignedUrlResponse.pictures
                .where((e) => e.preSignedUrl != null)
                .map((res) => res.preSignedUrl!)
                .toList();

            List<PhotoWithSaveTypeModel> localImages = models.where((model) => model.type == SaveType.LOCAL).toList();

            for (int i = 0; i < localImages.length; i++) {
              File file = File(localImages[i].path);
              String? mimeType = lookupMimeType(file.path);
              try {
                await dio.put(preSignedUrls[i],
                    data: file.openRead(),
                    options: Options(
                      headers: {
                        Headers.contentLengthHeader: file.lengthSync(),
                      },
                      contentType: mimeType,
                    ));
              } catch (e) {
                if (mounted) {
                  _showDialogWhenResponseFail(context);
                }
              }
            }
          }
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
        ),
      ),
    );
  }

  void _showDialogWhenResponseFail(BuildContext context) {
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

  bool isDateChanged() {
    if (diaryDate == null) {
      return false;
    }
    return baseDiaryDate != diaryDate;
  }

  bool isSentenceChanged() => baseSentence.first.sentence != sentence;

  AppBar _diaryAppBar(BuildContext context) {
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
      elevation: 0.0,
    );
  }

  Widget _datePickerButton(BuildContext context, BabyModel selectedBaby) {
    return SizedBox(
      height: 46.0,
      child: OutlinedButton(
        onPressed: () {
          showDatePicker(
            context: context,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDate: baseDiaryDate,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          ).then((value) {
            setState(() {
              diaryDate = value;
              calculateDaysAfterBirth(selectedBaby, diaryDate!);
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
              DateFormat('yyyy-MM-dd').format(diaryDate ?? baseDiaryDate!).toString(),
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
