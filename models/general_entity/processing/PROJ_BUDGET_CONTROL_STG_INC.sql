--נצטרך להוריד בסוף INC

{{ config(enabled=false) }}

{{ config(
    materialized='table'
) }}

{% set relation_exists = false %}

{% if execute %}
  -- ניסיון בדיקה ישיר מול ה-DWH
  {% set check_query %}
    select count(*) from {{ this }} where 1=0
  {% endset %}
  
  {% set results = run_query(check_query) %}
  {% if results is not none %}
    {% set relation_exists = true %}
  {% endif %}
{% endif %}

with incoming_data as (
    select
    "PERIOD" as BUD_CONTROL_PERIOD_ID,
    DOC      as PROJECT_ID,
    DOCNO    as PROJECT_NAME,
    CONMONTH as BUD_CONTROL_MONTH,
    CONDATE  as BUD_CONTROL_DATE,
    CASE 
    WHEN TRIM(CLOSED) = 'Y' THEN '1' 
    ELSE '0' END as IS_CLOSED, --דגל האם התקציב סגור
    CURVERSION,
    SOURCE_DB,
    CASE
    WHEN TRIM(CLOSED) = 'Y' AND CONDATE = MAX(
        CASE WHEN TRIM(CLOSED) = 'Y'
        THEN CONDATE END) OVER (PARTITION BY DOC)
        THEN '1' ELSE '0' END AS IS_LATEST_CLOSED_BUDGET, --דגל שמסמן את החודש תקציב אחרון שסגור
    BSA_DATE  as SKELETON_COMPLETION_DATE, --תאריך שלד
    BSA_DATE1 as COMPLETION_HANDOVER_DATE, --תאריך סיום ומסירה
FROM {{ ref('BUD_CONTROLPERIODS_Z_J_INC') }}
)

{% if relation_exists %}

, historical_unmodified_data as (
    select h.*
   --,CAST(NULL AS VARCHAR) as PAYDATE --צריך את זה רק בפעם הראשונה שמריצים כדי להוסיף שדה
    from {{ this }} h
    left join incoming_data i
        on h.PROJECT_ID = i.PROJECT_ID
       and h.SOURCE_DB = i.SOURCE_DB
    where i.PROJECT_ID is null
)

select * from historical_unmodified_data
union all
select * from incoming_data

{% else %}

select * from incoming_data

{% endif %}

