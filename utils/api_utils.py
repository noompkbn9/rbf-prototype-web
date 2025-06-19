
import requests
import json
from config import API_BASE_URL
from robot.api import logger

class ApiUtils:

    def __init__(self):
        self.base_url = API_BASE_URL

    def get_request(self, endpoint, params=None):
        url = f"{self.base_url}{endpoint}"
        logger.info(f"Making GET request to: {url}")
        response = requests.get(url, params=params)
        logger.info(f"Response Status Code: {response.status_code}")
        logger.info(f"Response Body: {response.text}")
        return response

    def post_request(self, endpoint, data=None, json_data=None):
        url = f"{self.base_url}{endpoint}"
        logger.info(f"Making POST request to: {url}")
        response = requests.post(url, data=data, json=json_data)
        logger.info(f"Response Status Code: {response.status_code}")
        logger.info(f"Response Body: {response.text}")
        return response

    def put_request(self, endpoint, data=None, json_data=None):
        url = f"{self.base_url}{endpoint}"
        logger.info(f"Making PUT request to: {url}")
        response = requests.put(url, data=data, json=json_data)
        logger.info(f"Response Status Code: {response.status_code}")
        logger.info(f"Response Body: {response.text}")
        return response

    def delete_request(self, endpoint, data=None, json_data=None):
        url = f"{self.base_url}{endpoint}"
        logger.info(f"Making DELETE request to: {url}")
        response = requests.delete(url, data=data, json=json_data)
        logger.info(f"Response Status Code: {response.status_code}")
        logger.info(f"Response Body: {response.text}")
        return response

    def to_json(self, response_text):
        try:
            return json.loads(response_text)
        except json.JSONDecodeError as e:
            logger.error(f"Failed to decode JSON: {e}")
            return None


