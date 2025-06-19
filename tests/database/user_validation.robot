
*** Settings ***
Library    DatabaseLibrary
Resource   ../resources/database_keywords.robot

*** Test Cases ***
Verify User Exists In Database
    Connect To Database
    ${user_count}=    Get Number Of Rows Matching Query    SELECT COUNT(*) FROM users WHERE username = 'testuser'
    Should Be Equal As Integers    ${user_count}    1
    Disconnect From Database

Verify User Data Integrity
    Connect To Database
    ${user_data}=    Get Database Row    SELECT * FROM users WHERE username = 'testuser'
    Should Be Equal    ${user_data}[email]    testuser@example.com
    Disconnect From Database


