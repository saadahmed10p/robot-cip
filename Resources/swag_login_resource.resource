*** Settings ***
Library    SeleniumLibrary
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