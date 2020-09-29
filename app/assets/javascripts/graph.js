am4core.ready(function() {
  
  // Themes begin
  am4core.useTheme(am4themes_animated);
  // Themes end
  
  // Create chart instance
  var chart = am4core.create("chartdiv", am4charts.XYChart);
  chart.scrollbarX = new am4core.Scrollbar();
  
  // Add data
  var total_amounts = gon.total_amounts

  chart.data = [{
    "date": "6日前",
    "total_amounts": total_amounts[0]
  }, {
    "date": "5日前",
    "total_amounts": total_amounts[1]
  }, {
    "date": "4日前",
    "total_amounts": total_amounts[2]
  }, {
    "date": "3日前",
    "total_amounts": total_amounts[3]
  }, {
    "date": "2日前",
    "total_amounts": total_amounts[4]
  }, {
    "date": "昨日",
    "total_amounts": total_amounts[5]
  }, {
    "date": "本日",
    "total_amounts": total_amounts[6]
  }];
  
  // Create axes
  var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
  categoryAxis.dataFields.category = "date";
  categoryAxis.renderer.grid.template.location = 0;
  categoryAxis.renderer.minGridDistance = 30;
  categoryAxis.renderer.labels.template.horizontalCenter = "right";
  categoryAxis.renderer.labels.template.verticalCenter = "middle";
  categoryAxis.renderer.labels.template.rotation = 0;
  categoryAxis.tooltip.disabled = true;
  categoryAxis.renderer.minHeight = 110;
  
  var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
  valueAxis.renderer.minWidth = 50;
  
  // Create series
  var series = chart.series.push(new am4charts.ColumnSeries());
  series.sequencedInterpolation = true;
  series.dataFields.valueY = "total_amounts";
  series.dataFields.categoryX = "date";
  series.tooltipText = "[{categoryX}: bold]{valueY}[/]";
  series.columns.template.strokeWidth = 0;
  
  series.tooltip.pointerOrientation = "vertical";
  
  series.columns.template.column.cornerRadiusTopLeft = 10;
  series.columns.template.column.cornerRadiusTopRight = 10;
  series.columns.template.column.fillOpacity = 0.8;
  
  // on hover, make corner radiuses bigger
  var hoverState = series.columns.template.column.states.create("hover");
  hoverState.properties.cornerRadiusTopLeft = 0;
  hoverState.properties.cornerRadiusTopRight = 0;
  hoverState.properties.fillOpacity = 1;
  
  series.columns.template.adapter.add("fill", function(fill, target) {
    return chart.colors.getIndex(target.dataItem.index);
  });
  
  // Cursor
  chart.cursor = new am4charts.XYCursor();
  
  }); // end am4core.ready()