
window.update = function update_inputs() {
    let inputs = {
        id: $("#id").val(),
        passport: $("#passport").val(),
        lastName: $("#fam").val(),
        firstName: $("#nam").val(),
        middleName: $("#par").val(),
        card: $("#card").val(),
        offset: 0,
        limit: 100
    }

    postData('http://localhost:1111/search', { data: inputs })
        .then((data) => {
            w2ui['grid'].clear();
            w2ui['grid'].add(data);
        });
}

//window.timer = setTimeout(update, 10000);


var timeoutHandle;

window.timer = function handle() {
    window.clearTimeout(timeoutHandle);
    timeoutHandle = setTimeout(function () { update() }, 500);
};


let grid = new w2grid({
    name: 'grid',
    url: 'base',
    box: '.window',
    method: 'GET',
    show: {
        //toolbar: true,
        lineNumbers: true
    },
    fixedBody: true,
    autoLoad: true,
    limit: 60,
    columns: [
        { field: 'id', text: 'ID', size: '50px', sortable: true },
        { field: 'passportSerial', text: 'Серия и номер паспорта', size: '100px' },
        { field: 'last_name', text: 'Фамилия', size: '100px', sortable: true },
        { field: 'first_name', text: 'Имя', size: '80px', sortable: true },
        { field: 'patronymic', text: 'Отчество', size: '120px', sortable: true },
        { field: 'birth_date', text: 'День рождения', size: '100px', sortable: true },
        { field: 'birthPlace', text: 'Место рождения', size: '100px' },
        { field: 'passportIssue', text: 'Паспорт выдан', size: '100px' },
        { field: 'passportIssueDate', text: 'Дата выдачи пасспорта', size: '80px' },
        { field: 'passportDivisionCode', text: 'Код дивизиона', size: '60px' },
        { field: 'accountNumber', text: 'Карта', size: '150px' },
        { field: 'address', text: 'Адрес проживания', size: '200px' },
        { field: 'phoneHome', text: 'Номер телефона', size: '100px' },
        { field: 'codeword', text: 'Кодовое слово', size: '50px' },
        //{ field: 'recruimentId', text: 'ID Команды', size: '200px' }//,
        //{ field: 'name', text: 'Last Name', size: '200px' },
        { field: 'outgoing', text: 'Исх. команда', size: '50px' },
        { field: 'team', text: 'Команда', size: '50px' }
    ],
    contextMenu: [
        { id: 'copy', text: "Скопировать для фото", icon: "fa fa-camera" },
        { id: 'edit', text: "Редактировать", icon: "fa fa-pencil" },
        { id: 'delete', text: "Удалить", icon: "fa fa-trash" }
    ],
    onLoad(event) {
        $("#id").keyup(function () {
            timer();
        });
        $("#passport").keyup(function () {
            timer();
        });
        $("#fam").keyup(function () {
            timer();
        });
        $("#nam").keyup(function () {
            timer();
        });
        $("#par").keyup(function () {
            timer();
        });
        $("#card").keyup(function () {
            timer();
        });
        if (($("#id").val() != "") || ($("#passport").val() != "") || ($("#fam").val() != "") || ($("#nam").val() != "") || ($("#par").val() != "") || ($("#card").val() != "")) 
            {
                update();
            }
    },
    onContextMenuClick(event) {
        //console.log(event);
        switch (event.detail.menuItem.id) {
            case "copy":
                var p = grid.get(event.detail.recid).patronymic[0];
                if (p === "")
                    p = " ";
                var text = grid.get(event.detail.recid).last_name + " " + grid.get(event.detail.recid).first_name[0] + "." + p +".";
                navigator.clipboard.writeText(text);
                break;
            case "edit":
                open_add(grid.get(event.detail.recid).passportSerial);
                break;
            case "delete":
                delete_popup(grid.get(event.detail.recid).id, grid.get(event.detail.recid).passportSerial);
                break
        }
    },
    onDblClick(event){
        open_add(grid.get(event.detail.recid).passportSerial);
    }
});

window.check = function check(id) {
    if ($("#check_input").val().toUpperCase() === "ПОДТВЕРДИТЬ") {
        postData('http://localhost:1111/delete', { 'id': id })
            .then((data) => {
                w2utils.notify('Успешно!', { timeout: 2000, error: false });
                w2popup.close();
                w2ui['grid'].reload()
            });
    }
}

function open_add(passportSerial) {
    $(".popup").removeClass("popup-close");
    document.querySelector('.popup').src = "add/" + passportSerial;
    document.getElementById('export').classList.remove("popup-close");
}

function delete_popup(id, passportSerial) {
    w2popup.open({
        title: 'Удаление',
        body: '<i>Чтобы удалить </i><i style="font-weight: 600; color: var(--hred) !important;font-size: 1.3em;">' + id + ' | ' + passportSerial +
            '</i><i>введите \"подтвердить\"</i><input id="check_input" placeholder="ПОДТВЕРДИТЬ" class="ab" type="text"  />' +
            '<input type="button" class="button check_btn" onclick="check('+id+')" style="font-size: 1.1em !important; width: 30%; border-color: var(--hred) !important;" value="Проверить" />',
    });
}