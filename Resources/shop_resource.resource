*** Settings ***
Library     SeleniumLibrary
Variables   ../PageObjects/shop_locators.py

*** Keywords ***
Get Useremail
    ${email} =  Get Text    ${user_email}
    RETURN  ${email}