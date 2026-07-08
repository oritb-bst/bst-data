--חשוב מאוד שישאר בתוך טבלה ולא VIEW
--כי אחרת כל פעם שקליק יגש לנתונים זמן עדכון גם יתעדכן ואם שומרים בטבלה אז ערך יהיה של ריצת DBT

SELECT

    CURRENT_TIMESTAMP() AS current_ts,

    CONVERT_TIMEZONE(
        'Asia/Jerusalem',
        CURRENT_TIMESTAMP()
    ) AS LAST_REFRESH_IL