from flask import Blueprint, json, render_template, request, redirect, url_for
from utils import *

base = Blueprint('base', __name__)

@base.post('/find')
def find_people():
    arg = json.loads(request.data)
    kod = str(arg['kod'])[:2]+str(arg['kod'])[3:][:2]+str(arg['kod'])[6:]

    print(f"\n\n\n{kod}\n\n\n")

    found = { 'found': 'none' }
    
    # bank baze
    if found['found'] == 'none':
        person = find_in_bank(arg['kod'])
        if person != None:
            found = { 'found': person, 's': 'bank' }

            return found

    # ipriziv
    if static.loginCheck:
        persons = get_persons()['data']
   
        for person in persons:
            
            if get_passport(person) == kod:
                found = { 'found': person, 's': 'ipriziv' }

    return found

@base.get('/base/')
def base_get():
    rqt = json.loads(request.args.get('request'))

    if 'sort' not in rqt:
        persons = json.dumps(get_persons_db(rqt['limit'],rqt['offset']))
    else:  
        sort1 = rqt['sort'][0]
        persons = json.dumps(get_persons_db(rqt['limit'],rqt['offset'],sort = f"{sort1['field']} {sort1['direction']}"))


    return "{ "+f"\"records\": {persons}, \"total\": {total_count()} "+" }"

@base.post('/search')
def search():
    #print(request.data)
    rqt = json.loads(request.data)

    persons = json.dumps(
        get_persons_db(
            limit = rqt['data']['limit'],
            offset = rqt['data']['offset'],
            id = rqt['data']['id'],
            passport = rqt['data']['passport'],
            fam=rqt['data']['lastName'],
            nam=rqt['data']['firstName'],
            par=rqt['data']['middleName'],
            card=rqt['data']['card']
        )
    )

    return persons
