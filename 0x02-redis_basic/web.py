#!/usr/bin/env python3

import redis
import requests
from typing import Callable
from functools import wraps


r = redis.Redis()


def cache_with_expiration(expiration: int):
    """
    Decorator to cache the result of a function with an expiration time.

    Args:
        expiration (int): The expiration time in seconds.

    Returns:
        Callable: The decorated function.
    """
    def decorator(method: Callable) -> Callable:
        @wraps(method)
        def wrapper(url: str, *args, **kwargs) -> str:
            cache_key = f"cached:{url}"
            count_key = f"count:{url}"

            # Check if the URL is cached
            cached_page = r.get(cache_key)
            if cached_page:
                return cached_page.decode('utf-8')

            # Fetch the page content and cache it
            page_content = method(url, *args, **kwargs)
            r.setex(cache_key, expiration, page_content)

            # Track the number of times the URL was accessed
            r.incr(count_key)

            return page_content

        return wrapper
    return decorator


@cache_with_expiration(10)
def get_page(url: str) -> str:
    """
    Fetch the HTML content of a URL and cache it with an expiration time.

    Args:
        url (str): The URL to fetch the content from.

    Returns:
        str: The HTML content of the URL.
    """
    response = requests.get(url)
    return response.text
