select 
    PROJECT_NAME as "שם פרויקט",
    PROJECT_NUMBER as "מספר פרויקט",
    TARGET_CONTROL_EXPENSES as "יעד בקרה הוצאות",
    TARGET_CONTROL_REVENUES as "יעד בקרה הכנסות",
     TARGET_MANAGEMENT_EXPENSES as "יעד הנהלה הוצאות",
    TARGET_MANAGEMENT_REVENUES as "יעד הנהלה הכנסות"


from {{ ref('CONTROL_MANAGEMENT_TARGET_STG') }}