const postData = async (url = '', data = {}) => {
    // Формируем запрос
    const response = await fetch(url, {
        // Метод, если не указывать, будет использоваться GET
        method: 'POST',
        // Заголовок запроса
        headers: {
            'Content-Type': 'application/json'
        },
        // Данные
        body: JSON.stringify(data)
    });
    return response.json();
};

let grid = new w2grid({
    name: 'outgoing_grid',
    url: '/team/outgoing',
    box: '#outgoing_team_table',
    method: 'GET',
    show: {
        lineNumbers: true
    },
    fixedBody: true,
    autoLoad: true,
    limit: 25,
    columns: [
        { field: 'outgoing', text: 'Исходный номер команды', size: '40px' },
        { field: 'team', text: 'Номер команды', size: '40px' },
        { field: 'statement', text: 'Приказ', size: '40px' },
        { field: 'statement_date', text: 'Дата приказа', size: '80px', },
        { field: 'counter', text: 'Кол-во духов', size: '65px', }
    ],
    contextMenu: [
        //{ id: 'view', text: "Просмотр", icon: "fa fa-info" },
        { id: 'reload', text: "Обновить", icon: "fa fa-refresh" },
        { id: 'delete', text: "Удалить", icon: "fa fa-trash" }
    ],
    onContextMenuClick(event) {
        //console.log(event);
        switch (event.detail.menuItem.id) {
            case "reload":
                this.selectNone();
                this.reload();
                break;
            case "delete":
                delete_popup(grid.get(event.detail.recid).outgoing);
                break;
        }
    },
    onDblClick(event){
        open(grid.get(event.detail.recid).outgoing);
    }
});

function delete_popup(outgoing) {
    w2popup.open({
        title: 'Удаление',
        body: '<i>Чтобы удалить </i><i style="font-weight: 600; color: var(--hred) !important;font-size: 1.3em;"> Команду №' + outgoing +
            '</i><i>введите \"подтвердить\"</i><input id="check_input" placeholder="ПОДТВЕРДИТЬ" class="ab" type="text"  />' +
            '<input type="button" class="button check_btn" onclick="check('+outgoing+')" style="font-size: 1.1em !important; width: 30%; border-color: var(--hred) !important;" value="Проверить" />',
    });
    
}

window.check = function check(outgoing) {
    if ($("#check_input").val().toUpperCase() === "ПОДТВЕРДИТЬ") {
        postData('http://localhost:1111/team/delete', { data: outgoing })
            .then((data) => {
                console.log(data);
                grid.selectNone();
                grid.reload();
                w2utils.notify('Успешно!', { timeout: 2000, error: false });
                w2popup.close();
            });
    }
}

function open(outgoing)
{
    postData('http://localhost:1111/team/check', { data: outgoing+'' })
        .then((data) => {
            w2popup.open({
                title: 'Команда №'+outgoing,
                body: '<div id="outeam"><div>',
                width: 650, 
                height: 550,
                showMax: true,
            });
            if(top.document.querySelector('.team').contentWindow.w2ui.hasOwnProperty('out_team_grid'))
                top.document.querySelector('.team').contentWindow.w2ui['out_team_grid'].destroy(); 
            let outeam = new w2grid({
                name: 'out_team_grid',
                box: '#outeam',
                show: {
                    lineNumbers: true
                },
                fixedBody: true,
                autoLoad: false,
                columns: [
                    { field: 'last_name', text: 'Фамилия', size: '100px' },
                    { field: 'first_name', text: 'Имя', size: '80px'},
                    { field: 'patronymic', text: 'Отчество', size: '120px' },
                    { field: 'birth_date', text: 'День рождения', size: '100px' },
                    { field: 'accountNumber', text: 'Карта', size: '170px', 
                        render: function (record, extra) {
                            if (record.accountNumber == null) return '';
                            let card = record.accountNumber.split(/(.{4})/).filter(a=>!!a);
                            var html = '<div>' + card.join(' ') + '</div>';
                            return html;
                        } 
                    }
                ],
                contextMenu: [
                    { id: 'open', text: "Править", icon: "fa fa-pencil", class: "offe" },
                    { id: 'reload', text: "Обновить", icon: "fa fa-refresh" }
                ],
                onDblClick(event){
                    proclick(outeam.get(event.detail.recid).passportSerial);
                },
                onContextMenu(event) {
                    event.done(function () {
                        contextMenu1Item = document.querySelector("#w2overlay-context-menu > div > div > div:nth-child(1)");
                        if (outeam.get(event.detail.recid).hasOwnProperty('w2ui')) {
                            if (outeam.get(event.detail.recid).w2ui.hasOwnProperty('parent_recid')) {
                                if (contextMenu1Item.classList.contains('offe'))
                                    contextMenu1Item.classList.remove('offe');
                            }
                        }
                        else {
                            if (!contextMenu1Item.classList.contains('offe'))
                                contextMenu1Item.classList.add('offe');
                        }
                    });
            
                },
                onContextMenuClick(event) {
                    //console.log(event);
                    switch (event.detail.menuItem.id) {
                        case "open":
                            if (outeam.get(event.detail.recid).hasOwnProperty('w2ui')) {
                                if (outeam.get(event.detail.recid).w2ui.hasOwnProperty('parent_recid')) {
                                    top.document.querySelector('.popup').classList.remove("popup-close");
                                    let passport = outeam.get(event.detail.recid).passport;
                                    if (passport == undefined)
                                        passport = outeam.get(event.detail.recid).passportSerial;
                                    top.document.querySelector('.popup').src = "add/" + passport;
                                    top.document.getElementById('export').classList.remove("popup-close");
                                }
                            }
                            break;
                        case "reload":
                            this.reload();
                            break;
                    }
                }
            });
            w2ui['out_team_grid'].add(data);
        });

}

var timeoutHandle;

window.timer = function handle() {
    window.clearTimeout(timeoutHandle);
    timeoutHandle = setTimeout(function () { update() }, 1500);
};

$("#ishn").keyup(function () {
    timer();
});

function getPersonF(person) {
    let newperson = person;
    if (newperson.hasOwnProperty('w2ui')) {
        if (newperson.w2ui.hasOwnProperty('changes')) {
            if (newperson.w2ui.changes.hasOwnProperty('passport'))
                newperson.passport = newperson.w2ui.changes.passport;
            if (newperson.w2ui.changes.hasOwnProperty('lastName'))
                newperson.lastName = newperson.w2ui.changes.lastName;
            if (newperson.w2ui.changes.hasOwnProperty('firstName'))
                newperson.firstName = newperson.w2ui.changes.firstName;
            if (newperson.w2ui.changes.hasOwnProperty('middleName'))
                newperson.middleName = newperson.w2ui.changes.middleName;
            if (newperson.w2ui.changes.hasOwnProperty('birthDate'))
                newperson.birthDate = newperson.w2ui.changes.birthDate;
        }
    }
    return newperson;
}

function proclick(passportSerial) {
    postData('http://localhost:1111/team/proclick', { data: passportSerial })
        .then((data) => {
            w2popup.close();
            console.log(data+" proclick");
            grid.selectNone();
            grid.reload();
            open(data);
        });
}

//w2ui['team_grid'].records

window.getPersons = function getPersonsF(persons) {
    let a = []
    let error_team = false;
    persons.forEach(element => {
        try {
            if (element.w2ui.hasOwnProperty('parent_recid'))
                console.log("sperm");
            else
                error;

        } catch (error) { a.push(getPersonF(element)); }
        try {
            if (element.w2ui.hasOwnProperty('class')) {
                error_team = true;
            }
        }
        catch (error) { }
    });
    return a;
}

window.update = function update_inputs() {
    let input = {
        ishn: $("#ishn").val()
    }

    if ($("#ishn").val() == "") {
        tgrid.clear();
        window.team = undefined;
        document.querySelector('#team_info').innerHTML = "";
        return;
    }

    postData('http://localhost:1111/team/search', { data: input })
        .then((data) => {
            if (data.outgoingId == '-1') {
                w2utils.notify('Данной команды не существует!', { timeout: 2000, error: true });
                return;
            }
            w2ui['team_grid'].clear();
            w2ui['team_grid'].add(data.persons);

            let records = tgrid.records;
            for (let e of records)
            {
                if(e.passport.includes('АС'))
                    e.w2ui.children.passport.trimEnd();
                else if (e.hasOwnProperty('w2ui'))
                {
                    if (e.w2ui.hasOwnProperty('children'))
                    {
                        if(e.w2ui.children[0].passport.includes('АС'))
                            e.w2ui.children[0].passport = e.w2ui.children[0].passport.trimEnd(); 
                    }
                }
            }

            window.team = data;
            document.querySelector('#team_info').innerHTML = "Исходящий: " + data.outgoingId 
                + " | Команда: " + data.internalTeamId 
                + " | Выписка: " + data.teamId
                + "<br> Отправка: " + data.outDate
                + " | Состав: "+ data.count
                +" человек";
        });
}

let tgrid = new w2grid({
    name: 'team_grid',
    box: '#team_table',
    method: 'GET',
    show: {
        lineNumbers: true
    },
    fixedBody: true,
    autoLoad: false,
    columns: [
        { field: 'passport', text: 'Серия и номер паспорта', size: '115px', editable: { type: 'text' } },
        { field: 'lastName', text: 'Фамилия', size: '100px' },
        { field: 'firstName', text: 'Имя', size: '80px' },
        { field: 'middleName', text: 'Отчество', size: '120px' },
        { field: 'birthDate', text: 'День рождения', size: '100px' }
    ],
    contextMenu: [
        { id: 'open', text: "Править", icon: "fa fa-pencil", class: "offe" },
        { id: 'reload', text: "Обновить", icon: "fa fa-refresh" }
    ],
    onContextMenu(event) {
        event.done(function () {
            contextMenu1Item = document.querySelector("#w2overlay-context-menu > div > div > div:nth-child(1)");
            if (tgrid.get(event.detail.recid).hasOwnProperty('w2ui')) {
                if (tgrid.get(event.detail.recid).w2ui.hasOwnProperty('parent_recid')) {
                    if (contextMenu1Item.classList.contains('offe'))
                        contextMenu1Item.classList.remove('offe');
                }
            }
            else {
                if (!contextMenu1Item.classList.contains('offe'))
                    contextMenu1Item.classList.add('offe');
            }
        });

    },
    onContextMenuClick(event) {
        //console.log(event);
        switch (event.detail.menuItem.id) {
            case "open":
                if (tgrid.get(event.detail.recid).hasOwnProperty('w2ui')) {
                    if (tgrid.get(event.detail.recid).w2ui.hasOwnProperty('parent_recid')) {
                        top.document.querySelector('.popup').classList.remove("popup-close");
                        let passport = tgrid.get(event.detail.recid).passport;
                        if (passport == undefined)
                            passport = tgrid.get(event.detail.recid).passportSerial;
                        top.document.querySelector('.popup').src = "add/" + passport;
                        top.document.getElementById('export').classList.remove("popup-close");
                    }
                }
                break;
            case "reload":
                this.reload();
                break;
        }
    }
});

$("#create_team").click(
    function () {
        let records = tgrid.records;
        for (let e of records)
        {
            tgrid.collapse(e.recid)
        }
        records = tgrid.records;
        let changes = tgrid.getChanges();
        for (let change of changes)
        {
            tgrid.get(change.recid).passport = change.passport;
        }
        records = tgrid.records;

        if (window.team == undefined)
            return;
        let persons = getPersons(tgrid.records);
        if (persons.length === 0)
            return;
        let team = {
            'outgoingId': window.team.outgoingId,
            'internalTeamId': window.team.internalTeamId,
            'outDate': window.team.outDate,
            'teamId': window.team.teamId,
            'persons': records
        }
        console.log(team);
        postData('http://localhost:1111/team/create', { data: team })
            .then((data) => {
                console.log(data);
                tgrid.reload();
                grid.reload();
                open(team.outgoingId);
            });
    }
);