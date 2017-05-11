#!/usr/bin/env bash

apt-get update && apt-get install -y curl --allow-unauthenticated

set -ex

if [ -z $URL ]; then
  echo -e "\e[31mThe URL to test has not been set."
  exit 1
fi

# Make sure the homepage shows...

if curl -sL -w %{http_code} "$URL" -o /dev/null | grep "200"
then
    echo "The website [$URL] shows 'HTTP/1.1 200 OK' (as expected)."
else
    echo -e "\e[31mError. Not showing '200 OK' on [$URL]"
    exit 1
fi

# Make sure the /info endpoint shows...

if curl -sL -w %{http_code} "$URL/info" -o /dev/null | grep "200"
then
    echo "The website [$URL/info] shows 'HTTP Status 200 OK' (as expected)."
else
    echo -e "\e[31mError. Not showing '200 OK' on [$URL/info]"
    exit 1
fi

# Make sure the /env endpoint shows...

if curl -sL -w %{http_code} "$URL/env" -o /dev/null | grep "200"
then
    echo "The website [$URL/env] shows 'HTTP Status 200 OK' (as expected)."
else
    echo -e "\e[31mError. Not showing '200 OK' on [$URL/env]"
    exit 1
fi

# Make sure the homepage shows there is a DataBase Service bound...

if curl -s "$URL" | grep "MySQL"
then
    echo "The website [$URL] shows 'MySQL' (as expected)."
else
    echo -e "\e[31mError. Not showing 'MySQL' on [$URL]"
    exit 1
fi

# Make sure the homepage shows there is a Messaging Service bound...

if curl -s "$URL" | grep "Rabbit MQ"
then
    echo "The website [$URL] shows 'Rabbit MQ' (as expected)."
else
    echo -e "\e[31mError. Not showing 'Rabbit MQ' on [$URL]"
    exit 1
fi

# Make sure the homepage shows there is a Config Service bound...

if curl -s "$URL" | grep "Config Server"
then
    echo "The website [$URL] shows 'Config' (as expected)."
else
    echo -e "\e[31mError. Not showing 'Config' on [$URL]"
    exit 1
fi

# Make sure the homepage shows there is a Registry Service bound...

if curl -s "$URL" | grep "Service Registry"
then
    echo "The website [$URL] shows 'Registry' (as expected)."
else
    echo -e "\e[31mError. Not showing 'Registry' on [$URL]"
    exit 1
fi

# Make sure on the homepage the host name is set correctly - this means Config server integration is OK

if curl -s "$URL" | grep "Your host today was: Ben"
then
    echo -e "\e[32mThe page [$URL] shows 'Your host today was: Ben' (as expected, Spring Config Server integration is working).\e[0m"
else
    echo -e "\e[31mError. Not showing 'Your host today was: Ben' on [$URL] - Integration of Spring Config Server has regressed or failed...\e[0m"
    exit 1
fi

exit 0