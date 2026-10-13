SELECT
	DOCNO   as PROJECT_NAME,
    IVNUMA  as INVOICE_NUM,
    IVDATE  as INVOICE_DATE, --תאריך תקבול  - לא נראה לי שזה תאריך החשבונית??
    BALDATE,
    IVNUM  as RECEIPT_NUM,  
    RINCIPALVATCODE, --קוד אופן תשלום
    RINCIPALVATDES,
    PEREXTRACTION,
    PRICEINOUT as TOTPRICE, --סכום התקבול/תשלום
    TOTKEREN, --סכום הקרן
    TOTMAAM, --סכום המעמ
    CASHFLOWCLASSIFDES AS CLASSIFICATION, --תקבול/תשלום
    CASE WHEN CASHFLOWCLASSIFDES = 'תקבול' THEN TOTPRICE ELSE -1*TOTPRICE END as TOTPRICE_TAZRIM, --עמודה שמחזיקה את סכום הקרן בפלוס או במינוס עבור סכימה לתזרים
    CASE WHEN CASHFLOWCLASSIFDES = 'תקבול' THEN TOTKEREN ELSE -1*TOTKEREN END as TOTKEREN_TAZRIM, --עמודה שמחזיקה את סכום הקרן בפלוס או במינוס עבור סכימה לתזרים
    CASE WHEN CASHFLOWCLASSIFDES = 'תקבול' THEN TOTMAAM ELSE -1*TOTMAAM END as TOTMAAM_TAZRIM, --עמודה שמחזיקה את סכום הקרן בפלוס או במינוס עבור סכימה לתזרים
    ACCNAME,
    ACCDES,
    TIVDATE, --תאריך תקבול/תשלום
    FNCDATE,-- תאריך ערך
	SOURCE_DB 
FROM {{ ref('ZCBS_PAYMENTRECEIPT_J') }}
--where לסנן קבלות לא זמניות

/*---------------------------------------*/
/*       הוספת תזרים עתידי חזוי        */
/*---------------------------------------*/

UNION ALL

select PROJDOCNO AS PROJECT_NAME,
       IVNUM AS INVOICE_NUM,
       IVDATE  as INVOICE_DATE, 
       null as BALDATE,   
       null as RECEIPT_NUM,  
       null as RINCIPALVATCODE, --קוד אופן תשלום
       null as RINCIPALVATDES,
       null as PEREXTRACTION,
       TOTPRICE, --כולל מעמ
       DISPRICE AS TOTKEREN, --מחיר לפני מעמ
       TOTPRICE - DISPRICE AS TOTMAAM, --סכום המעמ
       'חשבוניות ספק' as CLASSIFICATION,
       -1*TOTPRICE as TOTPRICE_TAZRIM, 
       -1*TOTKEREN  as TOTKEREN_TAZRIM,
       -1*TOTMAAM as TOTMAAM_TAZRIM,       
       SUPNAME AS ACCNAME,
       null as ACCDES,
       PAYDATE as TIVDATE, --תאריך תשלום = תאריך פרעון בחשבונית ספק
       null as FNCDATE,
       SOURCE_DB
FROM {{ ref('YINVOICES_J') }} inv
WHERE FINAL = 'Y'
AND STORNOFLAG IS NULL
AND NOT EXISTS (
    SELECT 1 
    FROM {{ ref('ZCBS_PAYMENTRECEIPT_J') }} cf
    WHERE cf.IVNUMA = inv.IVNUM
    AND cf.SOURCE_DB = inv.SOURCE_DB)


UNION ALL

select PROJDOCNO AS PROJECT_NAME,
       IVNUM AS INVOICE_NUM,
       IVDATE  as INVOICE_DATE, 
       null as BALDATE,   
       null as RECEIPT_NUM,  
       null as RINCIPALVATCODE, --קוד אופן תשלום
       null as RINCIPALVATDES,
       null as PEREXTRACTION,
       TOTPRICE, --כולל מעמ
       DISPRICE AS TOTKEREN, --מחיר לפני מעמ
       TOTPRICE - DISPRICE AS TOTMAAM, --סכום המעמ
       'חשבוניות ספק מרכזות' as CLASSIFICATION,
       -1*TOTPRICE as TOTPRICE_TAZRIM, 
       -1*TOTKEREN  as TOTKEREN_TAZRIM,
       -1*TOTMAAM as TOTMAAM_TAZRIM,       
       SUPNAME AS ACCNAME,
       null as ACCDES,
       PAYDATE as TIVDATE, --תאריך תשלום = תאריך פרעון בחשבונית ספק
       null as FNCDATE,
       SOURCE_DB
FROM {{ ref('PINVOICES_J_INC') }} inv
WHERE FINAL = 'Y'
AND STORNOFLAG IS NULL
AND NOT EXISTS (
    SELECT 1 
    FROM {{ ref('ZCBS_PAYMENTRECEIPT_J') }} cf
    WHERE cf.IVNUMA = inv.IVNUM
    AND cf.SOURCE_DB = inv.SOURCE_DB)