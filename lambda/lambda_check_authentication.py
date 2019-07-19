#!/usr/bin/env python
"""
ComProject: WIP
Author: Tom Stewart - twstewart42@gmail.com
About: Lambda function to handle confirming authentication to Movie project service
       
Exec: - AWS Lambda

Notes: -
	python3.7
"""
import json
import boto3
from boto3.dynamodb.conditions import Key, Attr
from hashlib import sha224
from base64 import b64encode

# testing Data	
event = { 'email': 'test@123.org',
		  'password': 'xxxxx',
		  }
context = {}

def _dyn_lookup_user(event):
	''' Lookup account, return hash of password '''
	dynclient = boto3.resource('dynamodb')
	dyntable = dynclient.Table('movie-dev-accounts')
	dynresponse = dyntable.query(
		KeyConditionExpression=Key('email').eq(event['email'])
		)
	for d in dynresponse['Items']:
		return d

def _main(event):
	''' Lookup account '''	
	authdyn = _dyn_lookup_user(event)
	ctx = sha224(event['password'].encode('utf-8'))
	phash = b64encode(ctx.digest())

	if authdyn is None:
		return {'statusCode':404,
				'body': json.dumps({'statusMessage': 'Username Not Found'})
		}

	if event['email'] == authdyn['email'] and phash == authdyn['password']:
		return {
        	'statusCode': 200,
        	'body': json.dumps({'statusMessage': 'Success'}),
		}
	else:
		return {'statusCode':403,
				'body': json.dumps({'statusMessage': 'Incorrect Password'})
		}

def lambda_handler(event, context):
	status = _main(event)
	print (status)
	return status

if __name__ == "__main__":
	lambda_handler(event, context)
