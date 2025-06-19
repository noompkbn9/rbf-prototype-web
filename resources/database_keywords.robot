*** Settings ***
Library    DatabaseLibrary

*** Keywords ***
Connect To Database
    ${DB_HOST}=        Get Environment Variable    DB_HOST
    ${DB_PORT}=        Get Environment Variable    DB_PORT
    ${DB_NAME}=        Get Environment Variable    DB_NAME
    ${DB_USER}=        Get Environment Variable    DB_USER
    ${DB_PASSWORD}=    Get Environment Variable    DB_PASSWORD
    Connect To Database Using Custom Params    pymysql    db_api_parameters=host=${DB_HOST},port=${DB_PORT},database=${DB_NAME},user=${DB_USER},password=${DB_PASSWORD}

Disconnect From Database
    Disconnect From Database


