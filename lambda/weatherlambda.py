import json
import urllib.request
import boto3

dynamodb = boto3.resource('dynamodb')

table = dynamodb.Table('Weathertable')

def lambda_handler(event, context):
    
     api_key = "2896b53ee1b1dc1840a13a676b798698"

city = "Kochi"

url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"

response = urllib.request.urlopen(url)

data = json.loads(response.read())
 
