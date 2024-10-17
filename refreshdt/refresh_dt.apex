public class DecisionTableManager {
    private List<String> decisionTableNames;

    public DecisionTableManager() {
    }

    public void refreshDT() {
        // Endpoint for the refreshDecisionTable action
        String endpoint = URL.getOrgDomainURL().toExternalForm() + '/services/data/v61.0/actions/standard/refreshDecisionTable';

        // Prepare the HttpRequest
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());

        // Iterate over each Decision Table and make the call
        for (String dtName : this.decisionTableNames) {
            // Prepare the JSON body
            String body = JSON.serialize(new Map<String, Object>{
                'inputs' => new List<Object>{
                    new Map<String, String>{'decisionTableApiName' => dtName}
                }
            });
            req.setBody(body);

            // Make the callout
            try {
                Http http = new Http();
                HttpResponse res = http.send(req);

                // Check if the response is successful
                if (res.getStatusCode() != 200) {
                    // If the response is not successful, throw an exception
                    throw new DecisionTableRefreshException('Failed to refresh Decision Table ' + dtName + '. Response Status: ' + res.getStatus() +'\n error is ' +res.getBody());
                }

                System.debug('Response for ' + dtName + ': ' + res.getBody());
            } catch (Exception e) {
                throw e; // Rethrow the exception to indicate failure
            }
        }
    }

    public void fetchDtTableNames() {
        // Query all Active Decision Tables for their Developer Names
        List<String> decisionTableNameslocal = new List<String>();
        // for (DecisionTable dt : [SELECT DeveloperName FROM DecisionTable WHERE Status = 'Active']) {
        //     System.debug('dt.DeveloperName: ' + dt.DeveloperName);
        //     decisionTableNameslocal.add(dt.DeveloperName);
        // }
        decisionTableNameslocal.add('Price_Book_Entry_Decision_Table_v2');
        this.decisionTableNames = decisionTableNameslocal;
    }
}

// Custom exception class, we can update it in future as needed
public class DecisionTableRefreshException extends Exception {}

// Initiate the refresh process
DecisionTableManager dTManager = new DecisionTableManager();
dTManager.fetchDtTableNames();
dTManager.refreshDT();
