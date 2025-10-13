import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:word_guess/features/multi_player/controllers/select_word_page_controller.dart';
import 'package:word_guess/localization/home_page_strings.dart';
import 'package:word_guess/theme/app_colors.dart';

class XSelectWordPage extends StatelessWidget {
  XSelectWordPage({super.key});
  final _controller = Get.find<XSelectWordPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: Get.height),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                return Text(
                  textAlign: TextAlign.center,
                  _controller.opponentGuess.value,
                  style: Get.textTheme.displayMedium,
                );
              }),
              SizedBox(height: 20),
              Obx(() {
                return Visibility(
                  visible: _controller.isOpponentSelect.value,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'لقد قام الخصم باختيار الكلمة',
                        style: Get.textTheme.titleMedium,
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: 20),
              _buildGuessWordCard(),
              SizedBox(height: 15),
              _buildGameRolesCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuessWordCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildTimerWidget(60),
            Text(
              'ادخل الكلمة ليحزرها الخصم',
              textAlign: TextAlign.center,
              style: Get.textTheme.titleMedium!.copyWith(
                color: XAppColorsLight.primary_text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: TextFormField(
                maxLength: _controller.room?.wordLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,

                textAlign: TextAlign.center,
                style: Get.textTheme.bodyMedium,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _controller.submitWord(),
                controller: _controller.wordController,
                onChanged: (value) =>
                    _controller.isWordLengthError.value = false,
                decoration: InputDecoration(
                  helper: Obx(
                    () => _controller.isWordLengthError.value
                        ? Text(
                            'يجب ان يكون عدد حروف الكلمة ( ${_controller.room?.wordLength} ) حروف',
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

            ElevatedButton(
              onPressed: _controller.submitWord,

              child: Text('ارسل التخمين'),
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
              '${_controller.room?.wordLength}',
            ),
            _buildRoleWidget(
              "عدد محاولات لمعرفتها",
              '${_controller.room?.maxAttempts}',
            ),
            _buildRoleWidget("حالة الغرفة", '${_controller.room?.state.tr}'),
            _buildRoleWidget(
              "منشئ الغرفة",
              '${_controller.room?.creator.name}',
            ),
            _buildRoleWidget(
              "المنضم للغرفة",
              '${_controller.room?.joiner?.name}',
            ),
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
        Text(roleValue, style: Get.textTheme.titleSmall),
      ],
    );
  }

  Widget _buildTimerWidget(int seconds) {
    return TweenAnimationBuilder<double>(
      duration: Duration(seconds: seconds),
      tween: Tween(begin: 1.0, end: 0.0),
      onEnd: () {
        // _controller.submitRandomWord();
      },
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(value: value, strokeWidth: 8),
            ),
            Text('${(value * seconds).round()}'),
          ],
        );
      },
    );
  }
}
