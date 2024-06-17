import requests, urllib.parse
import datetime
from config import *
import pymssql

class static:
    session = requests.Session()
    loginCheck = False
    status = 0
    baseCheck = False
    
    @classmethod
    def get_total_count(self):
        persons = get_persons(1)
        if self.loginCheck == False:
            return persons
        return persons['totalCount']
    
    @classmethod
    def login(self):
        if self.loginCheck == True: return

        if self.status == 503: return
        
        try:
            req = self.session.post(f'http://{BLACK_Host}/api/login?database={BLACK_Database}&password={BLACK_Password}')
        except requests.exceptions.ConnectionError:
            self.status = 503
            return

        if req.status_code != 200:
            self.status = 666
            return
        
        self.loginCheck = True
        self.status = 200

    
def get_datetime_now_day():
    now = datetime.datetime.now()
    now_plus_1 = now + datetime.timedelta(days=1)

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

def find_in_bank(kod):
    static.baseCheck = check_local_database()

    if static.baseCheck == True:
        conn = pymssql.connect(SQL_Hostname, SQL_User, SQL_Password, SQL_Database)

        cursor = conn.cursor()
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
        conn.close()

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
        conn = pymssql.connect(SQL_Hostname, SQL_User, SQL_Password, SQL_Database)

        cursor = conn.cursor()
        bd = datetime.datetime.strptime(birth_date,"%d.%m.%Y").strftime("%Y-%m-%d")
        pid = datetime.datetime.strptime(passport_issue_date,"%d.%m.%Y").strftime("%Y-%m-%d")
        phone_home = phone_home.replace('(','').replace(')','').replace('-','')[2:]
        query = f"INSERT INTO person(passport_serial, last_name, first_name, patronymic, birth_date, birth_place, passport_issue, passport_issue_date, passport_division_code, phone_home, phone_mobile, address, recruitment_office_id, codeword) VALUES('{passport_serial}', '{last_name}', '{first_name}', '{patronymic}', '{bd}', '{birth_place}', '{passport_issue}', '{pid}', '{passport_division_code}','{phone_home}','{phone_home}','{address}','{recruitment_office_id}','{codeword}')"
        cursor.execute(query)
        conn.commit()

        cursor.execute(f"SELECT * FROM person WHERE id = {cursor.lastrowid};")
        row = cursor.fetchone()

        #print(row)

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
        conn.close()

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
        conn = pymssql.connect(SQL_Hostname, SQL_User, SQL_Password, SQL_Database)

        cursor = conn.cursor()
        cursor.execute(f"SELECT * FROM person WHERE id = {id};")
        row = cursor.fetchone()

        if row != None:

            bd = datetime.datetime.strptime(birth_date,"%d.%m.%Y").strftime("%Y-%m-%d")
            pid = datetime.datetime.strptime(passport_issue_date,"%d.%m.%Y").strftime("%Y-%m-%d")
            phone_home = phone_home.replace('(','').replace(')','').replace('-','')[2:]
            query = f"UPDATE person SET passport_serial = '{passport_serial}', last_name = '{last_name}', first_name = '{first_name}', patronymic = '{patronymic}', birth_date = '{bd}', birth_place = '{birth_place}', passport_issue = '{passport_issue}', passport_issue_date = '{pid}', passport_division_code = '{passport_division_code}', address = '{address}', phone_home = '{phone_home}', phone_mobile = '{phone_home}', recruitment_office_id = {recruitment_office_id}, codeword = '{codeword}' WHERE id={id}"
            cursor.execute(query)
            conn.commit()
            
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
            conn.close()

            return person


def get_persons(take = 0):
    static.login()
    if static.status != 200:
        return f'error {static.status}'
        
    if static.loginCheck == True:
        
        time_stamps = get_datetime_now_day()

        uri = f'http://{BLACK_Host}/api/recruits?take={take}&requireTotalCount=true&filter='+urllib.parse.quote_plus(f'[["state","=","CommandDeclared"],"or",["state","=","Delivered"],"or",[["dispatchedAt",">=","{time_stamps[0]}T00:00:00+03"],"and",["dispatchedAt","<","{time_stamps[1]}T00:00:00+03"]]]')

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
        conn = pymssql.connect(SQL_Hostname, SQL_User, SQL_Password, SQL_Database)
        conn.close()
        return True
    except:
        return False