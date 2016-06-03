import pymorphy2
import db

try:
    with db.mysql.cursor() as cursor:
        sql = "SELECT * FROM `exercises` WHERE status is NULL"
        cursor.execute(sql)
        exercises = cursor.fetchall()
    with db.mysql.cursor() as cursor:
        sql = "SELECT * FROM `figures`"
        cursor.execute(sql)
        figures = cursor.fetchall()
    with db.mysql.cursor() as cursor:
        sql = "SELECT * FROM `feature_figures`"
        cursor.execute(sql)
        feature_figures = cursor.fetchall()
    data_information = {}
    for exercise in exercises:
        c_exercise = exercise['content']

        #разбиение текста по словам
        clear_l = [x for x in c_exercise.split(' ') if x != '']
        clear_l = [w.replace('\xad', '') for w in clear_l]
        #приведение всех к слов к нижнему регистру
        lower_l = [x.lower() for x in clear_l]

        morph = pymorphy2.MorphAnalyzer()
        normal_words = [morph.parse(str(w))[0].normal_form for w in lower_l]
        string_normal_exercise = ' '.join(normal_words)
        with db.mysql.cursor() as cursor:
            sql = "INSERT INTO `normal_exercises` (`content`, `exercise_id`) VALUES (%s, %s)"
            cursor.execute(sql, (string_normal_exercise, exercise['id']))

    db.mysql.commit()
finally:
    db.mysql.close()

