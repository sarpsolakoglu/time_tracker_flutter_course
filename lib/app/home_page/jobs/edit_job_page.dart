import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/models/job.dart';
import 'package:time_tracker_app/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key? key, required this.database, this.job})
      : super(key: key);

  final Database database;
  final Job? job;

  static Future<void> show(BuildContext context,
      {required Database database, Job? job}) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditJobPage(
        database: database,
        job: job,
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _ratePerHour;

  @override
  void initState() {
    super.initState();
    _name = widget.job?.name;
    _ratePerHour = widget.job?.ratePerHour;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        initialValue: _name,
        validator: (value) =>
            value?.isNotEmpty == true ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        onSaved: (value) => _ratePerHour = int.parse(value ?? "0"),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
      ),
    ];
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please use a different job name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(
            id: id,
            name: _name ?? '',
            ratePerHour: _ratePerHour ?? 0,
          );
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form?.validate() == true) {
      form?.save();
      return true;
    }
    return false;
  }
}
