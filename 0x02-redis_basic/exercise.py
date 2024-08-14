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
        """
        Initializes the Cache class and sets up the Redis connection.

        This method creates a connection to a Redis server and clears
        the database by calling `flushdb`.
        """
        self._redis = redis.Redis()
        self._redis.flushdb()

    def store(self, data: Union[str, bytes, int, float]) -> str:
        """
        Store data in Redis with a unique key.

        This method generates a unique key using UUID and stores the provided
        data in Redis associated with this key.

        Parameters:
        data (Union[str, bytes, int, float]): The data to store in Redis.
        Can be a string, bytes, integer, or float.

        Returns:
        uuid.UUID: The unique key associated with the stored data.
        """

        random_key: str = str(uuid.uuid4())
        self._redis.set(name=random_key, value=data)

        return random_key
