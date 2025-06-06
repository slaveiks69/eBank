#from flask import session
from flask_login import LoginManager

import requests, urllib.parse, socket
import datetime as siski
from global_export import gea
#from config import *
import pymssql

import yaml

def get_config():
    with open("config.yaml", encoding="UTF-8") as f:
        cfg = yaml.load(f, Loader=yaml.FullLoader)
        
        return cfg

class static:
    session = requests.Session()
    pc_name = socket.gethostname()
    pc_ip = socket.gethostbyname(pc_name)
    loginCheck = False
    status = 0
    baseCheck = False
    cfg = get_config()
    user_login = ''
    uri = ''

    def __init__(self):
        gea.static = self

    @classmethod
    def get_dict_persons(self, dict):
        self.baseCheck = check_local_database()

        if len(dict) == 0:
            return {}
        
        dicta = dict

        if self.baseCheck == True:
            with pymssql.connect(self.cfg["sql"]["hostname"], self.cfg["sql"]["user"], self.cfg["sql"]["password"], self.cfg["sql"]["database"]) as sex:

                cursor = sex.cursor()

                cursor.execute(f"SELECT *,CONVERT(VARCHAR,birth_date,104) FROM person WHERE id in({', '.join(map(str, dict))});")
                rows = cursor.fetchall()

                dungeonmasters = []

                for row in rows:
                    passport_serial = row[1]

                    if (len(passport_serial.split(' ')) == 4):
                        passport_serial = "АС"+passport_serial[2:]

                    dungeonmaster = {
                        'id': row[0],
                        'passportSerial': passport_serial,
                        'lastName': row[2],
                        'firstName': row[3],
                        'patronymic': row[4],
                        'birthDate': row[17],
                        'birthPlace': row[6],
                        'passportIssue': row[7],
                        'passportIssueDate': row[8],
                        'passportDivisionCode': row[9],
                        'address': row[10],
                        'phoneHome': row[11],
                        'phoneMobile': row[12],
                        'recruimentId': row[13],
                        'codeword': row[14],
                        'dateAdd': row[15],
                        'login': dicta[(str)(row[0])]
                    }

                    dungeonmasters.append(dungeonmaster)

                return dungeonmasters

    @classmethod
    def get_total_count(self):
        persons = get_persons(1)
        if self.loginCheck == False:
            return persons
        return persons['totalCount']
    
    @classmethod
    def login(self):
        if self.cfg["default"]["ipriziv"] == False: 
            return
        if self.status == 503: return
        if self.loginCheck == True: return
        
        uri = f'http://{self.cfg["black"]["host"]}/api/login?database={self.cfg["black"]["database"]}&password={self.cfg["black"]["password"]}'
        print(uri)
        try:
            req = self.session.post(uri)
        except requests.exceptions.ConnectionError:
            self.status = 503
            return
        
        if req.status_code != 200:
            self.status = 666
            return
        
        self.loginCheck = True
        self.status = 200

gea.static = static()

def get_datetime_now_day():
    now = siski.datetime.now()
    now_plus_1 = now + siski.timedelta(days=1)

    #2024-05-30 & 2024-05-30 + 1 day

    v = [now.strftime("%Y-%m-%d"),now_plus_1.strftime("%Y-%m-%d")]

    print(v)

    return v

def get_recruits_statistic():
    static.login()
    if static.status != 200:
        return f'error {static.status}'
    
    if static.loginCheck == True:
        url = "http://black:33380/api/recruits/statistic"

        req = static.session.get(url)

        if req.status_code != 200:
            ...

        v = req.json()

        sum = 0

        for recruits in v['militaryOfficeStatistic']:
            sum = sum + recruits['deliveredCount']

        return { "deliveredCount": sum }

    #http://black:33380/api/recruits/statistic
    #[["deliveredAt",">=","2024-06-03T00:00:00+03"],"and",["deliveredAt","<","2024-06-04T00:00:00+03"]]
    #[[["deliveredAt",">=","2024-06-03T00:00:00+03"],"and",["deliveredAt","<","2024-06-04T00:00:00+03"]],"and",["state","=","Returned"]]

def connect(db = static.cfg["sql"]["database"]):
    return pymssql.connect(static.cfg["sql"]["hostname"], static.cfg["sql"]["user"], static.cfg["sql"]["password"], db)

def total_count():
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        with connect() as sex:

            cursor = sex.cursor()
            cursor.execute(f"SELECT count(*) FROM person;")

            row = cursor.fetchone()

            if row == None:
                return None
            
            return row[0]
        
def create_user(login,password_hash):
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        with connect() as sex:

            cursor = sex.cursor()

            cursor.execute(f"select count(login) from users where login = '{login}';")
            row = cursor.fetchone()
            if row[0] == 0:
                cursor.execute(f"INSERT INTO users(login,password,root) VALUES('{login}','{password_hash}',0);")
                sex.commit()

def get_user(login):
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        with connect() as sex:
            cursor = sex.cursor()
            cursor.execute(f"select * from users where login = '{login}';")
            row = cursor.fetchone()

            myu = user(row[0],row[1],row[2],row[3])

            return myu

def get_user_id(id):
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        with connect() as sex:
            cursor = sex.cursor()
            cursor.execute(f"select * from users where id = {id};")
            row = cursor.fetchone()

            myu = user(row[0],row[1],row[2],row[3])

            return myu

class user:
    auth = False

    def __init__(self,id,login,password,root):
        self.id = id
        self.login = login
        self.password = password
        self.root = root
        static.user_login = login

    def is_authenticated(self):
        static.user_login = self.login
        return self.auth
    
    def get_id(self):
        static.user_login = self.login
        return self.id
    
    def is_active():
        return True
    
    def is_anonymous():
        return False
        

from werkzeug.security import generate_password_hash, check_password_hash

def generate_hash(password):
    return generate_password_hash(password)

def check_hash(login,password):
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        with connect() as sex:
            cursor = sex.cursor()
            cursor.execute(f"select password from users where login = '{login}';")
            row = cursor.fetchone()

            if row == None:
                return False

            return check_password_hash(row[0], password)
            
        
def total_count_team():
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        with connect() as sex:

            cursor = sex.cursor()
            cursor.execute(f"SELECT count(*) FROM team;")

            row = cursor.fetchone()

            if row == None:
                return None
            
            return row[0]
    
def count_add(login):
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        sex = connect("Day_Statistic")

        db_table = "user_statistic"

        cursor = sex.cursor()
        cursor.execute(f"SELECT * FROM dbo.{db_table} WHERE login = '{login}';")

        row = cursor.fetchone()

        if row == None:
            query = f"INSERT INTO dbo.{db_table}(login, count) VALUES('{login}', 1)"
            cursor.execute(query)
            sex.commit()
        else:
            query = f"UPDATE dbo.{db_table} SET count = {row[2]+1} WHERE id={row[0]}"
            cursor.execute(query)
            sex.commit()        

        sex.close()

def passportSerial(a):
    if (len(a.split(' ')) == 4):
        return "АС"+a[2:]
    return a

def get_persons_db(limit,offset, sort = "person.id DESC", id = "", passport = "", fam = "", nam = "", par = "", card = ""):
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        with connect() as sex:

            id = f"WHERE CAST(person.id as CHAR) LIKE '{id}%'"
            nam = f"AND first_name LIKE '{nam}%'"
            fam = f"AND last_name LIKE '{fam}%'"
            par = f"AND patronymic LIKE '{par}%'"
            passport = f"AND person.passport_serial LIKE '%{passport}%'"
            if card != "":
                card = f"AND account_number LIKE '%{card}%'"
            if sort == "":
                sort = "person.id DESC"

            sql = f"SELECT person.*, CONVERT(VARCHAR,birth_date,104), CONVERT(VARCHAR,passport_issue_date,104), person_team.outgoing, team, account_number, account_number_registered_in_military_id as registered, plog.login FROM person LEFT OUTER JOIN person_log as plog ON person.id = plog.id LEFT OUTER JOIN person_team_metadata ON person.passport_serial = person_team_metadata.passport_serial LEFT OUTER JOIN person_card ON person.passport_serial = person_card.passport_serial LEFT OUTER JOIN person_team ON person.passport_serial = person_team.passport_serial LEFT OUTER JOIN recruitment_office_name ON recruitment_office_name.id = person.recruitment_office_id LEFT OUTER JOIN team ON person_team.outgoing = team.outgoing LEFT OUTER JOIN person_orphan ON person.passport_serial = person_orphan.passport_serial {id} {fam} {nam} {par} {passport} {card} ORDER BY {sort} OFFSET {offset} ROWS FETCH NEXT {limit} ROWS ONLY;"
            print(sql)
            cursor = sex.cursor()
            cursor.execute(sql)

            persons = []
            i = 0

            for row in cursor:
                if row == None:
                    break
                
                dungeonmaster = {
                    'recid': i,
                    'id': row[0],
                    'passportSerial': passportSerial(row[1]),
                    'last_name': row[2],
                    'first_name': row[3],
                    'patronymic': row[4],
                    'birth_date': row[17],
                    'birthPlace': row[6],
                    'passportIssue': row[7],
                    'passportIssueDate': row[18],
                    'passportDivisionCode': row[9],
                    'address': row[10],
                    'phoneHome': row[11],
                    'phoneMobile': row[12],
                    'recruimentId': row[13],
                    'codeword': row[14],
                    'dateAdd': row[15],
                    'outgoing': row[19],
                    'team': row[20],
                    'accountNumber': row[21],
                    'who': row[23]
                }
                
                dungeonmaster['w2ui'] = { 'style': "" }
                style = {}

                if row[20] != None:
                    print(row, row[20])
                    if (int)(row[20]) < static.cfg['bank']['inside']:
                        style['outgoing'] = f"background-color: {static.cfg['bank']['color_inteam']}"
                        style['team'] = f"background-color: {static.cfg['bank']['color_inteam']}"
                        

                if row[22] != None:
                    if row[22] == 1:
                        style['accountNumber'] = f"background-color: {static.cfg['bank']['color_registred']};"
            
                dungeonmaster['w2ui'] = { 'style': style }
#style['lastName'] = f"background-color: {color};"

                i = i + 1
                persons.append(dungeonmaster)

            return persons


def find_in_bank(kod: str):
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        with connect() as sex:
            cursor = sex.cursor()

            sql = f"SELECT *,CONVERT(VARCHAR,birth_date,104), person_card.account_number, plog.login FROM person LEFT OUTER JOIN person_log as plog ON person.id = plog.id LEFT OUTER JOIN person_card ON person.passport_serial = person_card.passport_serial WHERE person.passport_serial = '{kod}';"
            print(sql)
            cursor.execute(sql)

            row = cursor.fetchone()
            
            if row == None:
                return None

            dungeonmaster = {
                'id': row[0],
                'passportSerial': passportSerial(row[1]),
                'passport': passportSerial(row[1]),
                'lastName': row[2],
                'firstName': row[3],
                'patronymic': row[4],
                'middleName': row[4],
                'birthDate': row[5],
                'birthDateFormated': row[22],
                'birthPlace': row[6],
                'passportIssue': row[7],
                'passportIssueDate': row[8],
                'passportDivisionCode': row[9],
                'address': row[10],
                'phoneHome': row[11],
                'phoneMobile': row[12],
                'recruimentId': row[13],
                'codeword': row[14],
                'dateAdd': row[15],
                'card': row[23],
                'who': row[24]
            }

            return dungeonmaster

def find_in_bank_fio(lastName, firstName, middleName):
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        with connect() as sex:

            cursor = sex.cursor()
            cursor.execute(f"SELECT *,CONVERT(VARCHAR,birth_date,104) FROM person WHERE last_name = '{lastName}' and first_name = '{firstName}' and patronymic = '{middleName}';")

            row = cursor.fetchone()

            if row == None:
                return None

            dungeonmaster = {
                'id': row[0],
                'passport': passportSerial(row[1]),
                'lastName': row[2],
                'firstName': row[3],
                'patronymic': row[4],
                'middleName': row[4],
                'birthDate': row[5],
                'birthDateFormated': row[17],
                'birthPlace': row[6],
                'passportIssue': row[7],
                'passportIssueDate': row[8],
                'passportDivisionCode': row[9],
                'address': row[10],
                'phoneHome': row[11],
                'phoneMobile': row[12],
                'recruimentId': row[13],
                'codeword': row[14],
                'dateAdd': row[15]
            }

            return dungeonmaster

def add_person_bd(
        passport_serial, 
        last_name, 
        first_name, 
        patronymic, 
        birth_date, 
        birth_place, 
        passport_issue, 
        passport_issue_date,    
        passport_division_code,
        address,
        phone_home,
        recruitment_office_id,
        codeword
    ):

    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        with connect() as sex:

            cursor = sex.cursor()
            bd = siski.datetime.strptime(birth_date,"%d.%m.%Y").strftime("%Y-%m-%d")
            pid = siski.datetime.strptime(passport_issue_date,"%d.%m.%Y").strftime("%Y-%m-%d")
            phone_home = phone_home.replace('(','').replace(')','').replace('-','')[2:]
            query = f"INSERT INTO person(passport_serial, last_name, first_name, patronymic, birth_date, birth_place, passport_issue, passport_issue_date, passport_division_code, phone_home, phone_mobile, address, recruitment_office_id, codeword) VALUES('{passport_serial}', '{last_name}', '{first_name}', '{patronymic}', '{bd}', '{birth_place}', '{passport_issue}', '{pid}', '{passport_division_code}','{phone_home}','{phone_home}','{address}','{recruitment_office_id}','{codeword}')"
            cursor.execute(query)
            sex.commit()

            cursor.execute(f"SELECT * FROM person WHERE id = {cursor.lastrowid};")
            row = cursor.fetchone()

            dungeonmaster = {
                'id': row[0],
                'passportSerial': passport_serial,
                'lastName': row[2],
                'firstName': row[3],
                'patronymic': row[4],
                'birthDate': row[5],
                'birthPlace': row[6],
                'passportIssue': row[7],
                'passportIssueDate': row[8],
                'passportDivisionCode': row[9],
                'address': row[10],
                'phoneHome': row[11],
                'phoneMobile': row[12],
                'recruimentId': row[13],
                'codeword': row[14],
                'dateAdd': row[15]
            }

            return dungeonmaster

def edit_person_bd(
        id,
        passport_serial, 
        last_name, 
        first_name, 
        patronymic, 
        birth_date, 
        birth_place, 
        passport_issue, 
        passport_issue_date,    
        passport_division_code,
        address,
        phone_home,
        recruitment_office_id,
        codeword
    ):

    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        with connect() as sex:

            cursor = sex.cursor()
            cursor.execute(f"SELECT * FROM person WHERE id = {id};")
            row = cursor.fetchone()

            if row != None:

                bd = siski.datetime.strptime(birth_date,"%d.%m.%Y").strftime("%Y-%m-%d")
                pid = siski.datetime.strptime(passport_issue_date,"%d.%m.%Y").strftime("%Y-%m-%d")
                phone_home = phone_home.replace('(','').replace(')','').replace('-','')[2:]
                query = f"UPDATE person SET passport_serial = '{passport_serial}', last_name = '{last_name}', first_name = '{first_name}', patronymic = '{patronymic}', birth_date = '{bd}', birth_place = '{birth_place}', passport_issue = '{passport_issue}', passport_issue_date = '{pid}', passport_division_code = '{passport_division_code}', address = '{address}', phone_home = '{phone_home}', phone_mobile = '{phone_home}', recruitment_office_id = {recruitment_office_id}, codeword = '{codeword}' WHERE id={id}"
                cursor.execute(query)
                sex.commit()
                
                cursor = sex.cursor()
                cursor.execute(f"SELECT * FROM person WHERE id = {id};")
                row = cursor.fetchone()

                dungeonmaster = {
                    'id': row[0],
                    'passportSerial': row[1],
                    'lastName': row[2],
                    'firstName': row[3],
                    'patronymic': row[4],
                    'birthDate': row[5],
                    'birthPlace': row[6],
                    'passportIssue': row[7],
                    'passportIssueDate': row[8],
                    'passportDivisionCode': row[9],
                    'address': row[10],
                    'phoneHome': row[11],
                    'phoneMobile': row[12],
                    'recruimentId': row[13],
                    'codeword': row[14],
                    'dateAdd': row[15]
                }

                return dungeonmaster


def get_persons(take = 0):
    static.login()
    if static.status != 200:
        return f'error {static.status}'
        
    if static.loginCheck == True:
        
        time_stamps = get_datetime_now_day()

        uri = f'http://{static.cfg["black"]["host"]}/api/recruits?take={take}&requireTotalCount=true&filter='+urllib.parse.quote_plus(f'[["state","=","Delivered"],"or",[["state","=","DeliverDeclared"],"and",[["expectedDate",">=","{time_stamps[0]}T00:00:00+03"],"and",["expectedDate","<","{time_stamps[1]}T00:00:00+03"]]]]')
        print(uri)
        req = static.session.get(uri)

        if req.status_code != 200:
            print(f"\nBLACK NO CONNECT | REASON: {req.reason} | STATUS: {static.status}\n")
            return {'totalCount':'0'}

        v = req.json()
        
        return v

def get_passport(person):
    passport = person['passport']
    #print(person)
    passport = passport['series'].strip() + passport['number'].strip()
    return passport

def check_local_database():
    try:
        with connect():
            return True
    except:
        return False