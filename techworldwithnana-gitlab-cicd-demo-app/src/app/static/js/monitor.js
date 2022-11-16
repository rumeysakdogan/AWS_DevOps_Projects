var data_memcpu;
var data_disk;
var data_net;
var chart_memcpu;
var chart_disk;
var chart_net;
var options_percent;
var options_io;

var refresh_sec = 3.0;

function initCharts() {
   data_memcpu = google.visualization.arrayToDataTable([
      ['Label', 'Value'],
      ['CPU', 0],
      ['Memory', 0],
   ]);
   data_disk = google.visualization.arrayToDataTable([
      ['Label', 'Value'],
      ['Disk read', 0],
      ['Disk write', 0],
   ]);   
   data_net = google.visualization.arrayToDataTable([
      ['Label', 'Value'],
      ['Net sent', 0],
      ['Net recv', 0],
   ]);          

   options_percent = {
      //width: 1200, height: 600,
      redFrom: 90, redTo: 100,
      yellowFrom: 75, yellowTo: 90,
      greenFrom: 0, greenTo: 75,
      minorTicks: 5, animation:{ duration: 950, easing: 'inAndOut' }
   };
   options_io = {
      max: 200,
      minorTicks: 10, animation:{ duration: 950, easing: 'inAndOut' }
   };      

   chart_memcpu = new google.visualization.Gauge(document.getElementById('chart1'));
   chart_disk = new google.visualization.Gauge(document.getElementById('chart2'));
   chart_net = new google.visualization.Gauge(document.getElementById('chart3'));
   
   refreshCharts();
   refreshProcesses();
   setRefresh(refresh_sec);

   $('#refrate').text(refresh_sec);  
   $('#refslider').val(refresh_sec);
   $(document).on('input', '#refslider', function() {
      setRefresh($(this).val())
   });      
}

var proc_timer;
var chart_timer;
function setRefresh(new_secs) {
   refresh_sec = parseFloat(new_secs);
   $('#refrate').text(refresh_sec);  
   clearInterval(proc_timer);
   clearInterval(chart_timer);
   proc_timer = setInterval(function () {
     refreshProcesses();
   }, refresh_sec * 1000);   
   chart_timer = setInterval(function () {
      refreshCharts();
   }, refresh_sec * 1000);             
}
function refreshCharts() {
   $.ajax({
      url: '/api/monitor',
      type: 'GET',
      dataType: 'json',
      success: function (apidata) {
         //console.dir(apidata);
         data_memcpu.setValue(0, 1, apidata.cpu);
         data_memcpu.setValue(1, 1, apidata.mem);
         data_disk.setValue(0, 1, apidata.disk_read / (1024000*refresh_sec));
         data_disk.setValue(1, 1, apidata.disk_write / (1024000*refresh_sec));
         data_net.setValue(0, 1, apidata.net_sent / (1024000*refresh_sec));
         data_net.setValue(1, 1, apidata.net_recv / (1024000*refresh_sec));

         chart_memcpu.draw(data_memcpu, options_percent);
         chart_disk.draw(data_disk, options_io);
         chart_net.draw(data_net, options_io);
      },
      error: function (request, error) {
         console.log("API Request: " + JSON.stringify(request));
      }
   });
}

function refreshProcesses() {
   $.ajax({
      url: '/api/process',
      type: 'GET',
      dataType: 'json',
      success: function (apidata) {
         $('#process_tab').empty();
         $('#proc_count').text(apidata.processes.length);
         for(var p = 0; p < apidata.processes.length; p++) {
             $('#process_tab').append('<tr><td>'+apidata.processes[p].pid+'</td>'+
                '<td>'+apidata.processes[p].name+'</td>'+
                '<td>'+apidata.processes[p].memory_percent.toFixed(2)+'</td>'+
                '<td>'+(apidata.processes[p].cpu_times[0]+apidata.processes[p].cpu_times[1]).toFixed(2)+'</td>'+
                '<td>'+apidata.processes[p].num_threads+'</td>'+
                '</tr>')
         }
         var myTH = document.getElementsByTagName("th")[2];
         sorttable.innerSortFunction.apply(myTH, []);
      },
      error: function (request, error) {
         console.log("API Request: " + JSON.stringify(request));
      }
   });
}   