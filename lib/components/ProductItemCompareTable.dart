import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class ProductItemCompareTable extends StatefulWidget {
  const ProductItemCompareTable({super.key});

  @override
  _ProductItemCompareTableState createState() =>
      _ProductItemCompareTableState();
}

class _ProductItemCompareTableState extends State<ProductItemCompareTable> {
  bool _flag = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 100,
        showBottomBorder: true,
        headingTextStyle: const TextStyle(
          color: Color.fromARGB(255, 4, 39, 80),
        ),
        headingRowColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          return const Color.fromARGB(255, 240, 241, 241); // default color
        }),
        columns: const [
          DataColumn2(label: Text('Donde'), fixedWidth: 120),
          DataColumn2(label: Text('Precio'), numeric: true, fixedWidth: 110),
          DataColumn2(label: Text('Off'), fixedWidth: 40, numeric: true),
          DataColumn2(label: Center(child: Text('Link'))),
        ],
        rows: List<DataRow>.generate(
          5,
          (index) => DataRow2(
            cells: [
              DataCell(
                ColoredBox(
                  color: Colors.indigo,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: Image.asset(
                        "assets/images/catedral_logo_small.webp",
                      ),
                    ),
                  ),
                ),
              ),
              const DataCell(Text('Gs 1.000.000')),
              const DataCell(Text('50%')),
              DataCell(
                ElevatedButton(
                  onPressed: () => setState(() => _flag = !_flag),
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.fromLTRB(0, 0, 0, 0),
                    ),
                  ),
                  child: Text(
                    _flag ? 'Ver' : 'Ver',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
