from flask import Blueprint, json, render_template, request, redirect, url_for
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

@persons.post('/add-person')
def add_person():
    arg = json.loads(request.data)

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

    count_add()

    return { 'reload': 'add', 'person': person }

@persons.post('/edit-person')
def edit_person():
    arg = json.loads(request.data)

    person = edit_person_bd(
        arg['id'],
        arg['passport_serial'], 
        arg['last_name'],
        arg['first_name'], 
        arg['patronymic'], 
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

    count_add()

    return { 'reload': 'edit', 'person': person }

total = static.get_total_count()

@persons.get('/add/')
def add_get():
    if request.method == 'GET':
        return render_template('add.html', db_check=check_local_database(), totalCount=total, check=static.loginCheck )
    
@persons.get('/add/<kod>')
def add_get_kod(kod):
    if request.method == 'GET':
        vb = False
        if "АС" in kod:
            vb = True
        return render_template('add.html', db_check=check_local_database(), totalCount=total, check=static.loginCheck, edit_kod=kod, vb=vb)
    
