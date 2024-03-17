import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/helpchat/enum/chat_request_type.dart';
import 'package:tiny_human_app/helpchat/model/helprequest_create_model.dart';

import '../../common/component/custom_long_text_form_field.dart';
import '../../common/constant/colors.dart';
import '../../common/constant/data.dart';
import '../../common/layout/default_layout.dart';
import '../../user/model/user_model.dart';
import '../../user/provider/user_me_provider.dart';
import '../provider/help_request_provider.dart';

class HelpRequestRegisterScreen extends ConsumerStatefulWidget {
  const HelpRequestRegisterScreen({super.key});

  @override
  ConsumerState<HelpRequestRegisterScreen> createState() => _DiaryRegisterScreenState();
}

class _DiaryRegisterScreenState extends ConsumerState<HelpRequestRegisterScreen> {
  final dio = Dio();
  final GlobalKey<FormState> formKey = GlobalKey();
  String? accessToken;
  String? requestContents;

  ChatRequestType chatRequestType = ChatRequestType.KEYWORD;

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
    return DefaultLayout(
      appBar: _helpChatAppBar(context),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 24.0, right: 24.0),
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
                      _buildRadioListTile(ChatRequestType.KEYWORD),
                      _buildRadioListTile(ChatRequestType.LOCATION),
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
                Form(
                  key: formKey,
                  child: _chatDescriptionTextForm(1, 1),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                _requestChatActionButton(context),
              ],
            ),
          ),
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

  // 입력 폼 위젯 생성
  Widget _chatDescriptionTextForm(int id, diaryLength) {
    return SizedBox(
      height: 350,
      child: CustomLongTextFormField(
        keyName: 'chat_description_$id',
        onSaved: (String? value) {
          requestContents = value;
        },
        maxLength: 500,
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

          // ChecklistCreateModel checklistCreateModel = ChecklistCreateModel(
          //   title: title,
          //   checklistDetailCreate: checklistDetails,
          // );
          //
          // ref.read(checklistProvider.notifier).addChecklist(checklistCreateModel);

          UserModel user = await ref.read(userMeProvider.notifier).getMe();
          final helpChatCreateModel = HelpRequestCreateModel(
              userId: user.id, requestType: chatRequestType.name, contents: requestContents ?? '');

          ref.read(helpRequestProvider.notifier).addHelpRequest(helpChatCreateModel);

          if (mounted) {
            Navigator.of(context).pop();
          }
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
