#asocApiKeyId='xxxxxxxxxxxxx'
#asocApiKeySecret='xxxxxxxxxxxxx'
#serviceUrl='xxxxxxxxxxxxx'
#asocAppName='xxxxxxxxxxxxx'

asocToken=$(curl -k -s -X POST --header 'Content-Type:application/json' --header 'Accept:application/json' -d '{"KeyId":"'"$asocApiKeyId"'","KeySecret":"'"$asocApiKeySecret"'"}' "https://$serviceUrl/api/v4/Account/ApiKeyLogin" | grep -oP '(?<="Token":\ ")[^"]*')

if [ -z "$asocToken" ]; then
	echo "The token variable is empty. Check the authentication process.";
    exit 1
fi

appData=$(curl -s -k -X GET --header 'Authorization: Bearer '"$asocToken"'' --header 'Accept:application/json' "https://$serviceUrl/api/v4/Apps?%24filter=Name%20eq%20%27$asocAppName%27")

appOverallCompliance=$(echo $appData | jq '.Items[0].OverallCompliance')
echo "$appOverallCompliance"

appCompliances=$(echo $appData | jq -r '.Items[0].ComplianceStatuses[] | "Enabled: \(.Enabled) | Name: \(.Name) | Compliant: \(.Compliant)"')
echo "$appCompliances"

curl -k -s -X 'GET' "https://$serviceUrl/api/v4/Account/Logout" -H 'accept: */*' -H "Authorization: Bearer $asocToken"
