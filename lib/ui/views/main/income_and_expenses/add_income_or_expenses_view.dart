import 'package:box_ui/box_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../constants/app_string.dart';
import '../../../shared/const_color_helper.dart';
import '../../../shared/const_ui_helper.dart';
import '../../../shared/dumb_widgets/build_label_container.dart';
import '../../../shared/dumb_widgets/statusbar.dart';
import '../main_view.dart';
import 'package:stacked/stacked.dart';
import 'add_income_or_expenses_view_model.dart';

class AddIncomeOrExpensesView extends StatelessWidget {
  final bool isExpenses;
  const AddIncomeOrExpensesView({Key? key, required this.isExpenses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusScope = FocusScope.of(context);
    return ViewModelBuilder<AddIncomeOrExpensesViewModel>.reactive(
      viewModelBuilder: () => AddIncomeOrExpensesViewModel(),
      builder: (
        BuildContext context,
        AddIncomeOrExpensesViewModel model,
        Widget? child,
      ) {
        return StatusBar(
            child: Scaffold(
          backgroundColor:
              model.showModelBottomSheet ? kcNeutral6 : Colors.white,
          bottomSheet: model.showModelBottomSheet
              ? Container(
                  color: kcNeutral6,
                  child: BuildBottomModelSheet(
                    isIncome: !isExpenses,
                    model: model,
                  ))
              : null,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor:
                model.showModelBottomSheet ? kcNeutral6 : Colors.white,
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            title: Text(
              !isExpenses ? addIncomeText : addExpenseText,
              style: heading6Style.copyWith(
                color: Colors.black,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                verticalSpaceSmall,
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth(context) * 0.05),
                  child: SizedBox(
                    child: Form(
                        child: Column(
                      children: [
                        BoxInputField(
                            label: 'Amount',
                            onChanged: model.setAmount,
                            keyboardType: TextInputType.number),
                        verticalSpaceVeryTiny,
                        InkWell(
                          onTap: () {
                            focusScope.unfocus();
                            model.setShowModelBottomSheet();
                          },
                          child: BuildLabelContainer(
                              label: 'Category',
                              child: Text(
                                model.category,
                                style: heading6Style.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: kcNeutral2),
                              )),
                        ),
                        verticalSpaceVeryTiny,
                        InkWell(
                            onTap: () {
                              focusScope.unfocus();
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.utc(2020),
                                      lastDate: DateTime.utc(2100))
                                  .then((value) => model.setDate(
                                      value!))
                                  .onError((error, stackTrace) => null);
                            },
                            child: BuildLabelContainer(
                                label: 'Date',
                                child: Text(
                                  model.date,
                                  style: heading6Style.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: kcNeutral2),
                                ))),
                        verticalSpaceVeryTiny,
                        BoxInputField(
                          label: 'Description',
                          onChanged: model.setDescription,
                          maxLines: 5,
                        ),
                        verticalSpaceMedium,
                        BoxButton(
                            title: 'Save',
                            onTap: () {
                              model.createIncomeOrExpenses(isExpenses);
                              Navigator.of(context).pushReplacement(
                                  CupertinoPageRoute(
                                      builder: (_) => const MainView()));
                            })
                      ],
                    )),
                  ),
                )
              ],
            ),
          ),
        ));
      },
    );
  }
}

class BuildBottomModelSheet extends StatelessWidget {
  final bool isIncome;
  final AddIncomeOrExpensesViewModel model;
  const BuildBottomModelSheet(
      {Key? key, required this.isIncome, required this.model})
      : super(key: key);
  final radius = const Radius.circular(30);
  @override
  Widget build(BuildContext context) {
    final dataList = isIncome ? incomeCategory : expensesCategory;
    return Container(
      height: screenHeiht(context) * 0.5,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: radius, topRight: radius)),
      child: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 8),
            child: Row(children: [
              Text(
                '${isIncome ? 'Income' : 'Expenses'} Category',
                style: heading6Style,
              ),
              const Spacer(),
              IconButton(
                  onPressed: model.setShowModelBottomSheet,
                  icon: const Icon(Icons.close))
            ]),
          ),
          Container(
            height: (screenHeiht(context) * 0.5) - 50,
            padding: const EdgeInsets.symmetric(horizontal: 31),
            child: ListView.separated(
                itemBuilder: (context, index) => InkWell(
                      onTap: () => model.setCategory(dataList[index]),
                      child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: kcNeutral8),
                        padding: const EdgeInsets.only(left: 24),
                        child: Text(
                          dataList[index],
                          style: heading6Style.copyWith(
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                separatorBuilder: (context, _) => verticalSpaceVeryTiny,
                itemCount: dataList.length),
          )
        ],
      ),
    );
  }
}
