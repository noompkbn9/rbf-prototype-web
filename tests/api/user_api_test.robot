
*** Settings ***
Library    RequestsLibrary
Resource   ../resources/api_keywords.robot

*** Test Cases ***
Get User By ID
    Create Session    my_session    ${API_BASE_URL}
    ${resp}=    Get Request    my_session    /users/1
    Should Be Equal As Strings    ${resp.status_code}    200
    ${user_data}=    Convert To Json    ${resp.json()}
    Should Be Equal As Strings    ${user_data}[id]    1
    Should Be Equal As Strings    ${user_data}[name]    Leanne Graham


