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
      title: 'Icon Gallery',
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
  (TopoDeviceType.agent, 'Agent'),
  (TopoDeviceType.router, 'Router'),
  (TopoDeviceType.firewall, 'Firewall'),
  (TopoDeviceType.server, 'Server'),
  (TopoDeviceType.generic, 'Generic'),
  (TopoDeviceType.unknown, 'Unknown'),
  (TopoDeviceType.switchUnknown, 'Switch Unknown'),
];

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  bool _showError = false;
  double _iconSize = 80;
  TopoIconStyle _style = TopoIconStyle.flat;
  bool _portIsUp = true;
  bool _portIsDisabled = false;
  PortDirection _portDirection = PortDirection.up;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon Gallery'),
      ),
      body: Column(
        children: [
          // Controls bar
          _buildControls(),
          const Divider(height: 1),
          // Icon grid
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildGrid(),
                const SizedBox(height: 24),
                _buildPortSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          // Style toggle
          SegmentedButton<TopoIconStyle>(
            segments: const [
              ButtonSegment(value: TopoIconStyle.flat, label: Text('Flat')),
              ButtonSegment(value: TopoIconStyle.lnm, label: Text('LNM')),
            ],
            selected: {_style},
            onSelectionChanged: (v) => setState(() => _style = v.first),
          ),
          const SizedBox(width: 24),
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
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.0,
      children: _deviceTypes.map((entry) {
        final (deviceType, label) = entry;
        return _buildIconCard(deviceType, label);
      }).toList(),
    );
  }

  Widget _buildPortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 12),
        const Text(
          'Port (RJ45)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // Port state toggle
        Row(
          children: [
            const Text('State:', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'up', label: Text('Link Up')),
                ButtonSegment(value: 'down', label: Text('Link Down')),
                ButtonSegment(value: 'disabled', label: Text('Admin Down')),
              ],
              selected: {
                _portIsDisabled
                    ? 'disabled'
                    : _portIsUp
                        ? 'up'
                        : 'down',
              },
              onSelectionChanged: (v) {
                setState(() {
                  switch (v.first) {
                    case 'up':
                      _portIsUp = true;
                      _portIsDisabled = false;
                    case 'down':
                      _portIsUp = false;
                      _portIsDisabled = false;
                    case 'disabled':
                      _portIsDisabled = true;
                  }
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Port direction toggle
        Row(
          children: [
            const Text('Direction:', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 12),
            SegmentedButton<PortDirection>(
              segments: const [
                ButtonSegment(
                  value: PortDirection.up,
                  label: Text('Up'),
                ),
                ButtonSegment(
                  value: PortDirection.down,
                  label: Text('Down'),
                ),
                ButtonSegment(
                  value: PortDirection.left,
                  label: Text('Left'),
                ),
                ButtonSegment(
                  value: PortDirection.right,
                  label: Text('Right'),
                ),
              ],
              selected: {_portDirection},
              onSelectionChanged: (v) =>
                  setState(() => _portDirection = v.first),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Port icon card
        _buildPortCard(),
      ],
    );
  }

  Widget _buildPortCard() {
    final Color borderColor;
    if (_portIsDisabled) {
      borderColor = const Color(0xFF666666).withValues(alpha: 0.3);
    } else if (_portIsUp) {
      borderColor = const Color(0xFF27AE60).withValues(alpha: 0.3);
    } else {
      borderColor = const Color(0xFFAAAAAA).withValues(alpha: 0.3);
    }

    final stateLabel = _portIsDisabled
        ? 'Admin Down'
        : _portIsUp
            ? 'Link Up'
            : 'Link Down';

    return SizedBox(
      width: 200,
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: Size(_iconSize, _iconSize),
              painter: TopoPortPainter(
                isUp: _portIsUp,
                isDisabled: _portIsDisabled,
                style: _style,
                direction: _portDirection,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Port',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              stateLabel,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
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
              style: _style,
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
