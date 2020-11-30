## FAQs

Below is a list of frequently asked questions.

### How do i configure Jenkins' security
Using code! Check [here](../init.groovy.d/01_globalMatrixAuthorizationStrategy.groovy.override)

### Why anonymous users can trigger builds the time i spin up a new Jenkins instance
Because this is how we configured it. Check [here](../init.groovy.d/04_allowAnonymousAccess.groovy.override)