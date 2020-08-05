import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LegendWithMeasures extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String color;

  LegendWithMeasures(this.seriesList, {Key key, this.animate, this.color})
      : super(key: key);

  // factory LegendWithMeasures.withSampleData() {
  //   return new LegendWithMeasures(
  //     _createSampleData(),
  //     // Disable animations for image tests.
  //     animate: false,
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300.0,
      child: new charts.BarChart(
        seriesList,
        animate: animate,
        barGroupingType: charts.BarGroupingType.grouped,
        // Add the legend behavior to the chart to turn on legends.
        // This example shows how to optionally show measure and provide a custom
        // formatter.
        domainAxis: new charts.OrdinalAxisSpec(
            renderSpec: new charts.SmallTickRendererSpec(
                // Tick and Label styling here.
                labelStyle: new charts.TextStyleSpec(
                    fontSize: 18, // size in Pts.
                    color: color == "black"
                        ? charts.MaterialPalette.black
                        : charts.MaterialPalette.white),
                // Change the line colors to match text color.
                lineStyle: new charts.LineStyleSpec(
                    color: color == "black"
                        ? charts.MaterialPalette.black
                        : charts.MaterialPalette.white))),

        /// Assign a custom style for the measure axis.
        primaryMeasureAxis: new charts.NumericAxisSpec(
            renderSpec: new charts.GridlineRendererSpec(
                // Tick and Label styling here.
                labelStyle: new charts.TextStyleSpec(
                    fontSize: 15, // size in Pts.
                    color: color == "black"
                        ? charts.MaterialPalette.black
                        : charts.MaterialPalette.white),
                // Change the line colors to match text color.
                lineStyle: new charts.LineStyleSpec(
                    color: color == "black"
                        ? charts.MaterialPalette.black
                        : charts.MaterialPalette.white))),
        behaviors: [
          new charts.SeriesLegend(
            // Positions for "start" and "end" will be left and right respectively
            // for widgets with a build context that has directionality ltr.
            // For rtl, "start" and "end" will be right and left respectively.
            // Since this example has directionality of ltr, the legend is
            // positioned on the right side of the chart.
            position: charts.BehaviorPosition.bottom,
            // By default, if the position of the chart is on the left or right of
            // the chart, [horizontalFirst] is set to false. This means that the
            // legend entries will grow as new rows first instead of a new column.
            horizontalFirst: false,
            // This defines the padding around each legend entry.
            cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
            // Set show measures to true to display measures in series legend,
            // when the datum is selected.
            showMeasures: true,
            // Optionally provide a measure formatter to format the measure value.
            // If none is specified the value is formatted as a decimal.
            measureFormatter: (num value) {
              return value == null ? '-' : '$value';
            },

            entryTextStyle: charts.TextStyleSpec(
                color: color == "black"
                    ? charts.MaterialPalette.black
                    : charts.MaterialPalette.white),
          )
        ],
      ),
    );
  }
}
