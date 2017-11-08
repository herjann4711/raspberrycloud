var options = {
    'width': 480,
    'height': 320,
    'chartArea': { 'width': '70%', 'height': '80%' },
    hAxis: {
        minValue: 0,
        maxValue: 100,
    },
    animation: {
        duration: 300,
        showHeader: true,
        startup: true,
        easing:'linear'
    },
    legend: { position: 'none' }


};


setInterval(update, 325);

function update() {
    if (!data || data.getNumberOfRows() == 0)
        return;

    data.sort({ column: 0, desc: false}); 
    chart.draw(data, options);    
}

document.addEventListener('DOMContentLoaded', function () {
    // Start the connection.
    startConnection('/chat', function (connection) {
        // Create a function that the hub can call to broadcast messages.
        connection.on('broadcastStatus', function (obj) {
            if (!data)
                return;
            if (data.getNumberOfRows() == 0) {
                data.addRows(1);
                data.addColumn('string', 'Processor');
                data.addColumn('number', 'CPU');
                data.addColumn('number', 'RAM');
            }

            var found = false;

            for (var y = 0, maxrows = data.getNumberOfRows(); y < maxrows; y++) {
                if (data.getValue(y, 0) == obj.clientInfo.hostname) {
                    data.setValue(y, 1, obj.cpuUsage.usage);
                    data.setValue(y, 2, obj.ramUsage.usage);
                    found = true;
                    break;
                }
            }

            if (!found) {
                data.addRows(1);
                var index = data.getNumberOfRows() - 1;
                data.setCell(index, 0, obj.clientInfo.hostname);
                data.setCell(index, 1, obj.cpuUsage.usage);
                data.setCell(index, 2, obj.ramUsage.usage);
            }

            
        });
    })
        .then(function (connection) {
            console.log('connection started');
        })
        .catch(error => {
            console.error(error.message);
        });

    // Starts a connection with transport fallback - if the connection cannot be started using
    // the webSockets transport the function will fallback to the serverSentEvents transport and
    // if this does not work it will try longPolling. If the connection cannot be started using
    // any of the available transports the function will return a rejected Promise.
    function startConnection(url, configureConnection) {
        return function start(transport) {
            console.log(`Starting connection using ${signalR.TransportType[transport]} transport`)
            var connection = new signalR.HubConnection(url, { transport: transport });
            if (configureConnection && typeof configureConnection === 'function') {
                configureConnection(connection);
            }

            return connection.start()
                .then(function () {
                    return connection;
                })
                .catch(function (error) {
                    console.log(`Cannot start the connection use ${signalR.TransportType[transport]} transport. ${error.message}`);
                    if (transport !== signalR.TransportType.LongPolling) {
                        return start(transport + 1);
                    }

                    return Promise.reject(error);
                });
        }(signalR.TransportType.WebSockets);
    }
});
