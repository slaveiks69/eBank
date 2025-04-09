from pathlib import Path
from flask import Flask, json, render_template, request, redirect
from flask_login import current_user, login_required, LoginManager, login_user, logout_user
from flask_session import Session
from utils import *
from sio import *
from engineio.async_drivers import threading

from common import cache

app = Flask(__name__)

cache.init_app(app=app, config={"CACHE_TYPE": "filesystem",'CACHE_DIR': Path('/tmp')})

cfg = static.cfg

login_manager = LoginManager(app)

login_manager.login_view = 'login'

app.config['SECRET_KEY'] = 'oihu2rgjnebdUHY&@YUHEFIDijsfeirwjfkl;sdn1owslda'
app.config['SERVER_NAME'] = f"{cfg['default']['ip']}:{cfg['default']['port']}"

#Session(app)

#import redis
#app.config['SESSION_TYPE'] = 'redis'
#app.config['SESSION_REDIS'] = redis.from_url(f"redis://localhost:6379")

#sess = Session()
#sess.init_app(app)

sio(app)

socketio = sio.get()

@socketio.on('connect')
def connect_event():
    print('\nClient connected!\n')
    socketio.emit('server event', {'data': 'fucku'})

@socketio.on('connect', namespace='six')
def connect_eventsix():
    print('\n666 connected!\n')
    socketio.emit('server event', {'data': 'fuck 666'})




from persons import persons
from base import base
from export import export
from monitoring import monitoring 
from team import team
from photo import photo
from import7 import import7

from global_export import global_export
app.register_blueprint(global_export, url_prefix='/gex') 

app.register_blueprint(persons, url_prefix='/') 
app.register_blueprint(base, url_prefix='/')
app.register_blueprint(import7, url_prefix='/')
app.register_blueprint(export, url_prefix='/')
app.register_blueprint(monitoring, url_prefix='/monitoring')
app.register_blueprint(team, url_prefix='/team')
app.register_blueprint(photo, url_prefix='/photo') 

static.uri = f"http://{cfg['default']['ip']}:{cfg['default']['port']}/"

@app.get('/')
@login_required
def home():
    return render_template('home.html', uri=static.uri, me=current_user, ver=static.cfg["default"]["version"], bgimg=static.cfg["default"]["background_image"])



@login_manager.user_loader
def load_user(user_id):
    print(user_id)
    return get_user_id(user_id)

@app.get('/login')
def login():
    if(current_user.is_authenticated):
        return redirect('/')
    return render_template('login.html', uri=static.uri, ver=static.cfg["default"]["version"])

@app.post('/login')
def login_post():
    rqt = json.loads(request.data)

    isOwner = check_hash(rqt['data']['login'],rqt['data']['password'])
    if isOwner:
        myu = get_user(rqt['data']['login'])
        myu.auth = True
        login_user(myu, remember=False)
        return { 'isOwner': 'true' }
    return { 'isOwner': 'false' }

@app.get('/logout')
@login_required
def logout():
    current_user.auth = False
    logout_user()
    return redirect('/login')

@app.get('/login/<login>:<password>')
def login_test(login,password):
    isOwner = check_hash(login,password)
    print(isOwner)
    if isOwner:
        myu = get_user(login)
        myu.auth = True
        login_user(myu, remember=False)
    return render_template('login.html', ver=static.cfg["default"]["version"])
    

@app.get('/register/<login>:<password>:<secret_key>')
def register(login,password,secret_key):
    if (static.cfg["default"]["secret_key"] != secret_key):
        return "Соси БИБКУ ДУРА"
    
    hash = generate_hash(password)

    create_user(login,hash)

    return redirect("login")

if __name__ == '__main__':
    #print(static.pc_ip)
    socketio.run(app, host=f"{cfg['default']['ip']}", port=f"{cfg['default']['port']}", debug=True)
    #app.run(debug=True) #, host=f"ebank", port=666