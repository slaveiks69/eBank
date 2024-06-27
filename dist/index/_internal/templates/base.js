let grid = new w2grid({
    name: 'grid',
    url: 'base',
    box: '.window',
    method: 'GET',
    show: {
        lineNumbers: true
    },
    fixedBody: true,
    autoLoad: true,
    limit: 60,
    columns: [
        { field: 'id', text: 'ID', size: '50px', sortable: true },
        { field: 'passportSerial', text: 'Серия и номер паспорта', size: '100px' },
        { field: 'lastName', text: 'Фамилия', size: '100px', sortable: true },
        { field: 'firstName', text: 'Имя', size: '80px', sortable: true },
        { field: 'patronymic', text: 'Отчество', size: '120px', sortable: true },
        { field: 'birthDate', text: 'День рождения', size: '100px'},
        { field: 'birthPlace', text: 'Место рождения', size: '100px' },
        { field: 'passportIssue', text: 'Паспорт выдан', size: '100px' },
        { field: 'passportIssueDate', text: 'Дата выдачи пасспорта', size: '80px' },
        { field: 'passportDivisionCode', text: 'Код дивизиона', size: '60px' },
        //{ field: 'accountNumber', text: 'Last Name', size: '200px' },
        { field: 'address', text: 'Адрес проживания', size: '200px' },
        { field: 'phoneHome', text: 'Номер телефона', size: '100px' },
        { field: 'codeword', text: 'Кодовое слово', size: '50px' }//,
        //{ field: 'recruimentId', text: 'ID Команды', size: '200px' }//,
        //{ field: 'name', text: 'Last Name', size: '200px' },
        //{ field: 'person_team.outgoing', text: 'Last Name', size: '200px' },
        //{ field: 'team', text: 'Last Name', size: '200px' }
    ],
    contextMenu: [
        { id: 'view', text: "Просмотр", icon: "fa fa-info" },
        { id: 'edit', text: "Редактировать", icon: "w2ui-icon-pencil" }
    ],
    onContextMenuClick(event){
        //console.log(event);
        switch (event.detail.menuItem.id)
        {
            case "edit":
                $(".popup").removeClass("popup-close");
                document.querySelector('.popup').src = "add/"+grid.get(event.detail.recid).passportSerial;
                document.getElementById('export').classList.remove("popup-close");
                break;
        }
    }
});