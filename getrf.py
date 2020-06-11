"""
Gets RFs from the rfpy database.  NOTE: This is the old RFPY format which is no longer
accessible.  Will need to update this to be compatible with new RFPY database
"""
import sqlite3
from sqlite3 import Error
import sys
def create_conn(db_file):
    try:
        conn = sqlite3.connect(db_file)
        return conn
    except Error as e:
        print(e)
    return None

def get_data(conn,table):
    cur = conn.cursor()
    sql = """SELECT rfpath from '{}' WHERE selected = '0'""".format(table)
    cur.execute(sql)
    rows = cur.fetchall()
    return rows

if __name__ == "__main__":
    db = "/Users/khomman/Documents/PythonPackages/rfweb/rfweb/db/rftns.db"
    gaussians = ['10','25','50']
    #netsta = 'US_ERPA_'
    netsta = sys.argv[1]
    conn = create_conn(db)
    paths = []
    for gauss in gaussians:
        table = netsta + gauss
        with conn:
            rows = get_data(conn,table)
        for i in rows:
            paths.append(i[0])


    with open('rftnLocs.txt','w') as f:
        for path in paths:
            f.write(path+'\n')
