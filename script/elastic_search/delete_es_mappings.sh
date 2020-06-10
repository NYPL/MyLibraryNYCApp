# Delete elastic search Index
echo "Enter elastic search URL"
read es_url
curl -XDELETE "$es_url/teacherset"
