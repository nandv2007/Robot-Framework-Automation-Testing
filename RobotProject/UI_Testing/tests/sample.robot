*** Settings ***
Documentation   Test Example
Library     SeleniumLibrary
Library     DebugLibrary
Test Setup    Open Browser And Go To Application    ${app_url}
Test Teardown    Close Browser

*** Variables ***
${app_url}    https://saucedemo.com/
${username_input}    //input[@id="user-name"]
${password_input}    //input[@id="password"]
${uname}    standard_user
${pwd}    secret_sauce
${login}  //*[@id="login-button"]
${filter}  //*[@id="header_container"]/div[2]/div/span/select/option[1]

*** Keywords ***
Open Browser And Go To Application
    [Arguments]    ${url}
    Open Browser    ${url}    chrome
    
Verify Login Page Elements
    Wait Until Element Is Visible    ${username_input}    60s
    Wait Until Element Is Visible    ${password_input}    60s

Verify Home page Elements
    Page Should Contain Element   ${filter}
Verify login
    Input Text    ${username_input}    ${uname}
    Input Text    ${password_input}    ${pwd}
    Click Button    ${login}

*** Test Cases ***
Verify Login Functionalities
    Verify Login Page Elements
    Input Text    ${username_input}    ${uname}
    Input Text    ${password_input}    ${pwd}
    Click Button    ${login}
#    Debug
Verify filter
    Verify login
    Verify Home Page Elements
    #Select From List By Index    ${filter}

filter_1
    Verify Login
    Click Element    ${filter}

Cart_1
