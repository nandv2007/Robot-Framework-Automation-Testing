*** Settings ***
Library    SeleniumLibrary

Suite Setup    Open Test Page
Suite Teardown    Close All Browsers


*** Variables ***
${BROWSER}    chrome
${URL}        https://testautomationpractice.blogspot.com/

# Form fields
${NAME}       id=name
${EMAIL}      id=email
${PHONE}      id=phone
${ADDRESS}    id=textarea
${GENDER_MALE}    id=male
${GENDER_FEMALE}  id=female
${DAYS_SUN}   id=sunday
${DAYS_MON}   id=monday
${COUNTRY}    id=country
${COLOURS}    id=colors
${ANIMALS}    id=animals
${VALID_NAME}     Test User
${VALID_EMAIL}    test@example.com
${INVALID_EMAIL}  abc123
${VALID_PHONE}    9876543210
${ADDRESS_TEXT}   123 Main Street, City

*** Keywords ***
Open Test Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    5s

*** Test Cases ***
Name_Input
    Page Should Contain Element    ${NAME}
    Input Text    ${NAME}    ${VALID_NAME}
    Textfield Value Should Be    ${NAME}    ${VALID_NAME}

Email_Input
    Page Should Contain Element    ${EMAIL}
    Input Text    ${EMAIL}    ${VALID_EMAIL}
    Textfield Value Should Be    ${EMAIL}    ${VALID_EMAIL}
    Clear Element Text    ${EMAIL}
    Input Text    ${EMAIL}    ${INVALID_EMAIL}

Phone_Input
    Page Should Contain Element    ${PHONE}
    Input Text    ${PHONE}    ${VALID_PHONE}
    Textfield Value Should Be    ${PHONE}    ${VALID_PHONE}

Address_Input
    Page Should Contain Element    ${ADDRESS}
    Input Text    ${ADDRESS}    ${ADDRESS_TEXT}
    Textarea Value Should Be    ${ADDRESS}    ${ADDRESS_TEXT}

Gender_Single_Select
    Page Should Contain Element    ${GENDER_MALE}
    Page Should Contain Element    ${GENDER_FEMALE}
    Click Element    ${GENDER_MALE}
    Radio Button Should Be Set To    gender    male
    Click Element    ${GENDER_FEMALE}
    Radio Button Should Be Set To    gender    female

Days_Multi_Select
    Page Should Contain Element    ${DAYS_SUN}
    Page Should Contain Element    ${DAYS_MON}
    Click Element    ${DAYS_SUN}
    Click Element    ${DAYS_MON}
    Checkbox Should Be Selected       ${DAYS_SUN}
    Checkbox Should Be Selected       ${DAYS_MON}
    Click Element    ${DAYS_MON}
    Checkbox Should Not Be Selected   ${DAYS_MON}

Country_Select
    Page Should Contain Element    ${COUNTRY}
    Select From List By Label      ${COUNTRY}    India
    List Selection Should Be       ${COUNTRY}    India

Colours_Select
    Page Should Contain Element    ${COLOURS}
    Select From List By Index      ${COLOURS}    1
    ${sel}=    Get Selected List Label    ${COLOURS}
    Log    Selected colour: ${sel}

Animals_Select
    Page Should Contain Element    ${ANIMALS}
    Select From List By Index      ${ANIMALS}    1
    ${sel}=    Get Selected List Label    ${ANIMALS}
    Log    Selected animal: ${sel}







