*** Settings ***
Library    SeleniumLibrary
Library    ../Utils/randoms.py
Library    re
Library     JSONLibrary
Library    OperatingSystem
Library    Collections
Variables    ../PageObjects/swag_loginpage_locators.py
Variables    ../TestData/TestData.py

*** Variables ***
${config_file}    TestData/Users.json

*** Keywords ***
Open My Browser
    Open Browser    ${URL_sauce}  ${browser}
    Maximize Browser Window

Close My Browser
    Close Browser

Login negatives
    [Arguments]    ${swag_user}   ${swag_password}
    Open My Browser
    Input Text    ${username}   ${swag_user}
    Input Text    ${password}   ${swag_password}
    Click Element   ${login_btn}
    Wait Until Page Contains        Swag Labs

Get User Credentials
    [Arguments]    ${user}
    ${user_config_file}=    Set Variable    ${CURDIR}/../TestData/Users.json
    ${user_data}=    Evaluate    json.load(open('${user_config_file}'))    json
    ${user_key}=    Set Variable    ${user}
    ${username}=    Set Variable    ${user_data['users']['${user_key}']['username']}
    ${password}=    Set Variable    ${user_data['users']['${user_key}']['password']}
    [Return]    ${username}    ${password}

Login
    [Arguments]    ${user}
    ${username_txt}=    Set Variable    id:user-name
    ${password_txt}=    Set Variable    id:password
    ${login_btn}=    Set Variable    id:login-button
    ${username}    ${password}=  Get User Credentials  ${user}
    Open My Browser
    Input Text    ${username_txt}    ${username}
    Input Text    ${password_txt}    ${password}
    Click Button    ${login_btn}
    Wait Until Page Contains    Swag Labs


Logout
    Click Button        ${side_bar_open}
    Wait Until Element Is Visible       ${logout}
    Click Element    ${logout}
    Close My Browser

Click Function
    [Arguments]    ${locator}
    Click Element    ${locator}

#Bill
#
#    ${calc}     Total Bill
#    ${conv}     Convert To String   ${calc}
#    RETURN  ${conv}

Get cart badge
    ${badge}=    Get Text    ${shp_cart_badge}
    RETURN  ${badge}

Reset App State
    Click Button    ${side_bar_open}
    ${ele}    Get WebElement    ${reset_app_state}
    Execute Javascript    arguments[0].click();     ARGUMENTS    ${ele}
    Wait Until Element Is Visible   ${side_bar_close}
    Click Button    ${side_bar_close}

Add All Products to Cart
    @{products}    Get WebElements    ${all_products}
    FOR    ${product}    IN    @{products}
        Click Element    ${all_products}
        Wait Until Page Contains Element    ${inv_list}
    END
    ${product_count}    Get Length    ${products}
    Set Global Variable    ${BADGE_COUNT}     ${product_count}


Sorter
    [Arguments]    ${sorter}   ${type}
    Click Element    ${sort_container}
    Click Element    ${sorter}    # Sort by price descending order
    @{product_elements}    Get WebElements    ${type}   #${prod_prices}
    ${last_product}    Set Variable    ${EMPTY}
    @{products}    Create List
    FOR    ${product}    IN    @{product_elements}
        ${product_price}    Get Text    ${product}
        Append To List    ${products}    ${product_price}
        Set Global Variable    ${last_product}
        ${last_product}   Run Keyword If    '${product}' == '${product_elements[-1]}'    Set Variable    ${product_price}
    END


    ${unsorted_prices}    Copy List    ${products}
    Sort List    ${unsorted_prices}
    Log To Console    message=sorted List: ${products}
    Log To Console    message=unSorted List: ${unsorted_prices}
    # Assert that the sorted list is not equal to the original list
    Should Not Be Equal As Strings       ${products}    ${unsorted_prices}

Enter checkout user info
    ${first_name}   Firstname
    ${last_name}    Lastname
    ${zip}  Number
    Input Text    ${first_name_txt}     ${first_name}
    Input Text    ${last_name_txt}      ${last_name}
    Input Text    ${zip_txt}    ${zip}


Get Product Price
    ${price}    Get Text    ${item_price}
    ${amount}   Amount Extract  ${price}
    [Return]    ${amount}

Get Tax amount
    ${price}    Get Text    ${item_tax}
    ${amount}   Amount Extract  ${price}
    Log To Console    amount:${amount}
    [Return]    ${amount}

calcbill
    ${price}    Get Product Price
    ${tax}  Get Tax Amount
    ${bill}     Evaluate    ${price} + ${tax}
    Log To Console    ${bill}
    RETURN  ${bill}


Get Total Amount
    ${price}    Get Text    ${total_bill}
    ${amount}   Amount Extract  ${price}
    [Return]    ${amount}

