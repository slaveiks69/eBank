$(document).ready(function() {

    var socket = io.connect(window.uri);

    socket.on('connect', function() {
        console.log('Socket.IO is connected!!!');
        $(".mylogin")[0].classList.remove("disconnect");
        $(".mylogin")[0].classList.add("connect");
    });

    socket.on('disconnect', function() {
        $(".mylogin")[0].classList.remove("connect");
        $(".mylogin")[0].classList.add("disconnect");
    });

    socket.on('server event', function(data) {
        console.log(data.data);
    });

    socket.on('add_one', function(data) {
        console.log(data);
        document.querySelector('.monitoring').contentWindow.w2ui.dict_grid.reload();
    });

    socket.on('test', function(data) {
        console.log(data);
    });

    socket.on('delete_one', function(data) {
        document.querySelector('.monitoring').contentWindow.w2ui.dict_grid.reload();
    });

    socket.on('clear_export', function(data) {
        try
        {
            document.getElementById('table').innerHTML = '';
            let add = [];
            localStorage.setItem("add", JSON.stringify(add));
            frames[2].window.add.length = 0;
        }
        catch {}
        document.querySelector('.monitoring').contentWindow.w2ui.dict_grid.clear();
    });
});