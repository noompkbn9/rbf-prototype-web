
import pymysql
from config import DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME
from robot.api import logger

class DatabaseUtils:

    def __init__(self):
        self.connection = None

    def connect_to_database(self):
        try:
            self.connection = pymysql.connect(
                host=DB_HOST,
                port=int(DB_PORT),
                user=DB_USER,
                password=DB_PASSWORD,
                database=DB_NAME
            )
            logger.info("Successfully connected to the database.")
        except Exception as e:
            logger.error(f"Error connecting to database: {e}")
            raise

    def disconnect_from_database(self):
        if self.connection:
            self.connection.close()
            logger.info("Disconnected from the database.")

    def execute_query(self, query, fetch_one=False):
        if not self.connection:
            raise Exception("Not connected to database. Call connect_to_database first.")
        try:
            with self.connection.cursor(pymysql.cursors.DictCursor) as cursor:
                cursor.execute(query)
                if fetch_one:
                    return cursor.fetchone()
                else:
                    return cursor.fetchall()
        except Exception as e:
            logger.error(f"Error executing query: {query} - {e}")
            raise

    def get_number_of_rows(self, query):
        result = self.execute_query(query)
        return len(result)


