import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tiny_human_app/diary/provider/diary_pagination_provider.dart';
import 'package:tiny_human_app/helpchat/enum/chat_request_type.dart';

import '../../common/component/custom_long_text_form_field.dart';
import '../../common/constant/colors.dart';
import '../../common/constant/data.dart';
import '../../common/layout/default_layout.dart';

class HelpChatRequestScreen extends ConsumerStatefulWidget {
  const HelpChatRequestScreen({super.key});

  @override
  ConsumerState<HelpChatRequestScreen> createState() => _DiaryRegisterScreenState();
}

class _DiaryRegisterScreenState extends ConsumerState<HelpChatRequestScreen> {
  final dio = Dio();
  final GlobalKey<FormState> formKey = GlobalKey();
  int photoCurrentIndex = 0;

  // profile image
  final ImagePicker imagePicker = ImagePicker(); //ImagePicker 초기화
  XFile? pickedFile;
  List<XFile> pickedImages = [];
  String? pickedFilePath;
  int? daysAfterBirth;
  DateTime? diaryDate = DateTime.now();
  List<String> fileNames = [];
  String? sentence;
  String? accessToken;

  ChatRequestType chatRequestType = ChatRequestType.random;

  @override
  void initState() {
    super.initState();
    checkToken();
    diaryDate = DateTime.now();
    calculateDaysAfterBirth(diaryDate!);
  }

  void checkToken() async {
    accessToken = (await storage.read(key: ACCESS_TOKEN_KEY))!;
  }

  void calculateDaysAfterBirth(DateTime selectedDate) {
    // TODO: After Baby Provider
    final birthday = DateTime(2022, 9, 27);
    daysAfterBirth = selectedDate.difference(birthday).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: _helpChatAppBar(context),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('어떤 사용자에게 도움을 요청할까요?',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          )),
                      _buildRadioListTile(ChatRequestType.random),
                      _buildRadioListTile(ChatRequestType.locationBased),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
                const Text('채팅을 원하는 내용을 적어주세요.',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(
                  height: 16.0,
                ),
                Column(
                  children: [
                    _selectedImageCarousel(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Form(
                        key: formKey,
                        child: _chatDescriptionTextForm(1, 1),
                      ),
                    ),
                  ],
                ),
                _requestChatActionButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _selectedImageCarousel(BuildContext context) {
    return pickedImages.isEmpty
        ? GestureDetector(
            onTap: () async {
              List<XFile> selectedImages = await uploadImages();

              if ((pickedImages.length + selectedImages.length) > 5) {
                throw const Expanded(child: Text("사진은 5장까지만 선택이 가능합니다."));
              }

              setState(() {
                pickedImages = selectedImages;
                fileNames = pickedImages.map((image) => image.name).toList();
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                height: MediaQuery.of(context).size.width / 2,
                width: MediaQuery.of(context).size.width / 2,
                color: Colors.deepOrange.shade500,
                child: _uploadPhotoLabel(),
              ),
            ),
          )
        : GestureDetector(
            onTap: () async {
              List<XFile> selectedImages = await uploadImages();

              if ((pickedImages.length + selectedImages.length) > 5) {
                throw const Expanded(child: Text("사진은 5장까지만 선택이 가능합니다."));
              }

              setState(() {
                pickedImages = [...pickedImages, ...selectedImages];
                fileNames = pickedImages.map((image) => image.name).toList();
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                height: MediaQuery.of(context).size.width / 2,
                width: MediaQuery.of(context).size.width / 2,
                color: Colors.transparent,
                child: _uploadPhotoCarousel(MediaQuery.of(context).size.width / 2),
              ),
            ),
          );
  }

  Widget _buildRadioListTile(ChatRequestType selectedChatRequestType) {
    return Theme(
      data: Theme.of(context).copyWith(
        radioTheme: const RadioThemeData(
          visualDensity: VisualDensity.compact, // 더 콤팩트한 UI
        ),
      ),
      child: RadioListTile<ChatRequestType>(
        activeColor: PRIMARY_COLOR,
        contentPadding: EdgeInsets.zero,
        fillColor: MaterialStateColor.resolveWith((states) => PRIMARY_COLOR),
        title: Text(selectedChatRequestType.displayName,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            )),
        subtitle: Text(
          selectedChatRequestType.description,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        value: selectedChatRequestType,
        groupValue: chatRequestType,
        onChanged: (ChatRequestType? value) {
          setState(() {
            chatRequestType = value!;
          });
        },
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
          size: 60.0,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "사진을 선택해주세요.",
          style: TextStyle(
            fontSize: 16.0,
          ),
          textAlign: TextAlign.center,
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
                        setState(() {
                          pickedImages.removeAt(photoCurrentIndex);
                          fileNames = pickedImages.map((image) => image.name).toList();
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
  Widget _chatDescriptionTextForm(int id, diaryLength) {
    return SizedBox(
      height: 250,
      child: CustomLongTextFormField(
        keyName: 'chat_description_$id',
        onSaved: (String? value) {
          sentence = value;
        },
        hintText: "어떤 도움이 필요하신가요? 자세하게 적어주실수록 구체적인 답변을 얻을 수 있습니다.",
        initialValue: '',
      ),
    );
  }

  SizedBox _requestChatActionButton(BuildContext context) {
    return SizedBox(
      height: 46.0,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState == null) {
            return;
          }
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
          } else {
            return;
          }

          if (mounted) {
            Navigator.of(context).pop();
          }

          ref.read(diaryPaginationProvider.notifier).refreshPagination();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
        ),
        child: const Text(
          "채팅 요청하기",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  AppBar _helpChatAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "채팅을 생성하세요",
        style: TextStyle(
          color: Colors.deepOrange,
          fontWeight: FontWeight.w800,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: PRIMARY_COLOR),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0.0,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
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
