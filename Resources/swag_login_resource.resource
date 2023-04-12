*** Settings ***
Library    SeleniumLibrary
Library    Collections

Variables    ../PageObjects/swag_loginpage_locators.py
Variables    ../TestData/TestData.py

*** Keywords ***
Open My Browser
    Open Browser    ${URL_sauce}  ${browser}
    Maximize Browser Window

Close My Browser
    Close Browser

Login
    [Arguments]    ${swag_user}   ${swag_password}
    Open My Browser
    Input Text    ${username}   ${swag_user}
    Input Text    ${password}   ${swag_password}
    Click Element   ${login_btn}
    Wait Until Page Contains        Swag Labs

Logout
    Click Button        ${side_bar_open}
    Wait Until Element Is Visible       ${logout}
    Click Element    ${logout}
    Close My Browser

Click Function
    [Arguments]    ${locator}
    Click Element    ${locator}

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

Sort Products by Name Descending Order
    Click Element    ${sort_container}
    Click Element    ${name_sort_desc}    # Sort again to change the order to descending
    @{product_elements}    Get WebElements    ${prod_names}
    ${last_product}        Set Variable    ${EMPTY}
    @{product_labels}    Create List
    FOR    ${product}    IN    @{product_elements}
        ${product_name}    Get Text    ${product}
        Append To List    ${product_labels}    ${product_name}
        Set Global Variable     ${last_product}
        ${last_product}    Run Keyword If    '${product}' == '${product_elements[-1]}'     Set Variable    ${product_name}
    END
    Log To Console    ${last_product}
    Log To Console    ${product_labels}


#Sort Products by Price in Ascending Order
    #Click Element    ${sort_container}
    #Click Element    ${prod_price_asc}    # Sort by price ascending order
    #${product_elements}    Get WebElements    ${prod_prices}
    #${last_product_price}    Set Variable    ${EMPTY}
    #FOR    ${product}    IN    @{product_elements}
        #${product_price}    Get Text    ${product}
        #Set Global Variable     ${last_product_price}
        #${last_product_price}   Run Keyword If    '${product}' == '${product_elements[-1]}'    Set Variable        ${product_price}
    #END

Sort Products by Price (Ascending/Descending)
    [Arguments]    ${sorter}
    Click Element    ${sort_container}
    Click Element    ${sorter}    # Sort by price descending order
    @{product_elements}    Get WebElements    ${prod_prices}
    ${last_product_price}    Set Variable    ${EMPTY}
    @{product_prices}    Create List
    FOR    ${product}    IN    @{product_elements}
        ${product_price}    Get Text    ${product}
        Append To List    ${product_prices}    ${product_price}
        Set Global Variable    ${last_product_price}
        ${last_product_price}   Run Keyword If    '${product}' == '${product_elements[-1]}'    Set Variable    ${product_price}
    END
     Log To Console    ${last_product_price}
     Log To Console    ${product_prices}



Sort Products by Price or Name (Ascending/Descending)
    [Arguments]    ${sorter}
    Click Element    ${sort_container}
    Click Element    ${sorter}    # Sort by price descending order

    #@{product_elements}    Get WebElements    ${prod_names}
    #@{product_elements}    Get WebElements    ${prod_prices}

    ${last_product_price}    Set Variable    ${EMPTY}
    ${last_product}        Set Variable    ${EMPTY}

    #@{product_prices}    Create List
    #@{product_labels}    Create List


    IF  "${sorter}" == "${name_sort_desc}"
    @{product_elements}    Get WebElements    ${prod_names}
    @{product_labels}    Create List
        FOR    ${product}    IN    @{product_elements}
        ${product_name}    Get Text    ${product}
        Append To List    ${product_labels}    ${product_name}
        Set Global Variable     ${last_product}
        ${last_product}    Run Keyword If    '${product}' == '${product_elements[-1]}'     Set Variable    ${product_name}
        END
    Log To Console    ${last_product}
    Log To Console    ${product_labels}

    ELSE
    @{product_elements}    Get WebElements    ${prod_prices}
    @{product_prices}    Create List
         FOR    ${product}    IN    @{product_elements}
        ${product_price}    Get Text    ${product}
        Append To List    ${product_prices}    ${product_price}
        Set Global Variable    ${last_product_price}
        ${last_product_price}   Run Keyword If    '${product}' == '${product_elements[-1]}'    Set Variable    ${product_price}
        END
     Log To Console    ${last_product_price}
     Log To Console    ${product_prices}
    END


    #Log To Console    ${last_product_price}
    #Log To Console    ${product_prices}
    #Log To Console    ${product_names}


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
     Log To Console    ${last_product}
     Log To Console    ${products}