import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/logic/bloc/profile/profile_bloc.dart';

class ListTileWithTextField extends StatefulWidget {
  final String title;
  final String subtitle;
  final Icon leadingIcon;
  final Icon trailingIcon;
  final Icon editingIcon;
  final Function saveFunction;
  final Function onChangedFunction;
  final Function validateFunction;

  final bool enabled;

  const ListTileWithTextField({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.leadingIcon,
    @required this.trailingIcon,
    @required this.editingIcon,
    this.saveFunction,
    this.onChangedFunction,
    this.validateFunction,
    this.enabled = true,
  }) : super(key: key);

  @override
  _ListTileWithTextFieldState createState() => _ListTileWithTextFieldState(
        title: title,
        subtitle: subtitle,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        editingIcon: editingIcon,
        saveFunction: saveFunction,
        onChangedFunction: onChangedFunction,
        validateFunction: validateFunction,
        enabled: enabled,
      );
}

class _ListTileWithTextFieldState extends State<ListTileWithTextField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String title;
  final String subtitle;
  final Icon leadingIcon;
  final Icon trailingIcon;
  final Icon editingIcon;
  final Function saveFunction;
  final Function onChangedFunction;
  final Function validateFunction;
  final bool enabled;

  var editing = false;
  var _editTextController = TextEditingController();

  _ListTileWithTextFieldState({
    @required this.title,
    @required this.subtitle,
    @required this.leadingIcon,
    @required this.trailingIcon,
    @required this.editingIcon,
    this.saveFunction,
    this.onChangedFunction,
    this.validateFunction,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListTile(
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
                _editTextController.text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: textColor,
                ),
              )
            : Container(),
        trailing: enabled
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: editing ? editingIcon : trailingIcon,
                        onPressed: () {
                          if (editing) {
                            if (_formKey.currentState.validate()) {
                              saveFunction(context, state);
                              setState(() {
                                editing = !editing;
                              });
                            }
                          } else {
                            setState(() {
                              editing = !editing;
                            });
                          }
                        },
                      );
                    },
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _editField() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return TextFormField(
          textCapitalization: TextCapitalization.words,
          autofocus: true,
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
            return onChangedFunction(context, text);
          },
          validator: (text) {
            return validateFunction(state, text);
          },
          keyboardType: TextInputType.name,
        );
      },
    );
  }

  @override
  void initState() {
    print("init state");
    _editTextController.text = subtitle;
    super.initState();
  }
}
