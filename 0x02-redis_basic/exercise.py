#!/usr/bin/env python3

"""
This module provides a simple caching mechanism using Redis.

It includes the `Cache` class, which uses Redis to store data with unique keys.
The class provides methods for storing data with a unique identifier.
"""

import redis
from uuid import uuid4
from typing import Union, Optional, Callable
from functools import wraps


def count_calls(method: Callable) -> Callable:
    """
    Decorator that counts the number of times a method is called.

    Args:
        method (Callable): The method to be decorated.

    Returns:
        Callable: The decorated method.
    """

    key = method.__qualname__

    @wraps(method)
    def wrapper(self, *args, **kwargs):
        # Generate the key using the method's qualified name

        # Increment the count for this key
        self._redis.incr(key)

        # Call the original method and return its value
        return method(self, *args, **kwargs)

    return wrapper


def call_history(method: Callable) -> Callable:
    """
    Decorator that stores the history of inputs and outputs for a
    function in Redis.

    Args:
        method (Callable): The method to be decorated.

    Returns:
        Callable: The decorated method.
    """

    @wraps(method)
    def wrapper(self, *args, **kwargs):
        input_str = str(args)

        self._redis.rpush(method.__qualname__ + ":inputs", input_str)
        output = str(method(self, *args, **kwargs))
        self._redis.rpush(method.__qualname__ + ":outputs", output)
        return output

    return wrapper


def replay(method: Callable) -> None:
    """
    Display the history of calls of a particular function.

    Args:
        method (Callable): The method to replay the call history for.
    """
    inputs_key = f"{method.__qualname__}:inputs"
    outputs_key = f"{method.__qualname__}:outputs"

    redis_client = method.__self__._redis

    inputs = redis_client.lrange(inputs_key, 0, -1)
    outputs = redis_client.lrange(outputs_key, 0, -1)

    print(f"{method.__qualname__} was called {len(inputs)} times:")
    for input_, output in zip(inputs, outputs):
        print(
            f"{method.__qualname__}(*{input_.decode('utf-8')}) "
            f"-> {output.decode('utf-8')}"
        )


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

    @call_history
    @count_calls
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

        key: str = str(uuid4())
        self._redis.set(name=key, value=data)
        return key

    def get(self, key: str, fn: Optional[Callable] = None):
        """
        Retrieve the value associated with the given key from Redis and
        optionally convert it using a provided callable.

        Args:
            key (str): The key to retrieve the value for.
            fn (Callable, optional): An optional callable to convert the data
                back to the desired format. Defaults to None.

        Returns:
            The retrieved value, optionally converted using `fn`, or
            None if the key does not exist.
        """
        value = self._redis.get(key)

        if value is None:
            return None

        if fn:
            return fn(value)

        return value

    def get_str(self, key: str) -> str:
        """
        Retrieve data from Redis and decode it as a UTF-8 string.

        This method fetches the data associated with the given key from Redis,
        decodes it from bytes to a UTF-8 string,
        and returns the decoded string.
        If the key does not exist or the data is not found, it returns `None`.

        Parameters:
        key (str): The key associated with the data to retrieve from Redis.

        Returns:
        str: The decoded UTF-8 string data associated with the given key, or
        `None` if the key does not exist or the data is not found.
        """
        return self.get(
            key=key, fn=lambda x: x.decode('utf-8') if x else None
        )

    def get_int(self, key: str) -> int:
        """
        Retrieve the value associated with the given key from Redis and
        convert it to an integer.

        Args:
            key (str): The key to retrieve the value for.

        Returns:
            int: The retrieved value as an integer, or None if the key
            does not exist.
        """
        return self.get(key=key, fn=lambda x: int(x) if x else None)
