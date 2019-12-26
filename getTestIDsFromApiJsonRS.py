import sys, json;

the_json = json.load(sys.stdin)

for api_item in the_json['items']:
    if sys.argv[1] in api_item[sys.argv[2]]:
        print api_item['id'],
