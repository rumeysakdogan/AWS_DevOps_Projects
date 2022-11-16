import json


# Test the process API returns JSON results we expect
# def test_api_process(client):

# resp = client.get("/api/process")
# assert resp.status_code == 200
# assert resp.headers["Content-Type"] == "application/json"
# resp_payload = json.loads(resp.data)
# assert len(resp_payload["processes"]) > 0
# assert resp_payload["processes"][0]["memory_percent"] > 0
# assert len(resp_payload["processes"][0]["name"]) > 0


# Test the monitor API returns JSON results we expect
def test_api_monitor(client):
    resp = client.get("/api/monitor")

    assert resp.status_code == 200
    assert resp.headers["Content-Type"] == "application/json"
    resp_payload = json.loads(resp.data)
    assert resp_payload["cpu"] >= 0
    assert resp_payload["disk"] >= 0
    assert resp_payload["disk_read"] >= 0
    assert resp_payload["disk_write"] >= 0
    assert resp_payload["mem"] >= 0
    assert resp_payload["net_recv"] >= 0
    assert resp_payload["net_sent"] >= 0
