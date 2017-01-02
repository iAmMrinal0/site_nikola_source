<!--
.. title: A short stint with Haskell
.. slug: a-short-stint-with-haskell
.. date: 2017-01-03 00:32:37 UTC+05:30
.. tags: haskell, geekskool, python, functional programming, clean
.. category: technical
.. link:
.. description: A look at a different programming paradigm
.. type: text
-->

So my 3 months at Geekskool are up and I have decided to extend and learn more for probably 3 more months. Since my last post about the webserver, I have forayed into the land of functional programming to see what it offers and what the paradigm is all about. <!-- TEASER_END -->

I was suggested by Santosh to start with Haskell for a month or so and he provided me with a few resources. Also, as Mukesh has been doing Haskell for quite some time it was more helpful as he cleared up a lot of doubts I had when I started. The following are the sources I used:

* [A taste of Haskell](https://hookrace.net/blog/a-taste-of-haskell/)
* [Haskell Programming from first principles](http://haskellbook.com/) by Christopher Allen and Julie Moronuki
* [Haskell Tutorial and Cookbook](https://leanpub.com/haskell-cookbook/) by Mark Watson

I followed the Haskell Programming book extensively for all the concepts and the cookbook to learn code examples. Over the course of the month I read the following topics:

* Lambda calculus: the base of functional programming
* Basic data types, typeclasses: the type system
* Currying: functions which take one argument and return another function
* Polymorphism: functions which can take any type as input
* Pure Haskell programming: pure and impure(errors result due to this) functions
* Lazy evaluation: don't evaluate unless required
* Lists and operations on them: folding, zipping, comprehensions, and a bit of Haskell syntactic sugar for easier usage.
* Anonymous functions, pattern matching, case expressions.
* Function composition, recursion, point free style.
* Functors, applicatives, and monads.


I eventually did a simple Cows and Bulls game in Haskell with two modes. One, where computer thinks(computes and stores) of a 4 digit number and the player has to guess it and the other mode where the player thinks of a number and the computer guesses(computes and filters) it. The code is on GitHub at [Cows and Bulls](https://github.com/iAmMrinal0/cowsAndBullsHask).

Overall, I would say that it was harder to get into the language, due to the restrictions of the type system, however the mathematical concepts are fascinating. What I learnt is, to think of your problem and its types first and half of the problem is solved right there. I plan to revisit Haskell in the future when I have the time and the need to learn it.

And my next plans are mostly get back to Python and do projects like web chat or video chat or an API wrapper. If not, I am looking at contributing to the [Clean](https://github.com/geekskool/clean) programming language which a few students here at Geekskool are building, with the guidance of Santosh(it's his idea.) If I decide to join the `Clean` team, I need to learn JavaScript and see where I can contribute as the language is still in its nascent stage. Santosh has suggested to start with doing type inference and type checking, so I am looking forward to see how it all turns out.
