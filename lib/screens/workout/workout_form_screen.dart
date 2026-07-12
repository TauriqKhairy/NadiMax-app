import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../models/workout_schedule_model.dart';

class WorkoutFormScreen extends StatefulWidget {
  final WorkoutScheduleModel? schedule;

  const WorkoutFormScreen({super.key, this.schedule});

  @override
  State<WorkoutFormScreen> createState() => _WorkoutFormScreenState();
}

class _WorkoutFormScreenState extends State<WorkoutFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedZone;
  bool _isCompleted = false;

  bool get _isEditMode => widget.schedule != null;

  final List<Map<String, String>> _zones = const [
    {'value': 'recovery', 'label': 'Recovery'},
    {'value': 'fat_burn', 'label': 'Fat Burn'},
    {'value': 'cardio', 'label': 'Cardio'},
    {'value': 'peak', 'label': 'Peak'},
    {'value': 'maximum', 'label': 'Maximum'},
  ];

  @override
  void initState() {
    super.initState();
    final s = widget.schedule;

    _titleController = TextEditingController(text: s?.title ?? '');
    _notesController = TextEditingController(text: s?.notes ?? '');
    _selectedZone = s?.trainingZone;
    _isCompleted = s?.isCompleted ?? false;

    if (s != null) {
      _selectedDate = DateTime.tryParse(s.scheduleDate);
      final startParts = s.startTime.split(':');
      _startTime = TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      );

      if (s.endTime != null) {
        final endParts = s.endTime!.split(':');
        _endTime = TimeOfDay(
          hour: int.parse(endParts[0]),
          minute: int.parse(endParts[1]),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _startTime : _endTime) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null || _startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal dan jam mulai wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = context.read<WorkoutProvider>();
    provider.clearError();

    final scheduleDateStr =
        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

    bool success;

    if (_isEditMode) {
      success = await provider.updateSchedule(widget.schedule!.id, {
        'title': _titleController.text.trim(),
        'schedule_date': scheduleDateStr,
        'start_time': _formatTimeOfDay(_startTime!),
        'end_time': _endTime != null ? _formatTimeOfDay(_endTime!) : null,
        'training_zone': _selectedZone,
        'notes': _notesController.text.isNotEmpty
            ? _notesController.text.trim()
            : null,
        'is_completed': _isCompleted,
      });
    } else {
      success = await provider.createSchedule(
        title: _titleController.text.trim(),
        scheduleDate: scheduleDateStr,
        startTime: _formatTimeOfDay(_startTime!),
        endTime: _endTime != null ? _formatTimeOfDay(_endTime!) : null,
        trainingZone: _selectedZone,
        notes: _notesController.text.isNotEmpty
            ? _notesController.text.trim()
            : null,
      );
    }

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Gagal menyimpan jadwal.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Jadwal' : 'Buat Jadwal Baru'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Latihan',
                    hintText: 'Misal: Lari Pagi',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Judul wajib diisi';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Tanggal
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Tanggal',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      _selectedDate != null
                          ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                          : 'Pilih tanggal',
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Jam Mulai & Selesai
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickTime(isStart: true),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Jam Mulai',
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(
                            _startTime != null
                                ? _formatTimeOfDay(_startTime!)
                                : '--:--',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickTime(isStart: false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Jam Selesai',
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(
                            _endTime != null
                                ? _formatTimeOfDay(_endTime!)
                                : '--:--',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Training Zone
                DropdownButtonFormField<String>(
                  value: _selectedZone,
                  decoration: const InputDecoration(
                    labelText: 'Training Zone (Opsional)',
                    prefixIcon: Icon(Icons.speed_outlined),
                  ),
                  items: _zones.map((zone) {
                    return DropdownMenuItem(
                      value: zone['value'],
                      child: Text(zone['label']!),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedZone = value),
                ),
                const SizedBox(height: 16),

                // Catatan
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Catatan (Opsional)',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.notes_outlined),
                  ),
                ),

                if (_isEditMode) ...[
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Tandai Selesai'),
                    value: _isCompleted,
                    activeColor: const Color(0xFFE53950),
                    onChanged: (value) => setState(() => _isCompleted = value),
                  ),
                ],

                const SizedBox(height: 24),
                Consumer<WorkoutProvider>(
                  builder: (context, provider, _) {
                    return ElevatedButton(
                      onPressed: provider.isLoading ? null : _handleSubmit,
                      child: provider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _isEditMode ? 'Simpan Perubahan' : 'Buat Jadwal',
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
