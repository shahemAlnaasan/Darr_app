import 'package:flutter/material.dart';
import '../extentions/colors_extension.dart';
import 'package:toastification/toastification.dart';

class ToastificationDialog {
  static bool _isShowing = false;

  static void showToast({
    required String msg,
    required BuildContext context,
    ToastificationType type = ToastificationType.success,
    Duration? autoCloseDuration,
  }) {
    if (_isShowing) return;

    _isShowing = true;

    toastification.show(
      context: context,
      callbacks: ToastificationCallbacks(
        onDismissed: (_) => _isShowing = false,
        onAutoCompleteCompleted: (_) => _isShowing = false,
        onCloseButtonTap: (_) => _isShowing = false,
      ),
      title: Text(msg, maxLines: 3, textAlign: TextAlign.center),
      autoCloseDuration: autoCloseDuration ?? const Duration(milliseconds: 3000),
      animationDuration: const Duration(milliseconds: 150),
      applyBlurEffect: true,
      pauseOnHover: true,
      type: type,
      closeButton: ToastCloseButton(buttonBuilder: (context, onClose) => const SizedBox()),
      borderSide: const BorderSide(width: 0),
      margin: const EdgeInsets.all(14),
      showProgressBar: false,
      alignment: Alignment.center,
      showIcon: false,
      style: ToastificationStyle.flat,
    );
  }

  static void showLoading({required BuildContext context, String? message}) {
    if (_isShowing) return;

    _isShowing = true;

    toastification.show(
      context: context,
      callbacks: ToastificationCallbacks(
        onDismissed: (_) => _isShowing = false,
        onCloseButtonTap: (_) => _isShowing = false,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: context.onPrimaryColor),
          ),
          const SizedBox(width: 12),
          Flexible(child: Text(message ?? 'جاري التحميل...', maxLines: 2, textAlign: TextAlign.center)),
        ],
      ),
      autoCloseDuration: null, // Do not auto-dismiss
      animationDuration: const Duration(milliseconds: 150),
      applyBlurEffect: true,
      pauseOnHover: false,
      type: ToastificationType.info,
      closeButton: ToastCloseButton(buttonBuilder: (context, onClose) => const SizedBox()),
      borderSide: const BorderSide(width: 0),
      margin: const EdgeInsets.all(14),
      showProgressBar: false,
      alignment: Alignment.center,
      showIcon: false,
      style: ToastificationStyle.flat,
    );
  }

  static void dismiss() {
    if (_isShowing) {
      toastification.dismissAll();
      _isShowing = false;
    }
  }
}
