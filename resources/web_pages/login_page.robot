*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${USERNAME_FIELD}    id=username
${PASSWORD_FIELD}    id=password
${LOGIN_BUTTON}      id=loginButton
${ERROR_MESSAGE}     id=errorMessage
${WELCOME_MESSAGE}   id=welcomeMessage

*** Keywords ***
Input Username
    [Arguments]    ${username}
    Input Text    ${USERNAME_FIELD}    ${username}

Input Password
    [Arguments]    ${password}
    Input Text    ${PASSWORD_FIELD}    ${password}

Click Login Button
    Click Button    ${LOGIN_BUTTON}

Login With Valid Credentials
    [Arguments]    ${username}    ${password}
    Input Username    ${username}
    Input Password    ${password}
    Click Login Button

Login With Invalid Password
    [Arguments]    ${username}    ${password}
    Input Username    ${username}
    Input Password    ${password}
    Click Login Button

Verify Successful Login
    Page Should Contain Element    ${WELCOME_MESSAGE}
    Element Text Should Be    ${WELCOME_MESSAGE}    Welcome, username!

Verify Error Message
    [Arguments]    ${expected_message}
    Page Should Contain Element    ${ERROR_MESSAGE}
    Element Text Should Be    ${ERROR_MESSAGE}    ${expected_message}


