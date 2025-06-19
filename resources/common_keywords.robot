
*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Open Browser To Login Page
    ${WEB_APP_URL}=    Get Environment Variable    WEB_APP_URL
    Open Browser    ${WEB_APP_URL}/login    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    0.5

Close Browser
    Close All Browsers


