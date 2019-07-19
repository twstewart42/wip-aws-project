#!/usr/bin/env python
"""
Project: WIP
Author: Tom Stewart - twstewart42@gmail.com
About: Lambda function to handle account sign up
       
Exec: - AWS Lambda

Notes: -
	python3.7
	userId email password lastName firstName address
	
"""

import boto3
from boto3.dynamodb.conditions import Key, Attr
import json 
import uuid
from hashlib import sha224
from base64 import b64encode

	
event = { 'email': 'test@123.org',
		  'password': 'xxxxx',
		  'lastName': 'Tester',
		  'firstName': 'Johhny',
		  'address': 'ROAD ST'
		  }
context = {}

def _get_unique_id(dynclient):
	'''create significantly unique identifier'''
	uid = uuid.uuid5(uuid.NAMESPACE_DNS, 'www.google.com')
	id = str(uid)
	return id

def _create_account_in_dynamodb(email, password, lastname, firstname, address):
	'''create account'''
	dynclient = boto3.resource('dynamodb')
	userId = _get_unique_id(dynclient)
	dyntable = dynclient.Table('movie-dev-accounts')
	dynresponse = dyntable.put_item(
			Item={
				'email': email,
				'userId': userId,
				'password': password,
				'lastName': lastname,
				'firstName': firstname,
				'address': address
				}
			)
	
	
def _check_exisiting_account(event):
	'''verify account does not already exist'''
	dynclient = boto3.resource('dynamodb')
	dyntable = dynclient.Table('movie-dev-accounts')
	dynresponse = dyntable.query(
		KeyConditionExpression=Key('email').eq(event['email'])
		)	
	return dynresponse
	
def _encrypt_password(password):
	ctx = sha224(password.encode('utf-8'))
	phash = b64encode(ctx.digest())
	return phash
		  
def _main(event):
	''' verify all fields are included'''
	for element in event:
		if event[element] is None or event[element] == '':
			message = 'Missing Required Details - %s' %(element)
			return {'statusCode': '402',
					'body': json.dumps({'statusMessage': message})
					}
					
	'''verify account does not already exist'''
	existing_id = None
	existing_id = _check_exisiting_account(event)
	if existing_id is not None:
		return {'statusCode': '402',
				'body': json.dumps({'statusMessage': 'An account with email already exists'})
				}
					
					
	'''encrypt txt password to SSH224'''
	# Do we need this, check if greater than 6 chars, etc
	enc_pass = _encrypt_password(password=event['password'])
	
	'''create account'''
	_create_account_in_dynamodb(email=event['email'], password=enc_pass, lastname=event['lastName'], firstname=event['firstName'], address=event['address'])
	return {'statusCode': '200',
			'body': json.dumps({'statusMessage': 'Success'})
			}
		
					
	

def lambda_handler(event, context):
	status = _main(event)
	print (status)
	return status

if __name__ == "__main__":
	lambda_handler(event, context)
