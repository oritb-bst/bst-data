SELECT
	DOCNO   as PROJECT_NAME,
    IVNUMA  as INVOICE_NUM,
    IVDATE  as INVOICE_DATE,
    BALDATE,
    IVNUM  as RECEIPT_NUM,  
    RINCIPALVATCODE,
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
    TIVDATE,
    FNCDATE,
	SOURCE_DB 
FROM {{ ref('ZCBS_PAYMENTRECEIPT_J') }}
--where לסנן קבלות לא זמניות