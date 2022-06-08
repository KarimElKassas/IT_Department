import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:it_department/shared/components.dart';
import 'package:it_department/shared/constants.dart';

import 'drop_list_model.dart';

class SelectDropList extends StatefulWidget {
  final OptionItem itemSelected;
  final DropListModel? dropListModel;
  final IconData? listIcon;
  final Function(OptionItem optionItem) onOptionSelected;

  // ignore: use_key_in_widget_constructors
  const SelectDropList(
      this.itemSelected, this.dropListModel, this.onOptionSelected, this.listIcon);

  @override
  // ignore: no_logic_in_create_state
  _SelectDropListState createState() =>
      // ignore: no_logic_in_create_state
      _SelectDropListState(itemSelected, dropListModel!);
}

class _SelectDropListState extends State<SelectDropList>
    with SingleTickerProviderStateMixin {
  OptionItem optionItemSelected;
  final DropListModel dropListModel;

  late AnimationController expandController;
  late Animation<double> animation;

  bool isShow = false;

  _SelectDropListState(this.optionItemSelected, this.dropListModel);

  @override
  void initState() {
    super.initState();
    expandController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (isShow) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.06,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
                bottomRight: isShow ? Radius.circular(0) : Radius.circular(8),
                bottomLeft: isShow ? Radius.circular(0) : Radius.circular(8),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 10, color: darkGreen, offset: Offset(0, 2))
            ],
          ),
          child: GestureDetector(
            onTap: (){
              isShow = !isShow;
              _runExpandCheck();
              setState(() {});
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 8,),
                widget.listIcon != null ? Icon(
                  widget.listIcon,
                  color: lightGreen,
                ) : getEmptyWidget(),
                widget.listIcon != null ? const SizedBox(
                  width: 10,
                ) : getEmptyWidget(),
                Expanded(
                    child: Text(
                      optionItemSelected.title,
                      style:  TextStyle(color: lightGreen, fontFamily: "Hamed", fontSize: 20,),
                    )),
                Align(
                  alignment: const Alignment(1, 0),
                  child: Icon(
                    !isShow ? IconlyBroken.arrowDown2 : IconlyBroken.arrowUp2,
                    color:  lightGreen,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: animation,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4
              ),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(bottom: 10),
                decoration:  BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 4,
                        color: darkGreen,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: SingleChildScrollView(
                  child: _buildDropListOptions(
                      dropListModel.listOptionItems, context),
                ))),
//          Divider(color: Colors.grey.shade300, height: 1,)
      ],
    );
  }

  Column _buildDropListOptions(List<OptionItem> items, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items.map((item) => _buildSubMenu(item, context)).toList(),
    );
  }

  Widget _buildSubMenu(OptionItem item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 26.0, top: 5, bottom: 5),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: lightGreen, width: 0.5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(item.title,
                      style:  TextStyle(
                          color: lightGreen,
                          fontFamily: "Hamed",
                          fontSize: 18),
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          optionItemSelected = item;
          isShow = false;
          expandController.reverse();
          widget.onOptionSelected(item);
        },
      ),
    );
  }
}
