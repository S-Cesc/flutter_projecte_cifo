import 'package:flutter/material.dart';

// https://medium.com/@gadepalliaditya1998/editing-a-list-component-in-list-view-4aa1eea13088

class ListModel {
  String title;
  String subTitle;

  ListModel({
    required this.title,
    required this.subTitle,
  });
}

class EditableListTile extends StatefulWidget {
  final ListModel model;
  final Future<void> Function(ListModel listModel)? onChanged;
  const EditableListTile(
      {required Key key, required this.model, this.onChanged})
      : super(key: key);

  @override
  State<EditableListTile> createState() => _EditableListTileState();
}

class _EditableListTileState extends State<EditableListTile> {
  late ListModel model;
  late TextEditingController _titleEditingController,
      _subTitleEditingController;
  bool _isEditingMode = false;

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: titleWidget,
      subtitle: subTitleWidget,
      trailing: tralingButton,
    );
  }

  Widget get titleWidget {
    if (_isEditingMode) {
      _titleEditingController = TextEditingController(text: model.title);
      return TextField(
        controller: _titleEditingController,
      );
    } else {
      return Text(model.title);
    }
  }

  Widget get subTitleWidget {
    if (_isEditingMode) {
      _subTitleEditingController = TextEditingController(text: model.subTitle);
      return TextField(
        controller: _subTitleEditingController,
      );
    } else {
      return Text(model.subTitle);
    }
  }

  Widget get tralingButton {
    if (_isEditingMode) {
      return IconButton(
        icon: Icon(Icons.check),
        onPressed: saveChange,
      );
    } else {
      return IconButton(
        icon: Icon(Icons.edit),
        onPressed: _toggleMode,
      );
    }
  }

  void _toggleMode() {
    setState(() {
      _isEditingMode = !_isEditingMode;
    });
  }

  void saveChange() {
    model.title = _titleEditingController.text;
    model.subTitle = _subTitleEditingController.text;
    _toggleMode();
    widget.onChanged?.call(model);
  }
}
