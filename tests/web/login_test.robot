*** Settings ***
Library    SeleniumLibrary
Resource   ../resources/common_keywords.robot
Resource   ../resources/web_pages/login_page.robot

*** Test Cases ***
Successful Login
    Open Browser To Login Page
    Login With Valid Credentials    username    password
    Verify Successful Login

Invalid Login - Wrong Password
    Open Browser To Login Page
    Login With Invalid Password    username    wrong_password
    Verify Error Message    Invalid credentials


