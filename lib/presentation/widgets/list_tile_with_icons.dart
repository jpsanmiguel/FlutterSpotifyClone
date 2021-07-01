import 'package:flutter/material.dart';
import 'package:spotify_clone/constants/colors.dart';

class ListTileWithIcons extends StatefulWidget {
  final String title;
  final String subtitle;
  final Icon leadingIcon;
  final Icon trailingIcon;
  final Icon editingIcon;

  const ListTileWithIcons({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.leadingIcon,
    @required this.trailingIcon,
    @required this.editingIcon,
  }) : super(key: key);

  @override
  _ListTileWithIconsState createState() => _ListTileWithIconsState(
        title: title,
        subtitle: subtitle,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        editingIcon: editingIcon,
      );
}

class _ListTileWithIconsState extends State<ListTileWithIcons> {
  final String title;
  final String subtitle;
  final Icon leadingIcon;
  final Icon trailingIcon;
  final Icon editingIcon;

  var editing = false;
  var _editTextController = TextEditingController();

  _ListTileWithIconsState({
    @required this.title,
    @required this.subtitle,
    @required this.leadingIcon,
    @required this.trailingIcon,
    @required this.editingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.leadingIcon,
        ],
      ),
      title: !editing
          ? Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                color: textColor.shade900,
              ),
            )
          : _editField(),
      subtitle: !editing
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 16.0,
                color: textColor,
              ),
            )
          : Container(),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: editing ? editingIcon : trailingIcon,
            onPressed: () {
              setState(() {
                editing = !editing;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _editField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(
          fontSize: 18.0,
          color: textColor.shade900,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: whiteColor,
            width: 5.0,
          ),
        ),
      ),
      controller: _editTextController,
      style: TextStyle(
        fontSize: 16.0,
        color: textColor,
      ),
      onChanged: (text) {
        print(text);
      },
      validator: (text) {
        return "";
      },
      keyboardType: TextInputType.name,
    );
  }

  @override
  void initState() {
    super.initState();
    _editTextController.text = subtitle;
  }
}
