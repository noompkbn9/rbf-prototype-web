
*** Settings ***
Library    RequestsLibrary

*** Keywords ***
Get Request
    [Arguments]    ${session}    ${path}
    ${resp}=    Get Request    ${session}    ${path}
    [Return]    ${resp}

Post Request
    [Arguments]    ${session}    ${path}    ${data}
    ${resp}=    Post Request    ${session}    ${path}    json=${data}
    [Return]    ${resp}

Convert To Json
    [Arguments]    ${response_content}
    ${json_data}=    Evaluate    json.loads('''${response_content}''')    json
    [Return]    ${json_data}


