const getData = async (url = '') => {
    const response = await fetch(url, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        },
    });
    return response.json();
};

$(".btn-reset").click(function () {
    getData('http://localhost:1111/monitoring/reset')
        .then((data) => {
            if (data.complete == "true") {
                alert("Очищенно");
            }
        });
});

dataset = [];

$(document).ready(function () {
    getData('http://localhost:1111/monitoring/count')
        .then((data) => {
            dataset = data;
            let data1 = [];
            dataset.forEach(element => {
                var name = element.name_pc+' | '+element.ip;
                var count = element.count;
                data1.push({ name: count });
            });

            anydata = anychart.data.set(data1);
            var chart = anychart.pie(anydata);

            chart.innerRadius('55%');
            chart.title('Music Streaming Apps Global Market Share')
            var stage = anychart.graphics.create("container",800,600);
            chart.container(stage).draw();
        });
});