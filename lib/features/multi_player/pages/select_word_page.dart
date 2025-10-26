import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/select_word_page_controller.dart';
import 'package:word_guess/localization/home_page_strings.dart';
import 'package:word_guess/theme/app_colors.dart';
import 'package:word_guess/widgets/key_board_widget.dart';
import 'package:word_guess/widgets/secondary_button.dart';

class XSelectWordPage extends StatelessWidget {
  XSelectWordPage({super.key});
  final _controller = Get.find<XSelectWordPageController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        _controller.handelPop();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text('اختر الكلمة'), centerTitle: true),
        body: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  return Visibility(
                    visible: _controller.isOpponentSelected.value,
                    child: Card(
                      margin: EdgeInsets.only(top: 15),
                      color: XAppColorsLight.success,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'لقد قام الخصم باختيار الكلمة',
                          style: Get.textTheme.titleMedium?.copyWith(),
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 20),
                _buildGuessWordCard(),
                SizedBox(height: 15),
                Obx(() {
                  return Visibility(
                    visible: !_controller.isMyWordSelected.value,
                    child: XKeyBoardWidget(
                      onKeyTap: (key) {
                        if (_controller.wordController.text.length <
                            _controller.room.wordLength) {
                          _controller.wordController.text += key;
                        }
                      },
                      onSummitTap: _controller.submitWord,
                      onBackspaceTap: () {
                        String word = _controller.wordController.text;
                        if (word.isNotEmpty) {
                          word = word.substring(0, word.length - 1);
                        }
                        _controller.wordController.text = word;
                      },
                    ),
                  );
                }),
                SizedBox(height: 15),
                _buildGameRolesCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuessWordCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8.0),
        child: Column(
          children: [
            _buildTimerWidget(60),
            Text(
              'ادخل الكلمة ليحزرها الخصم',
              textAlign: TextAlign.center,
              style: Get.textTheme.titleMedium,
            ),
            Obx(() {
              return Visibility(
                visible: !_controller.isMyWordSelected.value,
                child: Text(
                  'اذا لم تختر كلمة في الوقت المحدد سيتم اختيار كلمة عشوائية عند انتهاء العد ',
                  textAlign: TextAlign.center,
                  style: Get.textTheme.labelMedium!.copyWith(
                    color: XAppColorsLight.danger,
                  ),
                ),
              );
            }),
            Obx(() {
              return Visibility(
                visible:
                    _controller.isMyWordSelected.value &&
                    !_controller.isOpponentSelected.value,
                child: Text(
                  'في انتظار اختيار الخصم للكلمة ...',
                  textAlign: TextAlign.center,
                  style: Get.textTheme.labelMedium!.copyWith(
                    color: XAppColorsLight.info,
                  ),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: TextFormField(
                readOnly: true,
                maxLength: _controller.room.wordLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textAlign: TextAlign.center,
                style: Get.textTheme.titleLarge,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _controller.submitWord(),
                controller: _controller.wordController,
                decoration: InputDecoration(
                  helper: Obx(
                    () => _controller.isMyWordSelected.value
                        ? Text(
                            'يجب ان يكون عدد حروف الكلمة ( ${_controller.room.wordLength} ) حروف',
                            style: Get.textTheme.labelSmall!.copyWith(
                              fontSize: 15,
                              color: XAppColorsLight.danger,
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameRolesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              XHomePageStrings.gameRoles.tr,
              textAlign: TextAlign.center,
              style: Get.textTheme.titleMedium,
            ),
            SizedBox(height: 15),

            _buildRoleWidget(
              "عدد حروف الكلمة",
              '${_controller.room.wordLength}',
            ),
            _buildRoleWidget(
              "عدد محاولات لمعرفتها",
              '${_controller.room.maxAttempts}',
            ),
            _buildRoleWidget("حالة الغرفة", _controller.room.state.tr),
            _buildRoleWidget("منشئ الغرفة", _controller.creator.name),
            _buildRoleWidget("المنضم للغرفة", _controller.joiner.name),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleWidget(String name, String roleValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: Get.textTheme.titleSmall),
        Text(roleValue.tr, style: Get.textTheme.titleSmall),
      ],
    );
  }

  Widget _buildTimerWidget(int seconds) {
    return Obx(
      () => Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: _controller.seconds.value / seconds,
              strokeWidth: 8,
              strokeCap: StrokeCap.round,
            ),
          ),
          Text(
            '${(_controller.seconds.value).round()}',
            style: Get.textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}
