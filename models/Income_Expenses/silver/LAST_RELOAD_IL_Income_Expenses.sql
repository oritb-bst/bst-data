--חשוב מאוד שישאר בתוך טבלה ולא VIEW
--כי אחרת כל פעם שקליק יגש לנתונים זמן עדכון גם יתעדכן ואם שומרים בטבלה אז ערך יהיה של ריצת DBT
--שומרת ערך כמחרוזת כי קליקסנס הופך ערך בחזרה

SELECT

  CURRENT_TIMESTAMP() AS current_ts,

  TO_VARCHAR(
    CONVERT_TIMEZONE(
        'Asia/Jerusalem',
        CURRENT_TIMESTAMP()
    ) ,
    'YYYY-MM-DD HH24:MI'
)AS LAST_REFRESH_IL



    