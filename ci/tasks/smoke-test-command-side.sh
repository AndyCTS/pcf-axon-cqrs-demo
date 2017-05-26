#!/usr/bin/env bash

apt-get update && apt-get install -y curl uuid --allow-unauthenticated

#set -ex

if [ -z $URL ];
then
  echo -e "\e[31mThe URL to test has not been set."
  exit 1
else
  echo -e "The base URL for this smoke test is: \e[32m $URL \e[0m"
fi

# Make sure the homepage shows...

if curl -sL -w %{http_code} "$URL" -o /dev/null | grep "200"
then
    echo "[$URL] shows 'HTTP/1.1 200 OK' (as expected)."
else
    echo -e "\e[31mError. Not showing '200 OK' on [$URL]"
    exit 1
fi

# Make sure the /info endpoint shows...

if curl -sL -w %{http_code} "$URL/info" -o /dev/null | grep "200"
then
    echo "[$URL/info] shows 'HTTP Status 200 OK' (as expected)."
else
    echo -e "\e[31mError. Not showing '200 OK' on [$URL/info]"
    exit 1
fi

# Make sure the /env endpoint shows...

if curl -sL -w %{http_code} "$URL/env" -o /dev/null | grep "200"
then
    echo "[$URL/env] shows 'HTTP Status 200 OK' (as expected)."
else
    echo -e "\e[31mError. Not showing '200 OK' on [$URL/env]"
    exit 1
fi

# Make sure the homepage shows there is a DataBase Service bound...

if curl -s "$URL/dash" | grep "MySQL"
then
    echo "The website [$URL/dash] shows 'MySQL' (as expected)."
else
    echo -e "\e[31mError. Not showing 'MySQL' on [$URL/dash]"
    exit 1
fi

# Make sure the homepage shows there is a Messaging Service bound...

if curl -s "$URL/dash" | grep "Rabbit MQ"
then
    echo "The website [$URL/dash] shows 'Rabbit MQ' (as expected)."
else
    echo -e "\e[31mError. Not showing 'Rabbit MQ' on [$URL/dash]"
    exit 1
fi

# Make sure the homepage shows there is a Config Service bound...

if curl -s "$URL/dash" | grep "Config Server"
then
    echo "The website [$URL/dash] shows 'Config Server' (as expected)."
else
    echo -e "\e[31mError. Not showing 'Config Server' on [$URL/dash]"
    exit 1
fi

# Make sure the homepage shows there is a Registry Service bound...

if curl -s "$URL/dash" | grep "Service Registry"
then
    echo "The website [$URL/dash] shows 'Service Registry' (as expected)."
else
    echo -e "\e[31mError. Not showing 'Service Registry' on [$URL/dash]"
    exit 1
fi

# Make sure on the homepage the host name is set correctly - this means Config server integration is OK

if curl -s "$URL/dash" | grep "Your host today was: Ben"
then
    echo -e "The page [$URL/dash] shows 'Your host today was: Ben' (as expected, Spring Config Server integration is working)."
else
    echo -e "\e[31mError. Not showing 'Your host today was: Ben' on [$URL/dash] - Integration of Spring Config Server has regressed or failed...\e[0m"
    exit 1
fi


export UUID=`uuid`
export PRODUCT_ID=`curl -s -H "Content-Type:application/json" -d "{\"id\":\"${UUID}\", \"name\":\"test-${UUID}\"}" ${URL}/add`
if [ "$PRODUCT_ID" = "$UUID" ]
then
    echo -e "The command [$URL/add] for Product $UUID returned ID $PRODUCT_ID (as expected)."
else
    echo -e "\e[31mError. Product ID $UUID wasn't returned as expected (got $PRODUCT_ID) \e[0m"
    exit 1
fi


echo -e "\e[32mCOMMAND-SIDE SMOKE TEST FINISHED - ZERO ERRORS ;D "
exit 0