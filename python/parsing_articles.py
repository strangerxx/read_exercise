import conf
import parser_habr as ph

exit()
try:
    with conf.mysql.cursor() as cursor:
# Read a single record
        sql = "SELECT * FROM `hubs` WHERE status is NULL"
        cursor.execute(sql)

        hubs = cursor.fetchall()
    parser = ph.ParserHabr(conf.hub_url)
    for hub in hubs:
        parser.prefix = conf.hub_url + hub['url'] + 'all/'

        nomer_page, max_page = 1, 522
        while nomer_page < max_page:
            hub_page = 'page' + str(nomer_page) + '/'

            parser.get_url(hub_page)
            articles = parser.parse_article_on_hub_pages()

            for article in articles:

                with conf.mysql.cursor() as cursor:
                    sql = "SELECT * FROM `articles` WHERE `hub_id` = %s AND `url` = %s"
                    cursor.execute(sql, (hub['id'], article[1]))
                    check_article = cursor.fetchone()

                    if not check_article:
                        sql = "INSERT INTO `articles` (`hub_id`, `title`, `url`, `date`) VALUES (%s, %s, %s, %s)"
                        cursor.execute(sql, (hub['id'], article[0], article[1], article[2]))
            conf.mysql.commit()

            # print(nomer_page)
            nomer_page += 1
        with conf.mysql.cursor() as cursor:
            sql = "UPDATE `hubs` SET `status`=1 WHERE `id` = %s"
            cursor.execute(sql, (hub['id']))
        conf.mysql.commit()
finally:
    conf.mysql.close()
