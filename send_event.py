import events_pb2
import events_pb2_grpc
import google
import grpc
import json
from jwt_gen import generate_jwt
import os

service_account_path = os.environ['SERVICE_ACCOUNT_PATH']
iss = os.environ['JWT_ISSUER']
aud = os.environ['EVENTS_AUD']
timeout = 60

def send_event(domain, peripheralId, deploymentId, value):
	auth_token = generate_jwt(service_account_path, iss, aud)
	metadata = [('authorization', 'Bearer ' + auth_token)]
	credentials = grpc.ssl_channel_credentials()
	channel = grpc.secure_channel(domain, credentials)
	stub = events_pb2_grpc.PeripheralMeasurementEventServiceStub(channel)

	time_stamp = google.protobuf.timestamp_pb2.Timestamp()
	time_stamp.GetCurrentTime()

	return stub.SendEvent(
			events_pb2.NewMeasurementEvent(
				peripheralId=peripheralId,
				deploymentId=deploymentId,
				value=value,
				time_stamp=time_stamp
			), timeout, metadata=metadata
		)
