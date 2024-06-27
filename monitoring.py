from flask import Blueprint, json, render_template, request, redirect, url_for
from utils import *

monitoring = Blueprint('monitoring', __name__)

url = '/monitoring'

@monitoring.get(url)
def monitoring_home():
  

    return render_template('monitoring.html')

@monitoring.get(f'{url}/count')
def get_count():
    sex = connect("Day_Statistic")

    cursor = sex.cursor()
    cursor.execute("select MAX(name_pc) as 'name_pc', MAX(ip) as 'ip', SUM(count) as 'count' from count_add_edit group by name_pc order by SUM(count) desc")

    pc = []

    for row in cursor:
        if row == None:
            break

        pc_json = {
            'pc_name': row[0],
            'pc_ip': row[1],
            'count': row[2]
        }

        pc.append(pc_json)

    return json.dumps(pc)
        



@monitoring.get(f'{url}/reset')
def reset_stat():
    sex = connect("Day_Statistic")

    cursor = sex.cursor()
    cursor.execute("delete from count_add_edit")

    sex.commit()

    sex.close()

    return { "complete": "true" }