<!--
.. title: A webserver in Python using Asyncio
.. slug: a-webserver-in-python-using-asyncio
.. date: 2016-11-16 10:12:18 UTC+05:30
.. tags: python, geekskool, server, asyncio, threads, http
.. category: technical
.. link:
.. description: A webserver in Python using Asyncio
.. type: text
-->

It's been a month and a half since I started as a student at Geekskool and it's been pretty exciting here. I started with solving HackerRank problems in the Algorithms section using Python 3 and then moved on to a project which was a [JSON parser](https://github.com/geekskool/python-json-parser) and <!-- TEASER_END --> this helped me understand how parsers actually worked. As I wanted to concentrate on becoming a good backend programmer, and wanted to know how frameworks like Flask or Django work, I decided to start with a webserver project to understand how the webserver works underneath.

I had a rudimentary implementation using threads based on previous work by ex-Geekskool students and had to port it to Python 3 and add more features. Most of the time was spent in reading the [HTTP RFC spec](https://www.ietf.org/rfc/rfc2616.txt) which even though time consuming, gave a glimpse about what all goes in the HTTP/1.1 protocol, the syntax, the required request and response headers.

I commenced with moving the server from a threads based approach to the new and shiny asyncio based approach. I had to read up on why the async approach was brought in the first place, the pros and cons of threads and when to use threads and when to use async.

In the older code base, the threads version, `2048` bytes were read from a socket every time, till there was no data to read, which looked inefficient. In the async based approach, I started with the same methodology till I found a method, in the async `reader` object called `readuntil` which I used to read till the delimiter `\r\n\r\n` which gives the complete header and for the body I took the `Content-Length` field from the header and used a method `readexactly` to read the exact bytes of the body.

``` python
def check_content(headers):
    if b"Content-Length" in headers:
        con_pos = headers.find(b"Content-Length")
        col_pos = headers.find(b":", con_pos)
        srsn = headers.find(b"\r\n", col_pos)
        con_len = int(headers[col_pos + 2:srsn])
        return con_len
```

``` python
header = await reader.readuntil(b"\r\n\r\n")
content_length = check_content(header)
if content_length:
    content = await reader.readexactly(content_length)
```


The method `check_content` checks for `Content-Length` in the header byte string and returns the value and the following snippet reads exactly the amount of bytes as specified in the `Content-Length` header field.

File uploads, handling query parameters in a GET request were the features added next. It involved a lot of refactoring, as I was realizing the pains of strings and byte strings which Python 2 did not differentiate, and was also slowly getting the hang of how asyncio works.

Features to be added:

* Middlewares
* Dynamic routes
* CORS support
* Web socket support

So, currently the server can serve dynamic content, static files, handle GET and POST requests, handle sessions using cookies, and file uploads. The complete code is in a single file at [server.py](https://github.com/geekskool/magicserver-python3/blob/master/server.py) and the repo is at [magicserver-python3](https://github.com/geekskool/magicserver-python3/)
