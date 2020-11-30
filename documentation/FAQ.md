## FAQs

Below is a list of frequently asked questions.

### How do i configure Jenkins' security
Using code! Check (../init.groovy.d/01_globalMatrixAuthorizationStrategy.groovy)

### Why anonymous users can trigger builds the time i spin up a new jenkins instance
Because this is how we configured it. Check (../init.groovy.d/04_allowAnonymousAccess.groovy.override)