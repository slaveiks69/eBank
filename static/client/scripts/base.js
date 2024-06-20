import { w2grid, w2utils } from './w2ui.js'

let config = {
    grid: {
        name: 'grid',
        box: '.window',
        url: 'base',
        show: {
            footer: true,
            toolbar: true,
            lineNumbers: true
        },
        limit: 50,
        columns: [
            { field: 'id', text: 'ID', size: '100px' },
            { field: 'passport_serial', text: 'First Name', size: '200px', searchable: 'text' },
            { field: 'last_name', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'first_name', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'patronymic', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'birth_date', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'birth_place', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'passport_issue', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'passport_issue_date', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'passport_division_code', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'account_number', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'address', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'phone_home', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'codeword', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'recruitment_office_id', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'name', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'person_team.outgoing', text: 'Last Name', size: '200px', searchable: 'text' },
            { field: 'team', text: 'Last Name', size: '200px', searchable: 'text' }
        ],
        onLoad(event) {
            // let data = w2utils.clone(event.detail.data)
            // data.records.forEach((rec, ind) => {
            //     rec.recid = 'recid-' + (this.records.length + ind)
            // })
            // event.detail.data = data
        }
    }
}

window.refreshGrid = function(auto) {
    grid.autoLoad = auto
    grid.skip(0)
}

let grid = new w2grid(config.grid)