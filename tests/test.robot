*** Settings ***
Library    SeleniumLibrary    run_on_failure=SeleniumLibrary.Capture Page Screenshot

*** Test Cases ***
Chrome
        Open Browser with chrome
        Open Browser with firefox
        Open Browser with edge
        [Teardown]      teardown

*** Keywords ***
Open Browser with chrome
        SeleniumLibrary.Open Browser    url=https://www.google.com       browser=chrome              remote_url=http://selenium-hub:4444/wd/hub
        Builtin.Sleep  30s
        SeleniumLibrary.Capture Page Screenshot
        Close browser
Open Browser with firefox
        SeleniumLibrary.Open Browser    url=https://www.google.com       browser=firefox              remote_url=http://selenium-hub:4444/wd/hub
        Builtin.Sleep  30s
        SeleniumLibrary.Capture Page Screenshot
        Close browser
Open Browser with edge
        SeleniumLibrary.Open Browser    url=https://www.google.com       browser=edge              remote_url=http://selenium-hub:4444/wd/hub
        Builtin.Sleep  30s
        SeleniumLibrary.Capture Page Screenshot
        Close browser

teardown
        Close Browser

Close Browser
        SeleniumLibrary.Close Browser