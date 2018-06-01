import os
import sqlite3


BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATABASE_FILE = os.path.join(BASE_DIR, 'milionar_db.sqlite3')


class DBManager:
    def __init__(self):
        self.db = DATABASE_FILE


    def getFetchAllFromDB(self, query):
        db = sqlite3.connect(self.db, detect_types=sqlite3.PARSE_DECLTYPES | sqlite3.PARSE_COLNAMES)
        cursor = db.cursor()
        cursor.execute(query)
        try:
            result = [[str(item) for item in results] for results in cursor.fetchall()]
        except:
            result = None
        return result

    def getFetchOneFromDB(self, query):
        db = sqlite3.connect(self.db, detect_types=sqlite3.PARSE_DECLTYPES | sqlite3.PARSE_COLNAMES)
        cursor = db.cursor()
        cursor.execute(query)
        try:
            allData = [r for r in cursor.fetchone()]
        except:
            allData = None
        db.close()
        return allData

    def FetchOne(self, query):
        db = sqlite3.connect(self.db, detect_types=sqlite3.PARSE_DECLTYPES | sqlite3.PARSE_COLNAMES)
        cursor = db.cursor()
        cursor.execute(query)
        try:
            allData = [r for r in cursor.fetchone()][0]
        except:
            allData = None
        db.close()
        return allData

    def executeQuery(self, query):
        db = sqlite3.connect(self.db, detect_types=sqlite3.PARSE_DECLTYPES | sqlite3.PARSE_COLNAMES)
        cursor = db.cursor()
        cursor.execute(query)
        db.commit()
        db.close()
        return cursor.lastrowid

    def executeMany(self, query, t_list):
        db = sqlite3.connect(self.db, detect_types=sqlite3.PARSE_DECLTYPES | sqlite3.PARSE_COLNAMES)
        cursor = db.cursor()
        cursor.executemany(query, t_list)
        db.commit()
        #db.close()
        return cursor.lastrowid

    @staticmethod
    def __dict_factory(cursor, row):
        d = {}
        for idx, col in enumerate(cursor.description):
            d[col[0]] = row[idx]
        return d

    def getFetchOneFromDB_dict(self, query):
        db = sqlite3.connect(self.db, detect_types=sqlite3.PARSE_DECLTYPES | sqlite3.PARSE_COLNAMES)
        db.row_factory = self.__dict_factory
        cur = db.cursor()
        cur.execute(query)
        return cur.fetchone()

    def getFetchOneFromDB_new(self, query):
        db = sqlite3.connect(self.db, detect_types=sqlite3.PARSE_DECLTYPES | sqlite3.PARSE_COLNAMES)
        db.row_factory = self.__dict_factory
        cur = db.cursor()
        cur.execute(query)
        return cur.fetchone()

    def getFetchAllFromDB_dict(self, query):
        db = sqlite3.connect(self.db, detect_types=sqlite3.PARSE_DECLTYPES |
                                                   sqlite3.PARSE_COLNAMES)
        db.row_factory = self.__dict_factory
        cur = db.cursor()
        cur.execute(query)
        return cur.fetchall()

    @staticmethod
    def __list_factory(cursor, row):
        list_ = list()
        for key, value in enumerate(cursor.description):
            list_.append(row[key])
        return list_

    def getFetchAllFromDB_list(self, query):
        db = sqlite3.connect(self.db, detect_types=sqlite3.PARSE_DECLTYPES |
                                                   sqlite3.PARSE_COLNAMES)
        #dbmanager.row_factory = self.__list_factory
        cur = db.cursor()
        cur.execute(query)
        results = []
        try:
            result = [item[0] for item in cur.fetchall()]
        except:
            result = []
        return result

if __name__ == '__main__':
    pass