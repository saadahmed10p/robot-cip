*** Settings ***
Library    SeleniumLibrary
Resource    ../Resources/register_resource.resource
Variables    ../TestData/TestData.py
Library    ../Utils/randoms.py

*** Variables ***

*** Test Cases ***
User should be able to open browser
    Open My Browser    ${URL}   ${browser}
    Page Should Contain    ${page_title}

User should be able to fill registeration form
    Enter First Name    ${first_name}
    Enter Last Name    ${last_name}
    ${first} =  emails
    Enter Email    ${first}
