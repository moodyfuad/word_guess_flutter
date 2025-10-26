import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:word_guess/features/single_player/controllers/single_player_page_controller.dart';
import 'package:word_guess/features/single_player/models/levels.dart';
import 'package:word_guess/routes/routes.dart';
import 'package:word_guess/theme/app_colors.dart';
import 'package:word_guess/widgets/key_board_widget.dart';
import 'package:word_guess/widgets/secondary_button.dart';

class XLevelsPage extends StatelessWidget {
  XLevelsPage({super.key});

  final _textController = TextEditingController();

  final controller = Get.find<XSinglePlayerPageController>();

  final _1ExpansibleController = ExpansibleController();
  final _2ExpansibleController = ExpansibleController();
  final _caruoselController = CarouselController();
  int _selectedLevel = 1;

  int _attempts = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('لعب فردي'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChallengeYourSelf(),
            SizedBox(height: 10),
            Expansible(
              headerBuilder: (context, animation) {
                return SecondaryButton(
                  'تحدى صديقك',
                  onPressed: () {
                    _2ExpansibleController.isExpanded
                        ? _2ExpansibleController.collapse()
                        : _2ExpansibleController.expand();
                    if (_1ExpansibleController.isExpanded) {
                      _1ExpansibleController.collapse();
                    }
                  },
                  trailingIcon: _1ExpansibleController.isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                );
              },
              bodyBuilder: (context, animation) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20,
                          top: 20,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 100,
                                maxWidth: Get.width * 0.8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      enabled: false,

                                      textAlign: TextAlign.center,
                                      controller: _textController,
                                      decoration: InputDecoration(
                                        labelText: 'اكتب الكلمة',
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      onFieldSubmitted: (value) {
                                        if (value.length > 2) {
                                          controller.startGame(
                                            word: value,
                                            attempts: _attempts,
                                          );
                                          Get.toNamed(XRoutes.singlePlayer);
                                        }
                                        controller.startGame(
                                          word: value,
                                          attempts: 6,
                                        );
                                        Get.toNamed(XRoutes.singlePlayer);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'عدد المحاولات',
                                          style: Get.textTheme.labelMedium,
                                        ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight: 70,
                                          ),
                                          child:
                                              ListWheelScrollView.useDelegate(
                                                itemExtent: 30,
                                                diameterRatio: 2,
                                                perspective: 0.009,
                                                overAndUnderCenterOpacity: 0.5,
                                                physics:
                                                    FixedExtentScrollPhysics(),
                                                onSelectedItemChanged: (value) {
                                                  _attempts = value + 1;
                                                },
                                                childDelegate:
                                                    ListWheelChildListDelegate(
                                                      children: List.generate(
                                                        30,
                                                        (index) => Text(
                                                          (index + 1)
                                                              .toString(),
                                                          style: Get
                                                              .textTheme
                                                              .titleLarge,
                                                        ),
                                                      ),
                                                    ),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    XKeyBoardWidget(
                      onKeyTap: (key) {
                        _textController.text += key;
                      },
                      onSummitTap: () {
                        final word = _textController.text;

                        if (word.length > 2) {
                          controller.startGame(
                            word: _textController.text,
                            attempts: _attempts,
                          );
                          Get.toNamed(XRoutes.singlePlayer);
                        }
                      },
                      onBackspaceTap: () {
                        final word = _textController.text;

                        if (word.isNotEmpty) {
                          _textController.text = word.substring(
                            0,
                            word.length - 1,
                          );
                        }
                      },
                    ),
                  ],
                );
              },
              expansibleBuilder: (context, header, body, animation) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    header,
                    FadeTransition(
                      opacity: animation,
                      alwaysIncludeSemantics: true,
                      child: body,
                    ),
                  ],
                );
              },
              controller: _2ExpansibleController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCarouselOptions({
    required XLevels value,
    required String label,
  }) {
    return Center(
      child: Text(
        label,
        style: Get.textTheme.titleSmall?.copyWith(
          color: XAppColorsLight.secondary_text,
        ),
      ),
    );
  }

  Widget _buildChallengeYourSelf() {
    return Expansible(
      headerBuilder: (context, animation) {
        return SecondaryButton(
          'تحدى نفسك',
          onPressed: () {
            _1ExpansibleController.isExpanded
                ? _1ExpansibleController.collapse()
                : _1ExpansibleController.expand();
            if (_2ExpansibleController.isExpanded) {
              _2ExpansibleController.collapse();
            }
          },
          trailingIcon: _1ExpansibleController.isExpanded
              ? Icons.expand_less_rounded
              : Icons.expand_more_rounded,
        );
      },
      bodyBuilder: (context, animation) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 100),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('حدد المستوى', style: Get.textTheme.bodyLarge),
                      // Spacer(),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 30,
                          diameterRatio: 2,
                          perspective: 0.009,
                          overAndUnderCenterOpacity: 0.5,
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (value) {
                            _selectedLevel = value + 1;
                          },
                          childDelegate: ListWheelChildListDelegate(
                            children: [
                              _buildLevelCarouselOptions(
                                value: XLevels.easy,
                                label: 'سهل',
                              ),
                              _buildLevelCarouselOptions(
                                value: XLevels.medium,
                                label: 'متوسط',
                              ),
                              _buildLevelCarouselOptions(
                                value: XLevels.hard,
                                label: 'صعب',
                              ),
                              _buildLevelCarouselOptions(
                                value: XLevels.extreme,
                                label: 'صعب جدا',
                              ),
                              _buildLevelCarouselOptions(
                                value: XLevels.legendary,
                                label: 'اسطوري',
                                // enabled: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SecondaryButton(
                  'تأكيد',
                  onPressed: () {
                    controller.startGame(level: _selectedLevel, attempts: 6);
                    Get.toNamed(XRoutes.singlePlayer);
                  },
                ),
              ],
            ),
          ),
        );
      },
      expansibleBuilder: (context, header, body, animation) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            header,
            FadeTransition(
              opacity: animation,
              alwaysIncludeSemantics: true,

              // sizeFactor: animation,
              // axisAlignment: -1.0,
              child: body,
            ),
          ],
        );
      },
      controller: _1ExpansibleController,
    );
  }
}
