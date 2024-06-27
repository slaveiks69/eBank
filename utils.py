import requests, urllib.parse, socket
import datetime as siski
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
        
        try:
            req = self.session.post(f'http://{self.cfg["black"]["host"]}/api/login?database={self.cfg["black"]["database"]}&password={self.cfg["black"]["password"]}')
        except requests.exceptions.ConnectionError:
            self.status = 503
            return

        if req.status_code != 200:
            self.status = 666
            return
        
        self.loginCheck = True
        self.status = 200

    
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
        sex = connect()

        cursor = sex.cursor()
        cursor.execute(f"SELECT count(*) FROM person;")

        row = cursor.fetchone()

        if row == None:
            return None
        
        return row[0]
    
def count_add():
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        sex = connect("Day_Statistic")

        db_table = "count_add_edit"

        cursor = sex.cursor()
        cursor.execute(f"SELECT * FROM dbo.{db_table} WHERE name_pc = '{static.pc_name}';")

        row = cursor.fetchone()

        if row == None:
            query = f"INSERT INTO dbo.{db_table}(name_pc, ip, count) VALUES('{static.pc_name}', '{static.pc_ip}', 1)"
            cursor.execute(query)
            sex.commit()
        else:
            query = f"UPDATE dbo.{db_table} SET count = {row[3]+1} WHERE id={row[0]}"
            cursor.execute(query)
            sex.commit()        

        sex.close()



def get_persons_db(limit,offset):
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        sex = connect()

        cursor = sex.cursor()
        cursor.execute(f"SELECT *, CONVERT(VARCHAR,birth_date,104), CONVERT(VARCHAR,passport_issue_date,104) FROM person ORDER BY id DESC OFFSET {offset} ROWS FETCH NEXT {limit} ROWS ONLY;")

        persons = []

        for row in cursor:
            if row == None:
                break
            
            person = {
                'id': row[0],
                'passportSerial': str((row[1])),
                'lastName': row[2],
                'firstName': row[3],
                'patronymic': row[4],
                'birthDate': row[17],
                'birthPlace': row[6],
                'passportIssue': row[7],
                'passportIssueDate': row[18],
                'passportDivisionCode': row[9],
                'address': row[10],
                'phoneHome': row[11],
                'phoneMobile': row[12],
                'recruimentId': row[13],
                'codeword': row[14],
                'dateAdd': row[15]
            }
            import codecs
            print(codecs.decode(row[1], codecs.utf_8_encode, 'strict'))
            # print(row[1])
            persons.append(person)

        sex.close()

        return persons


def find_in_bank(kod):
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        sex = connect()

        cursor = sex.cursor()
        cursor.execute(f"SELECT * FROM person WHERE passport_serial = '{kod}';")

        row = cursor.fetchone()

        if row == None:
            return None

        person = {
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
        sex.close()

        return person

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
        sex = connect()

        cursor = sex.cursor()
        bd = siski.datetime.strptime(birth_date,"%d.%m.%Y").strftime("%Y-%m-%d")
        pid = siski.datetime.strptime(passport_issue_date,"%d.%m.%Y").strftime("%Y-%m-%d")
        phone_home = phone_home.replace('(','').replace(')','').replace('-','')[2:]
        query = f"INSERT INTO person(passport_serial, last_name, first_name, patronymic, birth_date, birth_place, passport_issue, passport_issue_date, passport_division_code, phone_home, phone_mobile, address, recruitment_office_id, codeword) VALUES('{passport_serial}', '{last_name}', '{first_name}', '{patronymic}', '{bd}', '{birth_place}', '{passport_issue}', '{pid}', '{passport_division_code}','{phone_home}','{phone_home}','{address}','{recruitment_office_id}','{codeword}')"
        cursor.execute(query)
        sex.commit()

        cursor.execute(f"SELECT * FROM person WHERE id = {cursor.lastrowid};")
        row = cursor.fetchone()

        person = {
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
        sex.close()

        return person

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
        sex = connect()

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

            person = {
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
            sex.close()

            return person


def get_persons(take = 0):
    static.login()
    if static.status != 200:
        return f'error {static.status}'
        
    if static.loginCheck == True:
        
        time_stamps = get_datetime_now_day()

        uri = f'http://{static.cfg["black"]["host"]}/api/recruits?take={take}&requireTotalCount=true&filter='+urllib.parse.quote_plus(f'[["state","=","CommandDeclared"],"or",["state","=","Delivered"],"or",[["dispatchedAt",">=","{time_stamps[0]}T00:00:00+03"],"and",["dispatchedAt","<","{time_stamps[1]}T00:00:00+03"]]]')

        req = static.session.get(uri)

        if req.status_code != 200:
            ...

        v = req.json()

        return v

def get_passport(person):
    passport = person['passport']
    #print(person)
    passport = passport['series'].strip() + passport['number'].strip()
    return passport

def check_local_database():
    try:
        sex = connect()
        sex.close()
        return True
    except:
        return False