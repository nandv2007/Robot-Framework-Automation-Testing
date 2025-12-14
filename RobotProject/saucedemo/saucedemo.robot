*** Settings ***
Library    SeleniumLibrary
Library    DebugLibrary
Suite Setup    Open Browser To Login Page
Suite Teardown    Close Browser

*** Variables ***
${BASE_URL}        https://www.saucedemo.com/
${BROWSER}         chrome
${VALID_USER}      standard_user
${VALID_PASS}      secret_sauce
${USERNAME_INPUT}      //*[@id="user-name"]
${PASSWORD_INPUT}      //*[@id="password"]
${LOGIN_BUTTON}        //*[@id="login-button"]
${ERROR_MESSAGE}       //*[@id="login_button_container"]/div/form/div[3]
${PRODUCT_SORT}        //*[@id="header_container"]/div[2]/div/span/select
${INVENTORY_ITEM}  //*[@id="inventory_container"]/div/div[1]
${INVENTORY_FIRST_NAME}  //*[@id="item_4_title_link"]/div
${CART_FIRST_NAME}   //*[@id="item_4_title_link"]/div
${CART_ICON}  //*[@id="shopping_cart_container"]
${CART_ITEM}  //*[@id="cart_contents_container"]/div/div[1]/div[3]
${CHECKOUT_BUTTON}   //*[@id="checkout"]
${FIRST_NAME}  //*[@id="first-name"]
${LAST_NAME}  //*[@id="last-name"]
${POSTAL_CODE}  //*[@id="postal-code"]
${CONTINUE_BUTTON}  //*[@id="continue"]
${FINISH_BUTTON}  //*[@id="finish"]
${MENU_BUTTON}  //*[@id="react-burger-menu-btn"]
${LOGOUT_LINK}  //*[@id="logout_sidebar_link"]

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    ${LOGIN_BUTTON}    10s

Login With Credentials
    [Arguments]    ${username}    ${password}
    Input Text    ${USERNAME_INPUT}    ${username}
    Input Text    ${PASSWORD_INPUT}    ${password}
    Click Button    ${LOGIN_BUTTON}

Login As Standard User
    Login With Credentials    ${VALID_USER}    ${VALID_PASS}
    Wait Until Page Contains Element    ${INVENTORY_ITEM}    10s

Add Any Product To Cart
    Click Button    xpath=(//button[contains(@class,"btn_inventory")])[1]

Go To Cart
    Click Element    ${CART_ICON}
    Wait Until Page Contains Element    ${CART_ITEM}    10s

Start Checkout
    Click Button    ${CHECKOUT_BUTTON}
    Wait Until Element Is Visible    ${FIRST_NAME}    10s

Fill Checkout Information
    [Arguments]    ${first}    ${last}    ${zip}
    Input Text    ${FIRST_NAME}    ${first}
    Input Text    ${LAST_NAME}     ${last}
    Input Text    ${POSTAL_CODE}   ${zip}
    Click Button    ${CONTINUE_BUTTON}

Logout From Application
    Click Button    ${MENU_BUTTON}
    Wait Until Element Is Visible    ${LOGOUT_LINK}    5s
    Click Element    ${LOGOUT_LINK}
    Wait Until Element Is Visible    ${LOGIN_BUTTON}    10s

*** Test Cases ***
login_1  #Userid matches
    Login As Standard User
    Page Should Contain Element    ${INVENTORY_ITEM}

login_2  #password mismatch
    Login With Credentials    ${VALID_USER}    wrong_password
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    10s
    Page Should Contain Element    ${ERROR_MESSAGE}

login_3  #login button works
    Login With Credentials    ${VALID_USER}    ${VALID_PASS}
    Wait Until Page Contains Element    ${INVENTORY_ITEM}    10s

filter_1  #arrange A-Z

    Login As Standard User
    Select From List By Value    ${PRODUCT_SORT}    az
    ${names}=    Get Webelements    css=.inventory_item_name
    ${first_name}=    Get Text    ${names}[0]
    ${last_name}=     Get Text    ${names}[-1]
    Should Be True    '${first_name}' < '${last_name}'

filter_2  #arrange Z-A

    Login As Standard User
    Select From List By Value    ${PRODUCT_SORT}    za
    ${names}=    Get Webelements    css=.inventory_item_name
    ${first_name}=    Get Text    ${names}[0]
    ${last_name}=     Get Text    ${names}[-1]
    Should Be True    '${first_name}' > '${last_name}'

cart_1  #add to cart
    Login As Standard User
    Add Any Product To Cart
    Go To Cart
    Page Should Contain Element    ${CART_ITEM}

cart_2  #products in cart
    Login As Standard User
    ${inventory_name}=    Get Text    ${INVENTORY_FIRST_NAME}
    Click Button    xpath=(//button[contains(@class,"btn_inventory")])[1]
    Click Element    ${CART_ICON}
    Wait Until Page Contains Element    ${CART_ITEM}    10s
    ${cart_name}=    Get Text    ${CART_FIRST_NAME}
    Should Be Equal    ${inventory_name}    ${cart_name}


cart_3  #remove product from cart option
    [Documentation]    Verify remove option exists for cart items. [file:21]
    Login As Standard User
    Add Any Product To Cart
    Go To Cart
    Page Should Contain Element    xpath=//button[contains(text(),"Remove")]

cart_4  #removing product
    [Documentation]    Verify product is removed when clicking Remove. [file:21]
    Login As Standard User
    Add Any Product To Cart
    Go To Cart
    Click Button    xpath=//button[contains(text(),"Remove")]
    Page Should Not Contain Element    ${CART_ITEM}

layout_1  #icon placements
    Login As Standard User
    Page Should Contain Element    ${CART_ICON}
    Page Should Contain Element    ${MENU_BUTTON}

checkout_1  #checkout details
    Login As Standard User
    Add Any Product To Cart
    Go To Cart
    Start Checkout
    Page Should Contain Element    ${FIRST_NAME}
    Page Should Contain Element    ${POSTAL_CODE}
    Fill Checkout Information    nand    v    12345
    Page Should Contain Element    ${FINISH_BUTTON}

logout  #logout returns to login page
    Login As Standard User
    Logout From Application
    Page Should Contain Element    ${LOGIN_BUTTON}
