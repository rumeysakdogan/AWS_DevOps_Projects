def test_home(client):
    resp = client.get("/")

    assert resp.status_code == 200
    assert b"Python" in resp.data


def test_page_content(client):
    resp = client.get("/")

    assert resp.status_code == 200
    assert b"Coleman" in resp.data


def test_info(client):
    resp = client.get("/info")

    assert resp.status_code == 200
    assert b"Hostname" in resp.data
