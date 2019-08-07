# Basecamp Demo Metadata #

## Requirements ##
* Salesforce CLI installed
* jq (https://stedolan.github.io/jq/)

## Deploy metadata ##
**Please Note:** Be sure to have a Dev Hub set as default or append 
```
SCRIPT_SCRATCH_ORG_USERID=$(sfdx force:org:create -a basecamp-demo -f config/project-scratch-def.json --json | jq -r ".result.username")
echo "Username for scratch org: $SCRIPT_SCRATCH_ORG_USERID"
SCRIPT_SCRATCH_ORG_RECORDTYPEID=$(sfdx force:data:soql:query -u $SCRIPT_SCRATCH_ORG_USERID -q "select id from RecordType where sobjecttype='Account' and name='Person Account'" --json | jq -r ".result.records[0].Id")
echo "Record Type ID for Person Account: $SCRIPT_SCRATCH_ORG_RECORDTYPEID"
sfdx force:mdapi:deploy -d ./mdapi/unpackaged -w 100 -u $SCRIPT_SCRATCH_ORG_USERID
sfdx force:user:permset:assign -n Basecamp_Survey_Admin -u $SCRIPT_SCRATCH_ORG_USERID
sfdx force:org:open -u $SCRIPT_SCRATCH_ORG_USERID
sfdx force:user:password:generate -u $SCRIPT_SCRATCH_ORG_USERID --json | jq -r ".result.password"
ehco "***** >>>> Be sure to set IP Relaxation on the ConnectedApp to 'Relax IP restrictions' to enable use of the ConnectedApp without Security Token"
```
