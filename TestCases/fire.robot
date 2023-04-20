*** Settings ***
Library    SeleniumLibrary
#Library   Browser
Library     JSONLibrary
Library    OperatingSystem
Library    Collections

*** Test Cases ***
Search with Firefox
#    Open Browser     https://stagefarmers.cdp-container.com/    chrome
#    Maximize Browser Window
#    Input Text    id:userName   saadorganization1
#    Input Text    name:password     Pass1234!
#    Click Button    id:login-button
#    Sleep    60 seconds
    #Input Text      name=q    Robot Framework
    #Click Button    name=btnK
    #Close Browser
    #Create Webdriver    Firefox     executable_path=/usr/local/bin/geckodriver
    #Go To       https://www.google.com
    ${jsonobj}=     load json from file     TestData/Users.json
    ${name}=    Get Value From Json    ${jsonobj}   $.users.user1.username
    Log To Console    ${name[0]}