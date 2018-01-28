<!-- 
.. title: The Curious Case of Matching Memory Locations in Python
.. slug: the-curious-case-of-matching-memory-locations-in-python
.. date: 2017-05-21 16:31:28 UTC+05:30
.. tags: python, memory, tips, objects, cpython
.. category: technical
.. link: 
.. description: What happens when you reuse constants in Python?
.. type: text
-->

So I attended a Python [meetup](https://www.meetup.com/BangPypers/events/238929256/) yesterday which was quite informative and one of the talks which I found fascinating was about `Cleaning the trash in Python` by Rivas. He starts his talk by explaining what is `trash` in programming sense, and goes on to compare memory allocation for objects and arrays in C and Python.

<!-- TEASER_END -->

So he mentions that when we create a value `100` and reuse it, Python will point it to the older reference of `100` as it already exists. He explains about finding memory locations of objects using the `id` method and how they point to the same memory location. What exactly does the `id` method do?

`id: Return identity of an object`

It returns the memory location of an object. This can be used to check if two objects point to the same location. So we will go right ahead and see a few quirks of Python using this.

``` python
In [1]: a = 100

In [2]: b = 100

In [3]: id(a)
Out[3]: 139944507028096

In [4]: id(b)
Out[4]: 139944507028096
```

All is well and good in Python land, being memory efficient and all when we initialize something with `100`. Let's proceed:

``` python
In [5]: c = 257

In [6]: d = 257

In [7]: id(c)
Out[7]: 139944437174032

In [8]: id(d)
Out[8]: 139944437170992
```

So what happened exactly? Let's try another example:

``` python
In [9]: e = 256

In [10]: f = 256

In [11]: id(e)
Out[11]: 139944507033088

In [12]: id(f)
Out[12]: 139944507033088
```

Uh...oh! Any guesses what happened here?

_Explanation:_ What Python does here is that it stores all integers from `-5` to `256` in memory because they are most frequently used and so it doesn't create new memory locations for those objects, therefore when you access a number in that range, Python just fetches it from memory and returns the value.

Let me blow your mind even more with the following code:

``` python
In [15]: id(257)
Out[15]: 139944437173872

In [16]: print(id(257), id(257), id(257) == id(257))
139944437171184 139944437171184 True
```

Woah, what kind of sorcery is this? You must be like, _"Hey, you just told me that numbers after `256` get a different address every time, so what happened here?"_

_Explanation:_ The reason is that when Python encounters constants in a single statement, it adds them to a dictionary and looks up in the dictionary for every constant. If it finds it in the dictionary, then it reuses the existing memory location. This is not the case in `In[5]` and `In[6]` because they are two separate statements.

Let's take it up a notch and try exploring more:

``` python
In [17]: def func():
    ...:     a = 257
    ...:     b = 257
    ...:     return id(a) == id(b)
    ...:

In [18]: func()
Out[18]: True
```

We found that for numbers above `256`, Python stores them in new memory locations unless they are used in the same line/statement. However in the above example, they are separate statements and still return `True` when we compare the memory locations. So why the odd behaviour?

_Explanation:_ The reason behind this is that within the same compiler scope like in a function or a class, everything is stored in a `constants` dictionary (`consts` in actual code) and hence any time a constant is encountered, it is first checked in the `constants` dictionary and if it's present then it doesn't store it in a new memory location and if not then goes ahead and stores it. Python's idea of optimization during compile time. I had this doubt for a long time which was later cleared by Prasanth Raghu, whom I met in one of the future meetups who also had been working with the CPython code for quite some time. Have a look at the following links to get a better understanding of the flow.


* The program starts in the `compiler_function`: [link](https://github.com/python/cpython/blob/95e4d589137260530e18ef98a2ed84ee3ec57e12/Python/compile.c#L1845)
* Reaches `VISIT_SEQ_IN_SCOPE` function call: [link](https://github.com/python/cpython/blob/95e4d589137260530e18ef98a2ed84ee3ec57e12/Python/compile.c#L1911)  
* Inside the `if` condition of `VISIT_SEQ_IN_SCOPE` calls `compiler_visit_stmt`: [link](https://github.com/python/cpython/blob/95e4d589137260530e18ef98a2ed84ee3ec57e12/Python/compile.c#L1358)  
* Evaluates to `Assign_kind`: [link](https://github.com/python/cpython/blob/95e4d589137260530e18ef98a2ed84ee3ec57e12/Python/compile.c#L2980)  
* Reaches `VISIT` function call: [link](https://github.com/python/cpython/blob/95e4d589137260530e18ef98a2ed84ee3ec57e12/Python/compile.c#L2982)  
* Function definition of `VISIT`: [link](https://github.com/python/cpython/blob/95e4d589137260530e18ef98a2ed84ee3ec57e12/Python/compile.c#L1326)  
* Goes to `compiler_visit_expr`: [link](https://github.com/python/cpython/blob/95e4d589137260530e18ef98a2ed84ee3ec57e12/Python/compile.c#L4376)  
* The statement is a `Num_kind` so it calls `ADDOP_O`: [link](https://github.com/python/cpython/blob/95e4d589137260530e18ef98a2ed84ee3ec57e12/Python/compile.c#L4459). `consts` is used here which comes from the following links: 
   - Definition of `*u_consts`: [link](https://github.com/python/cpython/blob/95e4d589137260530e18ef98a2ed84ee3ec57e12/Python/compile.c#L114)
   - Store it in `tmp`: [link](https://github.com/python/cpython/blob/95e4d589137260530e18ef98a2ed84ee3ec57e12/Python/compile.c#L5369)
   - The `consts` dictionary: [link](https://github.com/python/cpython/blob/95e4d589137260530e18ef98a2ed84ee3ec57e12/Python/compile.c#L5372)  
* This internally calls `compiler_addop_o`: [link](https://github.com/python/cpython/blob/95e4d589137260530e18ef98a2ed84ee3ec57e12/Python/compile.c#L1288)
* Calls the `compiler_add_o` function: [link](https://github.com/python/cpython/blob/95e4d589137260530e18ef98a2ed84ee3ec57e12/Python/compile.c#L1192)  
* Fetch from dictionary and return if exists: [link](https://github.com/python/cpython/blob/95e4d589137260530e18ef98a2ed84ee3ec57e12/Python/compile.c#L1163)

Hope the flow is clear, and do let me know if something was confusing.

## References

* Video of the talk by Rivas on [YouTube](https://www.youtube.com/watch?v=_YRHkn-f24k)
* [Python Docs](https://docs.python.org/3/c-api/long.html#c.PyLong_FromLong) relating to integer objects in memory.
* [Understanding `##` in C](https://stackoverflow.com/questions/22975073/what-does-double-hash-do-in-a-preprocessor-directive)
