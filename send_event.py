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
