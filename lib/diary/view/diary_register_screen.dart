import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tiny_human_app/diary/model/diary_file_model.dart';
import 'package:tiny_human_app/diary/provider/diary_pagination_provider.dart';

import '../../common/component/alert_dialog.dart';
import '../../common/component/custom_long_text_form_field.dart';
import '../../common/constant/colors.dart';
import '../../common/constant/data.dart';
import '../../common/layout/default_layout.dart';
import '../model/sentence_request_model.dart';

class DiaryRegisterScreen extends ConsumerStatefulWidget {
  const DiaryRegisterScreen({super.key});

  @override
  ConsumerState<DiaryRegisterScreen> createState() =>
      _DiaryRegisterScreenState();
}

class _DiaryRegisterScreenState extends ConsumerState<DiaryRegisterScreen> {
  final dio = Dio();
  final GlobalKey<FormState> formKey = GlobalKey();
  int photoCurrentIndex = 0;

  // profile image
  final ImagePicker imagePicker = ImagePicker(); //ImagePicker 초기화
  XFile? pickedFile;
  List<XFile> pickedImages = [];
  String? pickedFilePath;

  // String? name;
  // String? nickname;

  int? daysAfterBirth;

  DateTime? diaryDate = DateTime.now();
  List<String> fileNames = [];
  String? sentence;
  String? accessToken;

  @override
  void initState() {
    super.initState();
    // initState에서는 async가 안되기 때문에 함수로 분리한다.
    checkToken();
    diaryDate = DateTime.now();
    calculateDaysAfterBirth(diaryDate!);
  }

  void checkToken() async {
    accessToken = (await storage.read(key: ACCESS_TOKEN_KEY))!;
  }

  void calculateDaysAfterBirth(DateTime selectedDate) {
    final birthday = DateTime(2022, 9, 27);
    daysAfterBirth = selectedDate.difference(birthday).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    final diaries = ref.watch(diaryPaginationProvider);

    return DefaultLayout(
      appBar: diaryAppBar(context),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                pickedImages.isEmpty
                    ? GestureDetector(
                        onTap: () async {
                          List<XFile> selectedImages = await uploadImages();
                          if (selectedImages!.isNotEmpty) {
                            print('selected image is not emtpy');
                          }

                          if ((pickedImages.length + selectedImages.length) >
                              5) {
                            throw const Expanded(
                                child: Text("사진은 5장까지만 선택이 가능합니다."));
                          }

                          setState(() {
                            pickedImages = selectedImages;
                            fileNames = pickedImages
                                .map((image) => image.name)
                                .toList();
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
                          if (selectedImages!.isNotEmpty) {
                            print('selected image is not emtpy');
                          }

                          if ((pickedImages.length + selectedImages.length) >
                              5) {
                            throw const Expanded(
                                child: Text("사진은 5장까지만 선택이 가능합니다."));
                          }

                          setState(() {
                            pickedImages = [...pickedImages, ...selectedImages];
                            fileNames = pickedImages
                                .map((image) => image.name)
                                .toList();
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width / 1.2,
                          width: MediaQuery.of(context).size.width / 1.2,
                          color: Colors.transparent,
                          child: _uploadPhotoCarousel(
                              MediaQuery.of(context).size.width / 1.2),
                        ),
                      ),
                const SizedBox(height: 20.0),
                Row(
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Form(
                    key: formKey,
                    child: diaryTextCard(1, 1),
                  ),
                ),
                registerDiaryActionButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<XFile>> uploadImages() async {
    print("Diary Image upload button is pressed.");
    List<XFile>? images = await imagePicker.pickMultipleMedia();
    print('selected images count: ${images.length}');
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

  Widget _uploadPhotoCarousel(double size) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
            items: pickedImages.map((image) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      image.path,
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
                        print('Delete Diary Photo');
                        setState(() {
                          pickedImages.removeAt(photoCurrentIndex);
                          fileNames =
                              pickedImages.map((image) => image.name).toList();
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
                    print("new index $index");
                    photoCurrentIndex = index;
                  });
                })),
        Positioned(
          bottom: 5.0,
          child: AnimatedSmoothIndicator(
            activeIndex: photoCurrentIndex,
            count: pickedImages.length,
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
  Widget diaryTextCard(int id, diaryLength) {
    return SizedBox(
      height: 250,
      child: CustomLongTextFormField(
        keyName: 'description_$id',
        // textEditingController: textEditingController,
        onSaved: (String? value) {
          sentence = value;
        },
        hintText: "아기의 오늘을 남겨주세요.",
        initialValue: '',
      ),
    );
  }

  SizedBox registerDiaryActionButton(BuildContext context) {
    return SizedBox(
      height: 46.0,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () async {
          // 서버에 요청을 보낸다.
          print('---------- Request to register diary ----------');
          print(accessToken);

          if (formKey.currentState == null) {
            return null;
          }

          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
          } else {
            return null;
          }

          print('daysAfterBirth');
          print(daysAfterBirth);
          final response = await dio.post(
            'http://$ip/api/v1/diaries',
            options: Options(headers: {
              'Authorization': 'Bearer $accessToken',
            }),
            data: {
              "userId": 1,
              "babyId": 1,
              "daysAfterBirth": daysAfterBirth,
              "likeCount": 0,
              "date": DateFormat('yyyy-MM-dd').format(diaryDate!).toString(),
              "sentences": [SentenceRequestModel(sentence: sentence!)],
              "files": fileNames
                  .map((fileName) => DiaryFileModel(fileName: fileName))
                  .toList(),
            },
          );

          if (response.statusCode != 201) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomAlertDialog(
                    title: '등록 실패',
                    content: '등록에 실패하였습니다. 잠시 후에 다시 시도해주세요.',
                    buttonText: '확인',
                  );
                });
          }

          List<String> preSignedUrls = (response.data['pictures'] as List)
              .map((pictureInfo) => pictureInfo['preSignedUrl'] as String)
              .toList();

          for (int i = 0; i < pickedImages.length; i++) {
            File file = File(pickedImages[i].path!);

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

          ref.read(diaryPaginationProvider.notifier).addDiary();

          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
        ),
        child: const Text(
          "등록 하기",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  AppBar diaryAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "기록을 남겨보아요",
        style: TextStyle(
          color: Colors.deepOrange,
          fontWeight: FontWeight.w800,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: PRIMARY_COLOR),
        onPressed: () => Navigator.of(context).pop(),
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

  TextButton registerActionButton(BuildContext context, String buttonText) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: PRIMARY_COLOR,
      ),
      child: Center(
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
