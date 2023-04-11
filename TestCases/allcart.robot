*** Settings ***
Library    SeleniumLibrary
Library    ../Utils/randoms.py

Resource    ../Resources/swag_login_resource.resource

#Test Setup  Login    ${swag_user}   ${swag_password}
#Test Teardown   Logout
*** Test Cases ***
Add All Products to Cart
    Login    ${swag_user}   ${swag_password}
    #Wait Until Page Contains Element    xpath://div[@class='inventory_list']
    #@{products}    Get WebElements    xpath://div[@class='inventory_item_description'] / div[@class='inventory_item_label'] / a[contains(@href, '#')]
    @{products}    Get WebElements    xpath://div[contains(@class, 'inventory_item')]//button[contains(@class, 'btn_primary') ]
    FOR    ${product}    IN    @{products}
        #Click Element    ${product}
        #Wait Until Page Contains Element    xpath://div[@class='inventory_details']
        Click Element    xpath://div[contains(@class, 'inventory_item')]//button[contains(@class, 'btn_primary') ]
        #Wait Until Element Contains    ${shp_cart_badge}    ${product.index + 1}
        ${count}=   Get Cart Badge
        #Should Be Equal    ${count}    ${products}
        #Click Element    id:back-to-products
        #Reload Page
        Wait Until Page Contains Element    xpath://div[@class='inventory_list']
    END

    #Wait Until Page Contains Element    xpath://div[@class='inventory_list']
    #@{products}    Get WebElements    xpath://div[@class='inventory_item_description'] / div[@class='inventory_item_label'] / a[contains(@href, '#')]
    #FOR    ${index}    IN RANGE    ${products.__len__()}
     #   ${product}=    Set Variable    ${products[${index}]}
      #  Click Element    ${product}
       # Wait Until Page Contains Element    xpath://div[@class='inventory_details']
        #Click Element    xpath://div[contains(@class, 'inventory_details')]//button[contains(@class, 'btn_primary')]
        #Wait Until Element Contains    ${shp_cart_badge}    ${index}
    #Click Element    id:back-to-products
    #Wait Until Page Contains Element    xpath://div[@class='inventory_list']
    #END
    #Wait Until Page Contains Element    xpath://div[@class='inventory_list']
    #@{products}    Get WebElements    xpath://div[@class='inventory_item_description'] / div[@class='inventory_item_label'] / a[contains(@href, '#')]
    #FOR    ${index}    IN RANGE   0      ${products.__len__()}
     #   ${product}=    Set Variable    ${products[${index}]}
      #  Click Element    ${product}
       # Wait Until Page Contains Element    xpath://div[@class='inventory_details']
        #Click Element    xpath://div[contains(@class, 'inventory_details')]//button[contains(@class, 'btn_primary')]
        #Wait Until Element Contains    ${shp_cart_badge}    ${index+1}
    #Click Element    id:back-to-products
    #Wait Until Page Contains Element    xpath://div[@class='inventory_list']
    #END