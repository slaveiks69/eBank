from flask import Blueprint, json, render_template, request, redirect, url_for
from utils import *

monitoring = Blueprint('monitoring', __name__)


@monitoring.get('/')
def monitoring_home():

    return render_template('monitoring.html', uri=static.uri)

@monitoring.get('/count')
def get_count():
    sex = connect("Day_Statistic")

    cursor = sex.cursor()
    cursor.execute("select MAX(login) as 'login', SUM(count) as 'count' from user_statistic group by login order by SUM(count) desc")

    pc = []

    for row in cursor:
        if row == None:
            break

        pc_json = {
            'login': row[0],
            'count': row[1]
        }

        pc.append(pc_json)

    return json.dumps(pc)
        



@monitoring.get('/reset')
def reset_stat():
    sex = connect("Day_Statistic")

    cursor = sex.cursor()
    cursor.execute("delete from user_statistic")

    sex.commit()

    sex.close()

    return { "complete": "true" }