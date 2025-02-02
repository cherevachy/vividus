Meta:
    @epic vividus-plugin-web-app

Lifecycle:
Examples:
|windowsTitle|indexTitle       |vivdus-test-site                                           |
|Windows     |Vividus Test Site|${vividus-test-site-url}/windows.html|


Scenario: Verify step with "is equal to": "When I switch to window with title that $stringComparisonRule `$title`"
Given I am on a page with the URL '<vivdus-test-site>'
Then the page title is equal to '<windowsTitle>'
When I click on element located by `id(plain)`
When I switch to window with title that is equal to `<indexTitle>`
Then the page title is equal to '<indexTitle>'
When I close the current window
Then the page title is equal to '<windowsTitle>'


Scenario: Verify step with "contains": "When I switch to window with title that $stringComparisonRule `$title`"
Given I am on a page with the URL '<vivdus-test-site>'
Then the page title is equal to '<windowsTitle>'
When I click on element located by `id(plain)`
When I switch to window with title that contains `<indexTitle>`
Then the page title is equal to '<indexTitle>'
When I close the current window
Then the page title is equal to '<windowsTitle>'


Scenario: Verify step: "When I wait `$duration` until window with title that $comparisonRule `$windowTitile` appears and switch to it"
Given I am on a page with the URL '<vivdus-test-site>'
Then the page title is equal to '<windowsTitle>'
When I click on element located by `id(timeout)`
When I wait `PT3S` until window with title that is equal to `<indexTitle>` appears and switch to it
Then the page title is equal to '<indexTitle>'
When I close the current window
Then the page title is equal to '<windowsTitle>'


Scenario: Verify step: "When I switch to frame located `$locator`"
Given I am on a page with the URL '${vividus-test-site-url}/nestedFrames.html'
When I change context to element located `id(toRemove):a`
When I execute javascript `
document.querySelector('#toRemove').remove();
return [];
` and save result to scenario variable `result`
When I switch to frame located `id(parent)`
When I switch to frame located `id(exampleCom)`
When I click on element located by `xpath(//a)`


Scenario: Verify steps: "When I reset context" AND "When I change context to element located `$locator`"
When I change context to element located `By.xpath(//body)`
Then number of elements found by `By.xpath(html)` is equal to `0`
When I reset context
Then number of elements found by `By.xpath(html)` is equal to `1`


Scenario: Verify step: "When I change context to element located `$locator` in scope of current context"
Given I am on a page with the URL '${vividus-test-site-url}'
When I change context to element located `xpath(//a)`
When I change context to element located `xpath(.//*)` in scope of current context
When I save `name` attribute value of context element to scenario variable `name`
Then `${name}` is = `vividus-logo`


Scenario: Verify step: "When I reset context"
When I change context to element located `By.xpath(//body)`
Then number of elements found by `By.xpath(html)` is equal to `0`
When I reset context
Then number of elements found by `By.xpath(html)` is equal to `1`


Scenario: Should switch to first visible parent frame or main document if the current frame is closed
Given I am on a page with the URL '${vividus-test-site-url}/frames.html'
When I click on element located by `id(modalButton)`
When I wait until element located by `id(modalWindow)` appears
When I switch to frame located `id(firstFrame)`
When I switch to frame located `id(secondFrame)`
When I click on element located by `id(close)`
Then number of elements found by `id(modalButton)` is equal to `1`


Scenario: Verify context healing
Given I am on a page with the URL '${vividus-test-site-url}'
When I change context to element located `tagName(a)`
When I execute javascript `location.reload();` with arguments:
Then number of elements found by `cssSelector(img)` is = `1`


Scenario: Verify step: "When I attempt to close current window with possibility to handle alert" with alert
Meta:
    @requirementId 2314
When I open URL `${vividus-test-site-url}/onbeforeunloadAlert.html` in new window
Then an alert is not present
When I click on element located by `xpath(//a[text() = 'here'])`
When I attempt to close current window with possibility to handle alert
Then an alert is present
When I dismiss alert with message which matches `.*`
When I wait until an alert disappears
Then an alert is not present
When I attempt to close current window with possibility to handle alert
Then an alert is present
When I accept alert with message which matches `.*`
When I switch to window with title that is equal to `Vividus Test Site`
Then number of elements found by `By.xpath(//img[@name='vividus-logo'])` is equal to `1`


Scenario: Verify step: "When I attempt to close current window with possibility to handle alert" without alert
Meta:
    @requirementId 2314
Given I am on a page with the URL '${vividus-test-site-url}'
When I open URL `${vividus-test-site-url}/onbeforeunloadAlert.html` in new window
Then an alert is not present
When I attempt to close current window with possibility to handle alert
Then number of elements found by `By.xpath(//img[@name='vividus-logo'])` is equal to `1`

Scenario: Verify step: "When I open new tab" (new tab doesn't inherit the state of the previous tab and can't handle alert)
When I open new tab
Given I am on a page with the URL '${vividus-test-site-url}/onbeforeunloadAlert.html'
Then an alert is not present
When I click on element located by `xpath(//a[text() = 'here'])`
!-- No alert should be shown and tab should be kept open, but focus should be switched to another tab
When I attempt to close current window with possibility to handle alert
Then the page title is equal to 'Vividus Test Site'
Then number of elements found by `By.xpath(//img[@name='vividus-logo'])` is equal to `1`
