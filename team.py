from flask import Blueprint, json, render_template, request, redirect, url_for
from utils import *


team = Blueprint('team', __name__)

@team.post('/create')
def create_team():
    rqt = json.loads(request.data)
    #b = (str)(rqt['data']['outDate']).replace('.','/')
    bd = siski.datetime.strptime(rqt['data']['outDate'],"%d.%m.%Y").strftime("%Y-%m-%d")
    print(bd)
    sql = f"INSERT INTO team (outgoing, team, statement, statement_date) VALUES({rqt['data']['outgoingId']}, {rqt['data']['internalTeamId']}, {rqt['data']['teamId']}, '{bd}');"
    
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        sex = connect()
        cursor = sex.cursor()
        print(sql)
        cursor.execute(sql)
        sex.commit()

        begin_sql = "INSERT INTO person_team (passport_serial, outgoing) VALUES "

        try:
            for person in rqt['data']['persons']:
                sql = begin_sql + f"('{person['passport']}', {rqt['data']['outgoingId']})"
                cursor.execute(sql)
                sex.commit()
        except pymssql.Error:
            sex.close()
            return '2'
        
    sex.close()
    return '1'

@team.post('/delete')
def delete_team():
    rqt = json.loads(request.data)

    outgoing = rqt['data']

    sql = f"EXEC pr_DeleteTeam {outgoing}"

    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        sex = connect()
        cursor = sex.cursor()
        cursor.execute(sql)
        sex.commit()
        sex.close()

    return "1"

@team.post('/proclick')
def proclick():
    rqt = json.loads(request.data)

    passportSerial = rqt['data']

    outgoing = "0000"

    sql = f"IF NOT EXISTS(SELECT * FROM person_team_metadata WHERE passport_serial='{passportSerial}') INSERT INTO person_team_metadata(passport_serial, account_number_registered_in_military_id) VALUES('{passportSerial}', 1) ELSE UPDATE person_team_metadata SET account_number_registered_in_military_id=(SELECT ~account_number_registered_in_military_id FROM person_team_metadata WHERE passport_serial='{passportSerial}') WHERE passport_serial='{passportSerial}'"

    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        sex = connect()

        cursor = sex.cursor()
        cursor.execute(sql)
        sex.commit()

        cursor.execute(f"select * from person_team where passport_serial='{passportSerial}'")
        row = cursor.fetchone()

        if row != None:
            outgoing = row[1]

        sex.close()

    return f"{outgoing}"


@team.post('/check')
def check():
    rqt = json.loads(request.data)

    print(rqt)
    
    ishodKodTeam = rqt['data']

    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        sex = connect()

        cursor = sex.cursor()
        cursor.execute(f"SELECT person.*, CONVERT(VARCHAR,birth_date,104), CONVERT(VARCHAR,passport_issue_date,104), person_team.outgoing, team, account_number, account_number_registered_in_military_id as registered FROM person LEFT OUTER JOIN person_card ON person.passport_serial = person_card.passport_serial LEFT OUTER JOIN person_team ON person.passport_serial = person_team.passport_serial LEFT OUTER JOIN recruitment_office_name ON recruitment_office_name.id = person.recruitment_office_id LEFT OUTER JOIN team ON person_team.outgoing = team.outgoing LEFT OUTER JOIN person_orphan ON person.passport_serial = person_orphan.passport_serial LEFT OUTER JOIN person_team_metadata ON person.passport_serial = person_team_metadata.passport_serial where person_team.outgoing = {ishodKodTeam} ORDER BY person.last_name ASC;")

        persons = []
        i = 0

        for row in cursor:
            if row == None:
                break
                
            dungeonmaster = {
                'recid': i,
                'id': row[0],
                'passportSerial': passportSerial(row[1]),
                'last_name': row[2],
                'first_name': row[3],
                'patronymic': row[4],
                'birth_date': row[17],
                'birthPlace': row[6],
                'passportIssue': row[7],
                'passportIssueDate': row[18],
                'passportDivisionCode': row[9],
                'address': row[10],
                'phoneHome': row[11],
                'phoneMobile': row[12],
                'recruimentId': row[13],
                'codeword': row[14],
                'dateAdd': row[15],
                'outgoing': row[19],
                'team': row[20],
                'accountNumber': row[21]
            }

            if row[22] != None:
                if row[22] == 1:
                    dungeonmaster['w2ui'] = { 'style': f"background-color: {static.cfg['bank']['color_registred']}" }
            
            i = i + 1
            persons.append(dungeonmaster)

        return persons

@team.get('/')
def monitoring_home():
  

    return render_template('team.html')

@team.get('/outgoing')
def outgoing():
    rqt = json.loads(request.args.get('request'))

    teams = json.dumps(get_teams(rqt['limit'],rqt['offset']))

    return "{ "+f"\"records\": {teams}, \"total\": {total_count_team()} "+" }"

@team.post('/search')
def search():
    rqt = json.loads(request.data)

    print(rqt)

    ishodKodTeam = rqt['data']['ishn']
    host = static.cfg['black']['host']

    url = f'http://{host}/api/v1/dispatchings/{ishodKodTeam}'

    headers = {
        'DataBase': static.cfg['black']['database'], 
        'X-Auth-Token': static.cfg['black']['x-auth-token']
    }

    responce = json.loads(requests.get(url,headers=headers).content)

    if len(responce['data']) == 0:
        return { 'outgoingId': '-1' }

    internalTeamId = responce['data'][0]['internalTeamId']
    teamId = responce['data'][0]['orderNumber']
    outDateRaw = responce['data'][0]['outDate'][0:10].split('-')
    outDate = f"{outDateRaw[2]}.{outDateRaw[1]}.{outDateRaw[0]}"

    url = f'http://{host}/api/v1/dispatchings/{ishodKodTeam}/recruits'

    responce = json.loads(requests.get(url,headers=headers).content)['data']

    print(responce)

    team = {
        'outgoingId': ishodKodTeam,
        'internalTeamId': internalTeamId,
        'teamId': teamId,
        'outDate': outDate,
        'persons': responce
    }

    i = 0

    for person in responce:
        person['recid'] = i
        i = i + 1
        personPassport = f"{person['passportSeries'][0:2]} {person['passportSeries'][2:4]} {person['passportNumber']}"
        person['passport'] = personPassport
        
        birthDateRaw = person['birthDate'][0:10].split('-')
        person['birthDate'] = f"{birthDateRaw[2]}.{birthDateRaw[1]}.{birthDateRaw[0]}"

        find = find_in_bank(personPassport)
        if find == None:
            #person['w2ui'] = { 'style': f"background-color: {static.cfg['bank']['color_none']}" }
            person['w2ui'] = { 'style': "" }
            findfio = find_in_bank_fio(person['lastName'],person['firstName'],person['middleName'])
            if findfio != None:
                findfio['birthDate'] = findfio['birthDateFormated']
                findfio['recid'] = f'{i}1'
                person['w2ui']['children'] = [findfio]
                person['w2ui']['class'] = "red"
        else:
            if find['lastName'] != person['lastName'] or find['firstName'] != person['firstName'] or find['patronymic'] != person['middleName']:
                style = {}
                find['birthDate'] = find['birthDateFormated']
                color = static.cfg['bank']['color_none']
                if find['lastName'] != person['lastName']:
                    style['lastName'] = f"background-color: {color};"
                if find['firstName'] != person['firstName']:
                    style['firstName'] = f"background-color: {color};"
                if find['patronymic'] != person['middleName']:
                    style['middleName'] = f"background-color: {color};"

                person['w2ui'] = { 'style': style }
                #print( { 'style': style })
                find['recid'] = f'{i}1'
                print(find)
                person['w2ui']['children'] = [find]
        
    team['count'] = i

    return team

def get_teams(limit,offset):
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        sex = connect()

        cursor = sex.cursor()
        cursor.execute(f"Select team.outgoing,team,statement,CONVERT(VARCHAR,statement_date,104),counter FROM (SELECT team.outgoing, count (passport_serial) as counter FROM team JOIN person_team ON team.outgoing=person_team.outgoing GROUP BY team.outgoing) as T JOIN team ON T.outgoing=team.outgoing ORDER BY team.outgoing DESC OFFSET {offset} ROWS FETCH NEXT {limit} ROWS ONLY;")

        teams = []

        rows = cursor.fetchall()
        print("teams:")
        for row in rows:
            if row == None:
                break

            cursor.execute(f"select count(pt.outgoing) from person_team as pt inner join person_team_metadata as ptm on pt.passport_serial = ptm.passport_serial where pt.outgoing = {row[0]} and ptm.account_number_registered_in_military_id = 1")
            a = cursor.fetchone()
            
            print(row[0],"|",row[4],"\\",a[0])

            team = {
                'outgoing': row[0],
                'team': row[1],
                'statement': row[2],
                'statement_date': row[3],
                'counter': row[4]
            }

            if row[1] >= static.cfg['bank']['inside']:
                team['w2ui'] = { 'style': f"background-color: {static.cfg['bank']['color_inside']}" }
            elif row[4] == a[0]:
                team['w2ui'] = { 'style': f"background-color: {static.cfg['bank']['color_registred']}" }
            elif a[0] != 0:
                team['counter'] = f"{a[0]}/{row[4]}"
                team['w2ui'] = { 'style': f"background-color: {static.cfg['bank']['color_inteam']}" }

            teams.append(team)

        sex.close()

        return teams

