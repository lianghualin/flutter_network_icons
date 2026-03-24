import 'package:flutter/material.dart';
import 'package:topology_view_icons/topology_view_icons.dart';

void main() {
  runApp(const IconGalleryApp());
}

class IconGalleryApp extends StatelessWidget {
  const IconGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flat Icon Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const GalleryPage(),
    );
  }
}

// All 9 device types with display names.
const _deviceTypes = [
  (TopoDeviceType.network, 'Network'),
  (TopoDeviceType.switch_, 'Switch'),
  (TopoDeviceType.host, 'Host'),
  (TopoDeviceType.dpu, 'DPU'),
  (TopoDeviceType.router, 'Router'),
  (TopoDeviceType.firewall, 'Firewall'),
  (TopoDeviceType.server, 'Server'),
  (TopoDeviceType.generic, 'Generic'),
  (TopoDeviceType.unknown, 'Unknown'),
];

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  bool _showError = false;
  double _iconSize = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flat Icon Gallery'),
      ),
      body: Column(
        children: [
          // Controls bar
          _buildControls(),
          const Divider(height: 1),
          // Icon grid
          Expanded(child: _buildGrid()),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          // Normal / Error toggle
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Normal')),
              ButtonSegment(value: true, label: Text('Error')),
            ],
            selected: {_showError},
            onSelectionChanged: (v) => setState(() => _showError = v.first),
          ),
          const SizedBox(width: 32),
          // Size slider
          const Text('Size:', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          SizedBox(
            width: 200,
            child: Slider(
              value: _iconSize,
              min: 32,
              max: 160,
              divisions: 16,
              label: '${_iconSize.round()}px',
              onChanged: (v) => setState(() => _iconSize = v),
            ),
          ),
          Text(
            '${_iconSize.round()}px',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: _deviceTypes.length,
      itemBuilder: (context, index) {
        final (deviceType, label) = _deviceTypes[index];
        return _buildIconCard(deviceType, label);
      },
    );
  }

  Widget _buildIconCard(TopoDeviceType deviceType, String label) {
    final borderColor = _showError
        ? const Color(0xFFE74C3C).withValues(alpha: 0.3)
        : const Color(0xFF4B7BEC).withValues(alpha: 0.3);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          CustomPaint(
            size: Size(_iconSize, _iconSize),
            painter: TopoIconPainter(
              deviceType: deviceType,
              isError: _showError,
            ),
          ),
          const SizedBox(height: 12),
          // Label
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Device type name
          Text(
            deviceType.name,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
