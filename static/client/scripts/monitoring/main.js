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

$(".btn-update").click(function () {
    getData('http://localhost:1111/monitoring/count')
        .then((data) => {
            update(data);
        });
});

dataset = [];

function update(data) {
    
    var d = document.querySelector("#container");
    while (d.firstChild){
        d.removeChild(d.firstChild);
    }

    var p = document.querySelector(".stat_child");
    while (p.lastChild) {
        p.removeChild(p.lastChild);
    }


    dataset = data;
    let data1 = [];

    dataset.forEach(element => {
        var count = element.count;
        var names = element.pc_name + ' | ' + element.pc_ip
        data1.push({ 'value': count, name: names });
    });

    colors_a = ['#fd5e58', '#7fd8be', '#d0f4de', '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#ffffff'];

    const myDonut = donut({
        el: document.getElementById('container'),
        data: data1,
        colors: colors_a,
        size: 125,
    });
    let statistic_count = document.querySelector('.stat_child');
    let sum = 0;
    function a(e, index) {
        let i = document.createElement("i");
        let a = "";
        switch (index) {
            case 0:
                a = "🔥💪";
                break;
        }
        i.innerHTML = (index + 1) + " | " + e.pc_name + " | " + e.pc_ip + " | " + e.count + "шт. " + a;
        let b = "";
        switch (index) {
            case 0:
                b = "font-size: 1.25em; text-shadow: 0 0 5px #fce100;"
                break;
            case 1:
                b = "font-size: 1.1em;"
                break;
        }
        i.style = "color:" + colors_a[index] + ";" + b;
        statistic_count.appendChild(i);
        sum = sum + e.count;
    }

    dataset.forEach((e, index) => a(e, index));

    let i = document.createElement("i");
    i.innerHTML = "Итого: " + sum;
    statistic_count.appendChild(i);
}

$(document).ready(function () {
    getData('http://localhost:1111/monitoring/count')
        .then((data) => {
            update(data);
        });
});