*** Settings ***
Library    SeleniumLibrary
Library    ../Utils/randoms.py

Resource    ../Resources/swag_login_resource.resource

Variables    ../Utils/variables.py

Test Setup  Login    ${swag_user}   ${swag_password}
Test Teardown   Logout

*** Variables ***


*** Test Cases ***
Successful login
    [Documentation]    Verify successful login with valid credentials
    [Tags]             Smoke
    #Login    ${swag_user}   ${swag_password}
    #Logoutttt
    Log To Console    Exceuted test case

Check Empty Cart
    [Documentation]    Verify that the cart is empty when no products are added
    [Tags]             Smoke
    #Login    ${swag_user}   ${swag_password}
    Click Function    ${shopping_cart}
    Page Should Not Contain    Remove
    #Logout

Product Detail Page
    [Documentation]    User should be able to visit the product details page
    #Login    ${swag_user}   ${swag_password}
    Click Function    ${product_1}
    Page Should Contain    Sauce Labs Backpack
    #Logout

Add Produt To Cart
    [Documentation]    User should be able to add product to cart
    #Login    ${swag_user}   ${swag_password}
    Click Function    ${add_to_cart_pdt1}
    ${count}=   Get Cart Badge
    Should Be Equal    ${count}    1
    Click Function    ${product_1}
    Page Should Contain    Remove
    #Logout

Reset App
    [Documentation]    User should be able to reset app state
    Click Function    ${add_to_cart_pdt1}
    Reset App State
    Element Should Not Be Visible    ${shp_cart_badge}
    #Logout

All Products
    [Documentation]    User should be able to add all products to cart and verify badge count
    Add All Products To Cart
    ${cart_count}    Get Text    ${shp_cart_badge}
    #${product_count}    Get Length    @{products}
    Should Be Equal As Integers    ${cart_count}    ${BADGE_COUNT}

Sort Products by name (Descending Order)
    [Documentation]    User should be able to sort products by names with decending order
    #Sort Products By Name Descending Order
    #Sort Products By Price Or Name (Ascending/Descending)    ${name_sort_desc}
    Sorter    ${name_sort_desc}     ${prod_names}
    Should Be True    '${last_product}' != '${EMPTY}'


Sort Products by price (Ascending order)
    [Documentation]    User should be able to sort products bt price with ascending order
    #Sort Products By Price (Ascending/Descending)    ${prod_price_asc}
    #Sort Products By Price Or Name (Ascending/Descending)    ${prod_price_asc}
    Sorter    ${prod_price_asc}     ${prod_prices}
    #Should Be True    '${last_product_price}' != '${EMPTY}'
    Should Be True    '${last_product}' != '${EMPTY}'


Sort Products by price (descending order)
    [Documentation]    User should be able to sort products bt price with descending order
    #Sort Products By Price (Ascending/Descending)    ${prod_price_desc}
    #Sort Products By Price Or Name (Ascending/Descending)    ${prod_price_desc}
    Sorter    ${prod_price_desc}     ${prod_prices}
    #Should Be True    '${last_product_price}' != '${EMPTY}'
    Should Be True    '${last_product}' != '${EMPTY}'

sortings
    #Sorter1    ${name_sort_desc}     ${prod_names}
    #Sorter    ${prod_price_asc}     ${prod_prices}
    #Sorter    ${prod_price_desc}     ${prod_prices}

Shopping Cart
    [Documentation]    User should be able verify items in cart
    Click Function    ${add_to_cart_pdt1}
    ${count}=   Get Cart Badge
    Should Be Equal    ${count}    1
    Click Function    ${shopping_cart}
    Page Should Contain    Sauce Labs Backpack

Checkout Page
    [Documentation]    User should be able verify Products appear on the checkout page
    Click Function    ${add_to_cart_pdt1}
    ${count}=   Get Cart Badge
    Should Be Equal    ${count}    1
    Click Function    ${shopping_cart}
    Page Should Contain    Sauce Labs Backpack
    Click Function    ${checkout_btn}

Checkout Page: verify bill
    [Documentation]    User should be able verify total billed amount
    Click Function    ${add_to_cart_pdt1}
    ${count}=   Get Cart Badge
    Should Be Equal    ${count}    1
    Click Function    ${shopping_cart}
    Page Should Contain    Sauce Labs Backpack
    Click Function    ${checkout_btn}

    Enter Checkout User Info
    Click Function    ${continue_btn}

    ${print}    Get Product Price
    ${tax}      Get Tax Amount

    Log To Console    Product Price: ${print}
    Log To Console    Tax: ${tax}

    ${bill}     Calcbill
    Log To Console    Bill is: ${bill}
    #${bill}     Bill
    ${tot_bill}     Get Total Amount
    Log To Console    Fetched Amount is: ${tot_bill}

    Should Be Equal    ${bill}     ${tot_bill}
    Click Function    ${finish_btn}

    Page Should Contain    Thank you for your order!