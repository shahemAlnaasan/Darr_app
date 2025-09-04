import 'package:exchange_darr/common/consts/app_keys.dart';
import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/extentions/size_extension.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/custom_progress_indecator.dart';
import 'package:exchange_darr/common/widgets/custom_text_field.dart';
import 'package:exchange_darr/common/widgets/large_button.dart';
import 'package:exchange_darr/core/datasources/hive_helper.dart';
import 'package:exchange_darr/features/prices/data/models/show_msg_response.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/add_msg_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/delete_msg_usecase.dart';
import 'package:exchange_darr/features/prices/presentation/bloc/prices_bloc.dart';
import 'package:exchange_darr/features/prices/presentation/widgets/confirm_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StatusMessagesContent extends StatefulWidget {
  const StatusMessagesContent({super.key});

  @override
  State<StatusMessagesContent> createState() => _StatusMessagesContentState();
}

class _StatusMessagesContentState extends State<StatusMessagesContent> {
  final _formKey = GlobalKey<FormState>();

  void _showDetailsDialog(BuildContext context, {void Function()? onPressed}) {
    final bloc = context.read<PricesBloc>();
    showDialog(
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: bloc,
          child: ConfirmDeleteDialog(onPressed: onPressed),
        );
      },
    );
  }

  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 20),
          buildTextField(hint: "ادخل الرسالة", controller: messageController),
          SizedBox(height: 20),
          BlocBuilder<PricesBloc, PricesState>(
            builder: (context, state) {
              return Row(
                children: [
                  Expanded(
                    child: LargeButton(
                      onPressed: state.addMsgStatus == Status.loading
                          ? () {}
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final int? id =
                                    await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.userId) ?? 0;
                                final AddMsgParams params = AddMsgParams(id: id!, msg: messageController.text);
                                context.read<PricesBloc>().add(AddMsgEvent(params: params));
                                messageController.clear();
                              }
                            },
                      text: "اضافة رسالة",
                      backgroundColor: context.primaryContainer,
                      circularRadius: 12,
                      child: state.addMsgStatus == Status.loading ? CustomProgressIndecator() : null,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: AppText.titleLarge(
              "الرسائل:",
              textAlign: TextAlign.right,
              fontWeight: FontWeight.bold,
              color: context.onPrimaryColor,
            ),
          ),
          SizedBox(height: 20),
          BlocBuilder<PricesBloc, PricesState>(
            builder: (context, state) {
              if (state.showMsgStatus == Status.loading || state.showMsgStatus == Status.initial) {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (context, index) => Skeletonizer(
                    enabled: true,
                    containersColor: const Color.fromARGB(99, 158, 158, 158),
                    enableSwitchAnimation: true,
                    child: _buildMessageContainer(title: "titlesadassdasdasdd", id: 0),
                  ),
                );
              }
              if (state.showMsgStatus == Status.success && state.showMsgResponse != null) {
                final List<Msg> messages = state.showMsgResponse!.msgs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageContainer(title: messages[index].msg, id: messages[index].id);
                  },
                );
              }

              if (state.showMsgStatus == Status.failure) {
                return Center(child: AppText.bodyLarge("لايوجد رسائل لعرضها", fontWeight: FontWeight.w400));
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required String hint,
    required TextEditingController controller,
    void Function(String)? onChanged,
    String validatorTitle = "",
    int mxLine = 1,
    Widget? sufIcon,
    bool? readOnly,
    dynamic Function()? onTap,
    TextInputType? keyboardType,
    bool needValidation = true,
    FocusNode? focusNode,
    FocusNode? focusOn,
    Widget? preIcon,
    bool? obSecure,
  }) {
    return CustomTextField(
      textAlign: TextAlign.start,
      onTap: onTap,
      readOnly: readOnly,
      preIcon: preIcon,
      obSecure: obSecure,
      onChanged: onChanged,
      keyboardType: keyboardType,
      mxLine: mxLine,
      controller: controller,
      hint: hint,
      focusNode: focusNode,
      focusOn: focusOn,
      filledColor: context.primaryColor,
      validator: needValidation
          ? (value) {
              if (value == null || value.isEmpty) {
                return validatorTitle.isNotEmpty ? validatorTitle : "لا يمكن للحقل ان يكون فارعاً";
              }
              return null;
            }
          : null,
      sufIcon: sufIcon,
    );
  }

  Widget _buildMessageContainer({required String title, required int id}) {
    return Container(
      width: context.screenWidth,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: context.primaryColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 5, offset: Offset(0, 4))],
      ),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: TextStyle(color: context.onPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showDetailsDialog(
                context,
                onPressed: () async {
                  final int? userId = await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.userId) ?? 0;
                  DeleteMsgParams params = DeleteMsgParams(id: id, userId: userId!);
                  context.read<PricesBloc>().add(DeleteMsgEvent(params: params));
                },
              );
            },
            child: Icon(Icons.delete_outline, color: context.onPrimaryColor, size: 25),
          ),
        ],
      ),
    );
  }
}
