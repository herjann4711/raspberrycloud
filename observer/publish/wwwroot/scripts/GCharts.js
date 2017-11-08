google.charts.load('current', { packages: ['corechart', 'bar'] });
google.charts.setOnLoadCallback(drawAxisTickColors);
var data;
var chart;

function drawAxisTickColors() {
    data = new google.visualization.DataTable();  
    chart = new google.visualization.BarChart(document.getElementById('chart_div'));
}
