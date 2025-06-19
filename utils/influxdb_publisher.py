import os
import sys
from datetime import datetime
from robot.api import ResultVisitor
from influxdb_client import InfluxDBClient, Point, WriteOptions
from influxdb_client.client.write_api import SYNCHRONOUS

# Configuration from environment variables or config.py
INFLUXDB_URL = os.getenv('INFLUXDB_URL', 'http://localhost:8086')
INFLUXDB_TOKEN = os.getenv('INFLUXDB_TOKEN', 'your-influxdb-token')
INFLUXDB_ORG = os.getenv('INFLUXDB_ORG', 'your-inflfluxdb-org')
INFLUXDB_BUCKET = os.getenv('INFLUXDB_BUCKET', 'robotframework_metrics')

class InfluxDBPublisher(ResultVisitor):
    def __init__(self):
        self.client = InfluxDBClient(url=INFLUXDB_URL, token=INFLUXDB_TOKEN, org=INFLUXDB_ORG)
        self.write_api = self.client.write_api(write_options=WriteOptions(batch_size=1, flush_interval=1_000, jitter_interval=0, retry_interval=5_000, max_retries=5, max_retry_delay=30_000, exponential_base=2))

    def start_suite(self, suite):
        pass

    def end_suite(self, suite):
        pass

    def start_test(self, test):
        pass

    def end_test(self, test):
        status = test.status
        test_name = test.name
        suite_name = test.parent.name
        duration = test.elapsedtime / 1000.0  # Convert ms to seconds

        point = Point("test_result") \
            .tag("suite", suite_name) \
            .tag("test_name", test_name) \
            .tag("status", status) \
            .field("duration_seconds", duration) \
            .time(datetime.utcnow())

        print(f"Sending point: {point.to_line_protocol()}")
        self.write_api.write(bucket=INFLUXDB_BUCKET, org=INFLUXDB_ORG, record=point)

    def close(self):
        self.write_api.close()
        self.client.close()

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python influxdb_publisher.py <path_to_output.xml>")
        sys.exit(1)

    output_xml_path = sys.argv[1]
    if not os.path.exists(output_xml_path):
        print(f"Error: {output_xml_path} not found.")
        sys.exit(1)

    from robot.api import get_model
    model = get_model(output_xml_path)

    publisher = InfluxDBPublisher()
    model.visit(publisher)
    publisher.close()
    print("Metrics sent to InfluxDB successfully.")


