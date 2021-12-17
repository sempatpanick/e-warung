import 'package:ewarung/common/styles.dart';
import 'package:ewarung/data/model/history_transaction_result.dart';
import 'package:ewarung/utils/date_time_helper.dart';
import 'package:ewarung/utils/get_formatted.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemOrderHistory extends StatefulWidget {
  final Transaction dataTransaction;
  const ItemOrderHistory({Key? key, required this.dataTransaction}) : super(key: key);

  @override
  State<ItemOrderHistory> createState() => _ItemOrderHistoryState();
}

class _ItemOrderHistoryState extends State<ItemOrderHistory> {
  @override
  Widget build(BuildContext context) {
    List<DataRow> listItem = [];
    int iteration = 1;

    for (var element in widget.dataTransaction.items) {
      listItem.add(
        DataRow(
          cells: [
            DataCell(
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("$iteration.")
                )
            ),
            DataCell(Text(element.name)),
            DataCell(Text("x${element.amount}")),
            DataCell(
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Rp. ${GetFormatted().number(int.parse(element.price))}")
                )
            ),
          ],
        ),
      );
      iteration++;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
          color: textColorWhite,
          borderRadius: BorderRadius.circular(30.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Transaction ID"),
              Text("#${widget.dataTransaction.id}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Date Time"),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(DateTimeHelper().dateFormat(widget.dataTransaction.datetimeTransaction)),
                  Text(DateTimeHelper().timeFormat(widget.dataTransaction.datetimeTransaction)),
                ],
              ),
            ],
          ),
          const Text("Items"),
          DataTable(
            columnSpacing: 5.0,
            headingRowHeight: 20,
            dataRowHeight: 30,
            horizontalMargin: 10,
            columns: const [
              DataColumn(label: Text("No.")),
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Amount")),
              DataColumn(
                label: SizedBox(
                    width: 66,
                    child: Center(child: Text("Price"))
                ),
              ),
            ],
            rows: listItem
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Price"),
              Text("Rp. ${GetFormatted().number(int.parse(widget.dataTransaction.bill))}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Paid"),
              Text("Rp. ${GetFormatted().number(int.parse(widget.dataTransaction.paid))}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Charge Back"),
              Text("Rp. ${GetFormatted().number(int.parse(widget.dataTransaction.changeBill))}")
            ],
          ),
        ],
      ),
    );
  }
}