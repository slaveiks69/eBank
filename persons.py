from flask import Blueprint, json, render_template, request, redirect, url_for
from flask_login import current_user

from utils import *

persons = Blueprint('persons', __name__)

import re

def capitalize_tajics(str):
    joins = ' '
    tajics = ['оглы','уулу','улы','угли']

    if str.find('-') != -1:
        joins = '-'

    str = re.split(' |-', str)

    b = []

    for a in str:
        if a.lower() in tajics:
            a = a.lower()
        else:
            a = a.capitalize()
        b.append(a)

    x = joins.join(a for a in b)

    return x.strip()

#from global_export import gea

@persons.post('/add-person')
def add_person():
    arg = json.loads(request.data)

    if current_user.root == 0:
        return ''

    person = add_person_bd(
        arg['passport_serial'], 
        capitalize_tajics(arg['last_name']), 
        capitalize_tajics(arg['first_name']), 
        capitalize_tajics(arg['patronymic']), 
        arg['birth_date'], 
        arg['birth_place'], 
        arg['passport_issue'], 
        arg['passport_issue_date'], 
        arg['passport_division_code'], 
        arg['address'],
        arg['phone_home'],
        arg['recruitment_office_id'],
        arg['codeword']
    )

    count_add(arg['login'])
    log(person['id'],arg['login'])

    gea.passport.add(person['id'],arg['login'])

    return { 'reload': 'add', 'person': person }

def log(id,login):
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        with connect() as sex:
            sql = f"INSERT INTO person_log(id,login) VALUES('{id}','{login}');"
            cursor = sex.cursor()
            cursor.execute(sql)
            sex.commit()

@persons.post('/edit-person')
def edit_person():
    arg = json.loads(request.data)

    if current_user.root == 0:
        return ''

    person = edit_person_bd(
        arg['id'],
        arg['passport_serial'], 
        capitalize_tajics(arg['last_name']), 
        capitalize_tajics(arg['first_name']), 
        capitalize_tajics(arg['patronymic']), 
        arg['birth_date'], 
        arg['birth_place'], 
        arg['passport_issue'], 
        arg['passport_issue_date'], 
        arg['passport_division_code'], 
        arg['address'],
        arg['phone_home'],
        arg['recruitment_office_id'],
        arg['codeword']
    )

    #count_add()
    gea.passport.add(arg['id'],arg['login'])
    gea.get_all()

    return { 'reload': 'edit', 'person': person }

total = static.get_total_count()

@persons.get('/add/')
def add_get():
    if request.method == 'GET':
        return render_template('add.html', login_place=False, uri=static.uri, user=current_user,db_check=check_local_database(), totalCount=total, check=static.loginCheck )
    
@persons.get('/add/<kod>')
def add_get_kod(kod):
    if request.method == 'GET':
        vb = False
        if "АС" in kod:
            vb = True
        return render_template('add.html', login_place=True, uri=static.uri, user=current_user,db_check=check_local_database(), totalCount=total, check=static.loginCheck, edit_kod=kod, vb=vb)
    
@persons.post('/delete')
def delete():
    rqt = json.loads(request.data)

    id = (f"{rqt['id']}").strip()
    print(id)
    
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        with connect() as sex:

            cursor = sex.cursor()

            cursor.execute(f"SELECT * FROM person WHERE id = {id}")

            row = cursor.fetchone()

            cursor.execute(f"DELETE FROM person_log WHERE id = {id}")
            cursor.execute(f"DELETE FROM person WHERE id = {id}")
            cursor.execute(f"DELETE FROM person_card WHERE passport_serial = '{row[1]}'")
            cursor.execute(f"DELETE FROM person_team WHERE passport_serial = '{row[1]}'")
            cursor.execute(f"DELETE FROM person_team_metadata WHERE passport_serial = '{row[1]}'")
      
            sex.commit()

    return "1"
    
