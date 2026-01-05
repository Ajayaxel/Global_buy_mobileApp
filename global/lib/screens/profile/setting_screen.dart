import 'package:flutter/material.dart';
import 'package:global/widgets/gbtn.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Language & Region
  String _selectedLanguage = 'English';
  String _selectedTimeZone = 'Central Africa Time (CAT)';
  String _selectedDateFormat = 'dd/mm/yyyy';

  // Notifications
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  String _notificationType = 'All Notification';

  // Photo Quality
  String _photoQuality = 'Medium (Recommended)';

  final List<String> _languages = [
    'English',
    'French',
    'Spanish',
    'Portuguese',
  ];
  final List<String> _timeZones = [
    'Central Africa Time (CAT)',
    'East Africa Time (EAT)',
    'West Africa Time (WAT)',
    'UTC',
  ];
  final List<String> _dateFormats = ['dd/mm/yyyy', 'mm/dd/yyyy', 'yyyy-mm-dd'];
  final List<String> _notificationTypes = [
    'All Notification',
    'Important Only',
    'None',
  ];
  final List<String> _photoQualities = ['High', 'Medium (Recommended)', 'Low'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF6F6F6),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: isTablet ? 22 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: isTablet ? 24 : 5),

            // Language & Region Section
            _buildSectionHeader(
              'Language & Region',
              'App language and location settings',
              isTablet,
            ),
            SizedBox(height: isTablet ? 16 : 12),

            // Language & Region Container
            Container(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownItem(
                    label: 'Language',
                    value: _selectedLanguage,
                    items: _languages,
                    onChanged: (value) =>
                        setState(() => _selectedLanguage = value!),
                    isTablet: isTablet,
                  ),
                  SizedBox(height: isTablet ? 24 : 20),
                  _buildDropdownItem(
                    label: 'Time Zone',
                    value: _selectedTimeZone,
                    items: _timeZones,
                    onChanged: (value) =>
                        setState(() => _selectedTimeZone = value!),
                    isTablet: isTablet,
                  ),
                  SizedBox(height: isTablet ? 24 : 20),
                  _buildDropdownItem(
                    label: 'Date Format',
                    value: _selectedDateFormat,
                    items: _dateFormats,
                    onChanged: (value) =>
                        setState(() => _selectedDateFormat = value!),
                    isTablet: isTablet,
                  ),
                ],
              ),
            ),
            SizedBox(height: isTablet ? 24 : 20),

            // Notifications Section
            _buildSectionHeader(
              'Notifications',
              'Manage notification preferences',
              isTablet,
            ),
            SizedBox(height: isTablet ? 16 : 12),

            // Notifications Container
            Container(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSwitchItem(
                    title: 'Push Notifications',
                    subtitle: 'Receive push notifications',
                    value: _pushNotifications,
                    onChanged: (value) =>
                        setState(() => _pushNotifications = value),
                    isTablet: isTablet,
                  ),
                  Divider(
                    height: isTablet ? 20 : 16,
                    color: const Color(0xffEEEEEE),
                  ),
                  _buildSwitchItem(
                    title: 'Email Notifications',
                    subtitle: 'Receive email updates',
                    value: _emailNotifications,
                    onChanged: (value) =>
                        setState(() => _emailNotifications = value),
                    isTablet: isTablet,
                  ),
                  Divider(
                    height: isTablet ? 24 : 20,
                    color: const Color(0xffEEEEEE),
                  ),
                  _buildDropdownItem(
                    label: 'Notification Type',
                    value: _notificationType,
                    items: _notificationTypes,
                    onChanged: (value) =>
                        setState(() => _notificationType = value!),
                    isTablet: isTablet,
                  ),
                ],
              ),
            ),
            SizedBox(height: isTablet ? 24 : 20),

            // Photo Quality Section
            Text(
              'Photo Quality',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),

            Container(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo Quality Dropdown
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _photoQuality,
                      isExpanded: true,
                      isDense: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      items: _photoQualities.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _photoQuality = value!),
                    ),
                  ),
                  Divider(
                    height: isTablet ? 24 : 20,
                    color: const Color(0xffEEEEEE),
                  ),
                  // Storage Used
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Storage Used',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '245 MB of 1 GB',
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cache cleared successfully!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Clear Cache',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: isTablet ? 24 : 20),

            // Security Section
            _buildSectionHeader(
              'Security',
              'Manage security settings',
              isTablet,
            ),
            SizedBox(height: isTablet ? 16 : 12),

            Container(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  // TODO: Navigate to change password screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Change password coming soon!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                      size: isTablet ? 28 : 24,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isTablet ? 24 : 20),

            // Version Info
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 16,
                vertical: isTablet ? 16 : 12,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Version',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '1.0.0',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Last Updated',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'jan 1, 2026',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: isTablet ? 24 : 16),

            // Check For Update Button
            GBtn(
              text: 'Check For Update',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You are on the latest version!'),
                    backgroundColor: Color(0xff4CAF50),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            SizedBox(height: isTablet ? 40 : 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 20 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: isTablet ? 14 : 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildDropdownItem({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required bool isTablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          decoration: BoxDecoration(
            color: const Color(0xffF6F6F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isTablet,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xff4CAF50),
        ),
      ],
    );
  }
}
