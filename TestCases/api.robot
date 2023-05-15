*** Settings ***
Library           requests    INSECURE
Library    JSONLibrary
Library  RequestsLibrary
Library  XML
Library  BeautifulSoup
Library    ../Utils/randoms.py
Library  Collections
Library  BuiltIn
Library  OperatingSystem
Library  String

*** Variables ***
${base_url}       https://testworthy.us
${login_url}      ${base_url}/Login
${create_url}     ${base_url}/TestSuite/Create
${project_id}     1211
${test_names}      abc

#${retry_count}    3
#${retry_interval}    5s

*** Test Cases ***
API Test Example
    ${api}=             Get Token Value         ${login_url}
	Create Session    my_session    ${base_url}
	${headers}=    Create Dictionary    Accept=*/*    Content-Type=application/x-www-form-urlencoded    charset=utf-8


	# POST request with data
	${data}=    Set Variable    Id=&ProjectId=${project_id}&Name=pop&Description=&__RequestVerificationToken=${api}&X-Requested-With=XMLHttpRequest
	${response}=    POST On Session        my_session    ${create_url}    headers=${headers}    data=${data}
	Should be equal as strings    ${response.status_code}    200
	Log To Console    Request: ${response.request.method} ${response.request.url}

Login Test
    ${api}=             Get Token Value         ${login_url}
	Create Session    my_session    ${base_url}
	${headers}=    Create Dictionary    Accept=*/*    Content-Type=application/x-www-form-urlencoded    charset=utf-8


	# POST request with data
	${data}=    Set Variable    UserName=saad.ahmed%4010pearls.com&Password=10PEarls1%2B&WebAddress=&__RequestVerificationToken=${api}&X-Requested-With=XMLHttpRequest
	${response}=    POST On Session        my_session    https://testworthy.us/Login/Login    headers=${headers}    data=${data}
	Should be equal as strings    ${response.status_code}    200
	Log To Console    Request: ${response.request.method} ${response.request.url}
	Log To Console    Response:${response.content}


	###################################################


	#Create Session    my_session1    ${base_url}
	${headers}=    Create Dictionary    Accept=*/*    Content-Type=application/x-www-form-urlencoded    charset=utf-8

    ${rand_data}=   Get Random String
	# POST request with data
	${data}=    Set Variable    Id=&ProjectId=${project_id}&Name=${test_names}&Description=&__RequestVerificationToken=${api}&X-Requested-With=XMLHttpRequest
	${response}=    POST On Session        my_session    https://testworthy.us/TestSuite/Create   headers=${headers}    data=${data}
	Should be equal as strings    ${response.status_code}    200
	Log To Console    Request: ${response.request.method} ${response.request.url}
	Log To Console    Response:${response.content}

    ${json}=    Evaluate    json.loads('''${response.content}''')

    #${error_message}=    Set Variable    ${json['result']['value']['errors'][0]['message']}
    #IF  ${error_message} == EMPTY
    #${error_message}=    Set Variable    ${json['result']['value']['errors'][0]['message']}
    ${test_suite_id}=   Set Variable    ${json['result']['value']['result']['id']}

    #Log To Console    mess:${error_message}
    Log To Console    id:${test_suite_id}

#Login Test
#    ${api}=             Get Token Value         ${login_url}
#    Create Session    my_session    ${base_url}
#    ${headers}=    Create Dictionary    Accept=*/*    Content-Type=application/x-www-form-urlencoded    charset=utf-8
#
#    ${test_suite_id}=    Set Variable    None
#    ${retry_count}=    Set Variable    3
#    ${retry_interval}=    Set Variable    5
#
## Log in
#    ${data}=    Set Variable    UserName=saad.ahmed%4010pearls.com&Password=10PEarls1%2B&WebAddress=&__RequestVerificationToken=${api}&X-Requested-With=XMLHttpRequest
#    ${response}=    POST On Session        my_session    https://testworthy.us/Login/Login    headers=${headers}    data=${data}
#    Should be equal as strings    ${response.status_code}    200
#    Log To Console    Request: ${response.request.method} ${response.request.url}
#    Log To Console    Response:${response.content}
#
## Try creating a test suite
#    ${rand_data}=   Get Random String
#    ${data}=    Set Variable    Id=&ProjectId=${project_id}&Name=${rand_data}&Description=&__RequestVerificationToken=${api}&X-Requested-With=XMLHttpRequest
#
#    ${tries}=    Set Variable    0
#    ${max_tries}=    Set Variable    ${retry_count}+1
#    WHILE    '${test_suite_id}' == 'None' AND ${tries} < ${max_tries}
#    ${response}=    POST On Session    my_session    https://testworthy.us/TestSuite/Create   headers=${headers}    data=${data}
#    ${json}=    Evaluate    json.loads('''${response.content}''')
#    ${error_message}=    Set Variable If    ${'errors' in ${json['result']['value']}}    ${json['result']['value']['errors'][0]['message']}    None
#    ${test_suite_id}=   Set Variable If    '${error_message}' == 'None'    ${json['result']['value']['result']['id']}    None
#    ${tries}=    Set Variable    ${tries}+1
#    Log    Attempt ${tries} - Response: ${response.content}
#    Sleep    ${retry_interval}
#
## Check if test suite was created
#    Run Keyword If    '${test_suite_id}' == 'None'    Fail    Test suite could not be created
#    Log    Test suite created with ID: ${test_suite_id}
#    END