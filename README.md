# Basecamp Demo Metadata #

## Requirements ##
* Salesforce CLI installed

## Deploy metadata ##
Be sure to have a Dev Hub set as default
```
sfdx force:org:create -a basecamp-demo -f config/project-scratch-def.json --json | jq -r ".result.username"
sfdx force:mdapi:deploy -d ./mdapi/unpackaged -w 100 -u <scratch org username>
sfdx force:user:permset:assign -n Basecamp_Survey_Admin -u <scratch org username>
sfdx force:org:open -u <scratch org username>
sfdx force:user:password:generate -u scratch org username> --json | jq -r ".result.password"
```