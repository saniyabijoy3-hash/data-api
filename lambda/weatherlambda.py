import json
import urllib.request
import boto3

dynamodb = boto3.resource('dynamodb')

table = dynamodb.Table('Weathertable')
