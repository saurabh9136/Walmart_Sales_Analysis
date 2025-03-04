
from sqlalchemy import create_engine
'''
Reason I don't use environment variables, so a person who use my project can easily make changes
and run project
'''
def get_engine():
    host = 'localhost'
    port = 3306
    user = 'root'
    password = 'root'
    database = 'walmart_data'

    try:
        engine_sql = create_engine(f"mysql+pymysql://{user}:{password}@{host}:{port}/{database}")
        return engine_sql
    except Exception as e:
        print("Error connecting to database:", e)
        return None
