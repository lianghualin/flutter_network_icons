import 'package:flutter/material.dart';
import 'device_type.dart';
import 'icon_colors.dart';
import 'shapes/network_shape.dart';
import 'shapes/switch_shape.dart';
import 'shapes/host_shape.dart';
import 'shapes/dpu_shape.dart';
import 'shapes/router_shape.dart';
import 'shapes/firewall_shape.dart';
import 'shapes/server_shape.dart';
import 'shapes/generic_shape.dart';
import 'shapes/unknown_shape.dart';

class TopoIconPainter extends CustomPainter {
  final TopoDeviceType deviceType;
  final bool isError;

  const TopoIconPainter({
    required this.deviceType,
    this.isError = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // Add padding
    final padded = rect.deflate(size.width * 0.05);
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
    }
  }

  @override
  bool shouldRepaint(covariant TopoIconPainter oldDelegate) {
    return oldDelegate.deviceType != deviceType ||
        oldDelegate.isError != isError;
  }
}
