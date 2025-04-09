from flask import Blueprint, json, request, session
from sio import sio

global_export = Blueprint('global_export', __name__)

@global_export.post('/delete')
def deleteOne():
    rqt = json.loads(request.data)

    gea.passport.deleteOne(rqt['data'])

    gea.get_all()

    return {'okey': 's'}

@global_export.get('/dict')
def get_dict():
    if 'ged' not in session:
        session['ged'] = {}

    dict = gea.static.get_dict_persons(session['ged'])
    return dict

from export import export_post

@global_export.get('/export')
def get_export():
    dict = get_dict()

    session['ged'] = {}

    sio.broadcast('clear_export','')

    return export_post(True, dict)

    

@global_export.get('/dictt')
def get_dict_test():
    for i, v in session.items():
        print(i,v)
    return '<br>'.join(map(str, session.items()))

class gea:
    #global_export_dict = {}
    static = None

    @classmethod
    def get_all(self):
        sio.broadcast('test', session['ged'])

    class passport:
        def add(id,login):
            if 'ged' not in session:
                session['ged'] = {}

            dicta = session['ged']
            dicta[(str)(id)] = login

            session['ged'] = dicta
            session.modified = True

            sio.broadcast('add_one', id)

        def deleteLogin(login):
            for key, value in enumerate(session['ged'].items()):
                if value == login:
                    dicta = session['ged']

                    del dicta[(str)(key)]
                    session.modified = True

                    session['ged'] = dicta

        def deleteOne(id):
            dicta = session['ged']

            del dicta[(str)(id)]

            session['ged'] = dicta
            session.modified = True

            sio.broadcast('delete_one', id)