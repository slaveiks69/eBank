let grid = new w2grid({
    name: 'outgoing_grid',
    url: 'team/outgoing',
    box: '#outgoing_team_table',
    method: 'GET',
    show: {
        lineNumbers: true
    },
    fixedBody: true,
    autoLoad: true,
    limit: 30,
    columns: [
        { field: 'outgoing', text: 'Исходный номер команды', size: '40px' },
        { field: 'team', text: 'Номер команды', size: '40px' },
        { field: 'statement', text: 'Приказ', size: '40px' },
        { field: 'statement_date', text: 'Дата приказа', size: '80px', },
        { field: 'counter', text: 'Кол-во духов', size: '30px', }
    ],
    contextMenu: [
        //{ id: 'view', text: "Просмотр", icon: "fa fa-info" },
        { id: 'reload', text: "Обновить", icon: "fa fa-refresh" }
    ],
    onContextMenuClick(event){
        //console.log(event);
        switch (event.detail.menuItem.id)
        {
            case "reload":
                this.reload();
                break;
        }
    }
});