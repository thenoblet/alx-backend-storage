#!/usr/bin/env python3

"""
This module provides a simple caching mechanism using Redis.

It includes the `Cache` class, which uses Redis to store data with unique keys.
The class provides methods for storing data with a unique identifier.
"""

import redis
import uuid
from typing import Union


class Cache:
    """
    A class to interact with Redis for caching data.

    This class provides a simple interface to store data in Redis.
    Each piece of data is stored with a unique key
    generated using UUID.
    """
    def __init__(self):
        self._redis = redis.Redis()
        self._redis.flushdb()

    def store(self, data: Union[str, bytes, int, float]):
        random_key = uuid.uuid4()
        self._redis.set(random_key, data)

        return random_key
