*** Settings ***
Library     SeleniumLibrary
Variables   ../PageObjects/shop_locators.py

*** Keywords ***
Click Product 1
    Click Element    ${product1}

Add Product 1 To Cart
    Click Element    ${pdt1_addToCart}