import pymysql.cursors

# Connect to the database
mysql = pymysql.connect(host='localhost',
                             user='root',
                             password='180489',
                             db='read_exercise',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)
