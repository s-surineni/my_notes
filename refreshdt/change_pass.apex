List<User> userList = new List<User>();
userList = [SELECT Id from User WHERE IsActive = true AND ProfileId = '00eZ6000000QVJjIAO' AND Id != '005Z6000000EWN1IAO'];
for (User u : userList)
{
System.setPassword(u.Id, 'test12345     ');
    System.debug('______DONE_____');
}
update userList;


List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();

// Query for users matching the criteria
for (User u : [SELECT Id FROM User WHERE IsActive = true AND Username LIKE '%admin%' AND Username != 'ss@sldsp2.com']) {
    // Define PermissionSet Ids in a list
    List<String> permissionSetIds = new List<String>{
        '0PSZ60000005RouOAE',
        '0PSZ60000009hS8OAI',
        '0PSZ6000000DO8POAW'
    };

    // Create PermissionSetAssignments for each PermissionSetId and add to permissionSetList
    for (String psId : permissionSetIds) {
    if(u.Id != '005Z6000000NYAk' && u.Id !='005Z6000000EfJg') {
        permissionSetList.add(new PermissionSetAssignment(PermissionSetId = psId, AssigneeId = u.Id));
        }
    }
}

// Insert all PermissionSetAssignments
insert permissionSetList;


t/CME-Core-Zion/W-16384438/kondo-class
