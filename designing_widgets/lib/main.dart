import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormBuilderState>();
  String state = 'null';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              onChanged: () {
                _formKey.currentState!.save();
                setState(() {
                  state = _formKey.currentState!.value.toString();
                });
              },
              child: Column(
                children: [
                  const Text(
                    'Designing Display Edit Form Field',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'Name',
                    decoration: const InputDecoration(label: Text('Name')),
                  ),
                  const SizedBox(height: 16),
                  const FormBuilderSimpleDisplayEditTextField(
                    initialValue: 'Hello',
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  const FormBuilderDisplayEditTextField(
                    initialValue: 'New Element',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Text('Current State: $state'),
                ],
              )),
        ),
      ),
    );
  }
}

enum DisplayEditState {
  display,
  edit,
}

class FormBuilderSimpleDisplayEditTextField extends StatefulWidget {
  const FormBuilderSimpleDisplayEditTextField({
    required this.initialValue,
    this.maxLength = 15,
    this.width = 250,
    this.height = 50,
    this.color,
    super.key,
  });
  final String initialValue;
  final Color? color;
  final double width;
  final double height;
  final int maxLength;

  @override
  State<FormBuilderSimpleDisplayEditTextField> createState() =>
      _FormBuilderSimpleDisplayEditTextFieldState();
}

class _FormBuilderSimpleDisplayEditTextFieldState
    extends State<FormBuilderSimpleDisplayEditTextField> {
  DisplayEditState state = DisplayEditState.display;
  late String value = widget.initialValue;
  late final TextEditingController _controller =
      TextEditingController.fromValue(TextEditingValue(
    text: widget.initialValue,
    selection:
        TextSelection(baseOffset: 0, extentOffset: widget.initialValue.length),
  ));
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          state = DisplayEditState.display;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: widget.color,
          border: (state == DisplayEditState.edit) ? Border.all() : null,
          borderRadius: const BorderRadius.all(Radius.circular(2))),
      child: FormBuilderField<String>(
          initialValue: widget.initialValue,
          builder: (field) {
            switch (state) {
              case DisplayEditState.display:
                return Material(
                  color: widget.color,
                  elevation: 2,
                  child: InkWell(
                    onFocusChange: (hasFocus) => _toEditState(),
                    onTap: () => _toEditState(),
                    child: Center(child: Text(value)),
                  ),
                );
              case DisplayEditState.edit:
                return Center(
                  child: TextField(
                    decoration: null,
                    textAlign: TextAlign.center,
                    focusNode: _focusNode,
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    maxLength: widget.maxLength,
                    autofocus: true,
                    onChanged: (value) {
                      field.didChange(value);
                      if (this.value != value) {
                        setState(() {
                          this.value = value;
                        });
                      }
                    },
                    onEditingComplete: () {
                      _toDisplayState();
                    },
                    onSubmitted: (_) {
                      _toDisplayState();
                    },
                    onTapOutside: (_) {
                      _toDisplayState();
                    },
                  ),
                );
            }
          },
          name: 'Age'),
    );
  }

  void _toEditState() {
    setState(() {
      state = DisplayEditState.edit;
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: value.length);
      _focusNode.requestFocus();
    });
  }

  void _toDisplayState() {
    if (state != DisplayEditState.display) {
      setState(() {
        state = DisplayEditState.display;
      });
    }
  }
}

class FormBuilderDisplayEditTextField extends StatefulWidget {
  const FormBuilderDisplayEditTextField({
    required this.initialValue,
    this.maxLength = 250,
    this.maxLines = 1,
    this.width = 250,
    this.height = 50,
    this.color,
    super.key,
  });
  final String initialValue;
  final Color? color;
  final double width;
  final double height;
  final int maxLength;
  final int maxLines;

  @override
  State<FormBuilderDisplayEditTextField> createState() =>
      _FormBuilderDisplayEditTextFieldState();
}

class _FormBuilderDisplayEditTextFieldState
    extends State<FormBuilderDisplayEditTextField> {
  DisplayEditState state = DisplayEditState.display;
  late String value = widget.initialValue;
  late final TextEditingController _controller =
      TextEditingController.fromValue(TextEditingValue(
    text: widget.initialValue,
    selection:
        TextSelection(baseOffset: 0, extentOffset: widget.initialValue.length),
  ));
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          state = DisplayEditState.display;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: widget.color,
          border: (state == DisplayEditState.edit) ? Border.all() : null,
          borderRadius: const BorderRadius.all(Radius.circular(2))),
      child: FormBuilderField<String>(
          initialValue: widget.initialValue,
          builder: (field) {
            switch (state) {
              case DisplayEditState.display:
                return Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: widget.color,
                        elevation: 2,
                        child: Center(child: Text(value)),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _toEditState(),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                );
              case DisplayEditState.edit:
                return Center(
                  child: TextField(
                    maxLines: widget.maxLines,
                    decoration: null,
                    textAlign: TextAlign.center,
                    focusNode: _focusNode,
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    maxLength: widget.maxLength,
                    autofocus: true,
                    onChanged: (value) {
                      field.didChange(value);
                      if (this.value != value) {
                        setState(() {
                          this.value = value;
                        });
                      }
                    },
                    onEditingComplete: () {
                      _toDisplayState();
                    },
                    onSubmitted: (_) {
                      _toDisplayState();
                    },
                    onTapOutside: (_) {
                      _toDisplayState();
                    },
                  ),
                );
            }
          },
          name: 'Age'),
    );
  }

  void _toEditState() {
    setState(() {
      state = DisplayEditState.edit;
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: value.length);
      _focusNode.requestFocus();
    });
  }

  void _toDisplayState() {
    if (state != DisplayEditState.display) {
      setState(() {
        state = DisplayEditState.display;
      });
    }
  }
}
