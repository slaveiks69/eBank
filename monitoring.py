from flask import Blueprint, json, render_template, request, redirect, url_for
from utils import *

monitoring = Blueprint('monitoring', __name__)

@monitoring.get('/monitoring')
def monitoring_home():
  

    return render_template('monitoring.html')

@monitoring.post('/monitoring/reset')
def reset_stat():
    conn = connect("Day_Statistic")

    cursor = conn.cursor()
    cursor.execute("delete from [Day_Statistic].[dbo].[count_add_edit]")

    conn.commit()

    conn.close()

    return { "complete": "true" }