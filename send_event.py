import events_pb2
import events_pb2_grpc
import google
import grpc

def send_event(domain, peripheralId, deploymentId, value):
	channel = grpc.insecure_channel(domain)
	stub = events_pb2_grpc.PeripheralMeasurementEventServiceStub(channel)

	time_stamp = google.protobuf.timestamp_pb2.Timestamp()
	time_stamp.GetCurrentTime()

	return stub.SendEvent(
			events_pb2.NewMeasurementEvent(
				peripheralId=peripheralId,
				deploymentId=deploymentId,
				value=value,
				time_stamp=time_stamp
			)
		)

send_event(
	domain='192.168.1.162:6004',
	peripheralId='48a1e1f2-f977-424a-b22a-c6292f363447',
	deploymentId='f0083ac5-3026-11eb-a801-0242ac1e0002',
	value=34
)

