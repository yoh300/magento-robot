*** Settings ***
Documentation     A test suite with a single Gherkin style test.
...
...               This test is functionally identical to the example in
...               valid_login.robot file.
Resource          resource.robot
Test Teardown     Close Browser

*** Test Cases ***
XXXXXGC
    Open Browser    http://localhost    chrome
    Capture Page Screenshot
    Close All Browsers
YYYYYFF
    Open Browser    http://localhost    ff
    Capture Page Screenshot
    Close All Browsers

*** Keywords ***
Browser is opened to google
    Open browser to google

