import 'package:flutter/material.dart';
import 'device_type.dart';
import 'icon_colors.dart';
import 'icon_style.dart';
import 'shapes/network_shape.dart';
import 'shapes/switch_shape.dart';
import 'shapes/host_shape.dart';
import 'shapes/dpu_shape.dart';
import 'shapes/router_shape.dart';
import 'shapes/firewall_shape.dart';
import 'shapes/server_shape.dart';
import 'shapes/generic_shape.dart';
import 'shapes/unknown_shape.dart';
import 'shapes/switch_unknown_shape.dart';
import 'shapes_lnm/network_lnm.dart';
import 'shapes_lnm/switch_lnm.dart';
import 'shapes_lnm/host_lnm.dart';
import 'shapes_lnm/dpu_lnm.dart';
import 'shapes_lnm/router_lnm.dart';
import 'shapes_lnm/firewall_lnm.dart';
import 'shapes_lnm/server_lnm.dart';
import 'shapes_lnm/generic_lnm.dart';
import 'shapes_lnm/unknown_lnm.dart';
import 'shapes_lnm/switch_unknown_lnm.dart';

class TopoIconPainter extends CustomPainter {
  final TopoDeviceType deviceType;
  final bool isError;
  final TopoIconStyle style;

  const TopoIconPainter({
    required this.deviceType,
    this.isError = false,
    this.style = TopoIconStyle.flat,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // Add padding
    final padded = rect.deflate(size.width * 0.05);

    switch (style) {
      case TopoIconStyle.flat:
        _paintFlat(canvas, padded);
      case TopoIconStyle.lnm:
        _paintLnm(canvas, padded);
    }
  }

  void _paintFlat(Canvas canvas, Rect padded) {
    final stroke =
        isError ? TopoIconColors.errorStroke : TopoIconColors.normalStroke;
    final fill =
        isError ? TopoIconColors.errorFill : TopoIconColors.normalFill;

    switch (deviceType) {
      case TopoDeviceType.network:
        paintNetworkIcon(canvas, padded, stroke, fill);
      case TopoDeviceType.switch_:
        paintSwitchIcon(canvas, padded, stroke, fill);
      case TopoDeviceType.host:
        paintHostIcon(canvas, padded, stroke, fill);
      case TopoDeviceType.dpu:
        paintDpuIcon(canvas, padded, stroke, fill);
      case TopoDeviceType.router:
        paintRouterIcon(canvas, padded, stroke, fill);
      case TopoDeviceType.firewall:
        paintFirewallIcon(canvas, padded, stroke, fill);
      case TopoDeviceType.server:
        paintServerIcon(canvas, padded, stroke, fill);
      case TopoDeviceType.generic:
        paintGenericIcon(canvas, padded, stroke, fill);
      case TopoDeviceType.unknown:
        paintUnknownIcon(canvas, padded, stroke, fill);
      case TopoDeviceType.switchUnknown:
        paintSwitchUnknownIcon(canvas, padded, stroke, fill);
    }
  }

  void _paintLnm(Canvas canvas, Rect padded) {
    switch (deviceType) {
      case TopoDeviceType.network:
        paintNetworkLnmIcon(canvas, padded, isError);
      case TopoDeviceType.switch_:
        paintSwitchLnmIcon(canvas, padded, isError);
      case TopoDeviceType.host:
        paintHostLnmIcon(canvas, padded, isError);
      case TopoDeviceType.dpu:
        paintDpuLnmIcon(canvas, padded, isError);
      case TopoDeviceType.router:
        paintRouterLnmIcon(canvas, padded, isError);
      case TopoDeviceType.firewall:
        paintFirewallLnmIcon(canvas, padded, isError);
      case TopoDeviceType.server:
        paintServerLnmIcon(canvas, padded, isError);
      case TopoDeviceType.generic:
        paintGenericLnmIcon(canvas, padded, isError);
      case TopoDeviceType.unknown:
        paintUnknownLnmIcon(canvas, padded, isError);
      case TopoDeviceType.switchUnknown:
        paintSwitchUnknownLnmIcon(canvas, padded, isError);
    }
  }

  @override
  bool shouldRepaint(covariant TopoIconPainter oldDelegate) {
    return oldDelegate.deviceType != deviceType ||
        oldDelegate.isError != isError ||
        oldDelegate.style != style;
  }
}
