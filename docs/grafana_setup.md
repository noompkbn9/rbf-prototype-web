# Grafana Cloud Setup and Dashboard Configuration

This document outlines the steps to set up Grafana Cloud for monitoring your test automation metrics and configuring a dashboard to visualize them.

## 1. Sign Up for Grafana Cloud

If you don't already have a Grafana Cloud account, sign up for a free tier or a suitable plan at [Grafana Cloud](https://grafana.com/products/cloud/).

## 2. Create an InfluxDB Data Source

Once logged in to your Grafana Cloud account:

1. Navigate to **Connections** > **Data sources**.
2. Click **Add new data source**.
3. Search for and select **InfluxDB**.
4. Configure the InfluxDB data source with the following details:
   - **Query Language**: Flux
   - **URL**: This will be provided by Grafana Cloud (e.g., `https://us-east-2-1.aws.cloud2.influxdb.com`). You can find this in your InfluxDB details under **Connections** > **InfluxDB**.
   - **Token**: Generate an API token with `read` and `write` permissions for your bucket. Go to **Security** > **API Keys** in Grafana Cloud, click **Add API Key**, give it a name, and select the appropriate permissions.
   - **Organization**: Your Grafana Cloud organization name (e.g., `your-org-name`).
   - **Bucket**: The name of your InfluxDB bucket (e.g., `robotframework_metrics`).
   - **Min time interval**: `1s` (or as appropriate for your data granularity).
5. Click **Save & test** to ensure the connection is successful.

## 3. Create a Grafana Dashboard

Now that your InfluxDB data source is configured, you can create a dashboard to visualize your test metrics:

1. Navigate to **Dashboards** > **New dashboard**.
2. Click **Add new panel**.
3. In the **Query** tab, select your InfluxDB data source.
4. Write Flux queries to retrieve your test data. Here are some example queries:

   ### Example 1: Total Test Runs Over Time
   This panel shows the total number of test runs over time.

   ```flux
   from(bucket: "robotframework_metrics")
     |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
     |> filter(fn: (r) => r._measurement == "test_result")
     |> group(columns: ["_time"])
     |> count()
     |> yield(name: "total_runs")
   ```

   ### Example 2: Test Status (Passed/Failed) Over Time
   This panel shows the number of passed and failed tests over time.

   ```flux
   from(bucket: "robotframework_metrics")
     |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
     |> filter(fn: (r) => r._measurement == "test_result")
     |> group(columns: ["status", "_time"])
     |> count()
     |> yield(name: "test_status")
   ```

   ### Example 3: Average Test Duration by Test Name
   This panel shows the average duration of each test.

   ```flux
   from(bucket: "robotframework_metrics")
     |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
     |> filter(fn: (r) => r._measurement == "test_result" and r._field == "duration_seconds")
     |> group(columns: ["test_name"])
     |> mean()
     |> yield(name: "average_duration")
   ```

   ### Example 4: Pass Rate Percentage
   This panel calculates the overall pass rate.

   ```flux
   total = from(bucket: "robotframework_metrics")
     |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
     |> filter(fn: (r) => r._measurement == "test_result")
     |> count()

   passed = from(bucket: "robotframework_metrics")
     |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
     |> filter(fn: (r) => r._measurement == "test_result" and r.status == "PASS")
     |> count()

   union(tables: [total, passed])
     |> group()
     |> map(fn: (r) => ({ _value: float(v: r.passed._value) / float(v: r.total._value) * 100.0 }))
     |> yield(name: "pass_rate")
   ```

5. Customize your panels (e.g., visualization type, title, legend, units).
6. Save your dashboard.

This setup will allow you to monitor your test automation trends and performance directly within Grafana Cloud.

