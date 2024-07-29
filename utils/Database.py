import mysql.connector

class Database():
    def __del__(self):
        self._conn.close()

    def connect(self, config):
        self._conn = mysql.connector.connect(
            host=config['host'],
            user=config['user'],
            password=config['password'],
            database=config['database']
        )
    
    def get_daily_volume(self, day):
        cursor = self._conn.cursor()

        query = "SELECT symbol, max(volume), avg(volume)\
            FROM daily\
            WHERE date<%s and date>DATE_SUB(%s, INTERVAL 10 DAY)\
            GROUP BY symbol"
        cursor.execute(query, (day, day))

        return cursor.fetchall()
