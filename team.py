from flask import Blueprint, json, render_template, request, redirect, url_for
from utils import *

team = Blueprint('team', __name__)


@team.get('/')
def monitoring_home():
  

    return render_template('team.html')

@team.get('/outgoing')
def outgoing():
    rqt = json.loads(request.args.get('request'))

    teams = json.dumps(get_teams(rqt['limit'],rqt['offset']))



    return "{ "+f"\"records\": {teams}, \"total\": {total_count()} "+" }"

def get_teams(limit,offset):
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        sex = connect()

        cursor = sex.cursor()
        cursor.execute(f"Select team.outgoing,team,statement,CONVERT(VARCHAR,statement_date,104),counter FROM (SELECT team.outgoing, count (passport_serial) as counter FROM team JOIN person_team ON team.outgoing=person_team.outgoing GROUP BY team.outgoing) as T JOIN team ON T.outgoing=team.outgoing ORDER BY team.outgoing DESC OFFSET {offset} ROWS FETCH NEXT {limit} ROWS ONLY;")

        teams = []

        for row in cursor:
            if row == None:
                break

            team = {
                'outgoing': row[0],
                'team': row[1],
                'statement': row[2],
                'statement_date': row[3],
                'counter': row[4]
            }

            if row[1] >= static.cfg['bank']['inside']:
                team['w2ui'] = { 'style': f"background-color: {static.cfg['bank']['color_inside']}" }

            teams.append(team)

        sex.close()

        return teams
