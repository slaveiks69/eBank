from flask import Flask, render_template
from utils import *

app = Flask(__name__)

app.config['SERVER_NAME'] = 'localhost:1111'

from persons import persons
from base import base
from export import export
from monitoring import monitoring 
from team import team

app.register_blueprint(persons, url_prefix='/') 
app.register_blueprint(base, url_prefix='/')
app.register_blueprint(export, url_prefix='/')
app.register_blueprint(monitoring, url_prefix='/monitoring')
app.register_blueprint(team, url_prefix='/team')

@app.get('/')
def home():

    return render_template('home.html', ver=static.cfg["default"]["version"], bgimg=static.cfg["default"]["background_image"])

if __name__ == '__main__':
    print(static.pc_ip)
    app.run(debug=True)