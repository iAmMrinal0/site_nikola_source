<!--
.. title: Using Lenses in PureScript
.. slug: using-lenses-in-purescript
.. date: 2018-02-28 14:23:53 UTC+05:30
.. tags: lenses, haskell, purescript, tutorial, javascript
.. category: technical
.. link:
.. description: How to use Lenses in PureScript
.. type: text
-->

I believe we all have come across interesting problems while programming and once we found the solution or an easier way to do it, we had our minds blown away. I had a similar feeling when I discovered `lenses` and started using them. No, I am not talking about <!-- TEASER_END --> my glasses or eye lenses. I am talking about `lenses` in [Haskell](https://github.com/ekmett/lens) or [PureScript.](https://github.com/purescript-contrib/purescript-profunctor-lenses) Incase you didn't know, we use PureScript at Juspay and after looking at the code for one of our projects, someone came up with a suggestion to use `lenses.` I had heard of the term, however never found a reason to use it. And now seemed like a good chance to do that.

So let's start with the problem we have and how we would solve it. Let's say we have a lot of records which are wrapped in a constructor. Something like the following:

``` haskell
newtype Person = Person
  { id :: String
  , name :: String
  , location :: String
  }

derive instance newtypePerson :: Newtype Person _

newtype Tweet = Tweet
  { id :: String
  , content :: String
  , location :: String
  }

derive instance newtypeTweet :: Newtype Tweet _
```

And now to access the field `location` in a `Person` record, we might do something like this:

``` haskell
getLocFromPerson :: Person -> String
getLocFromPerson (Person person) = person.location

getLocFromPerson' :: Person -> String
getLocFromPerson' (Person {location}) = location

personRec = Person {id: "1", name: "Luke Skywalker", location: "Ahch-To"}
location = getLocFromPerson personRec
location' = getLocFromPerson' personRec
```

Or as we have a `newtype` instance for the `Person` type we could do this:

``` haskell
getLocFromPerson'' :: Person -> String
getLocFromPerson'' person = unwrap >>> _.location $ person
```

What if we want to access `location` from a `Tweet` type record?

``` haskell
getLocFromTweet :: Tweet -> String
getLocFromTweet (Tweet tweet) = tweet.location

getLocFromTweet' :: Tweet -> String
getLocFromTweet' (Tweet {location}) = location

getLocFromTweet'' :: Tweet -> String
getLocFromTweet'' tweet = unwrap >>> _.location $ tweet
```

Feels a bit redundant, doesn't it? Having to type the same thing again and again? There's a solution to this.

``` haskell
getLocation :: forall a b c. Newtype a { location :: c | b } => a -> c
getLocation = unwrap >>> _.location -- A
```

Now this is generic enough which will work on all records which has a `Newtype` instance and has a `location` field in the record. Also, if you notice the type signature of the function, you will find that we don't specify the type of `location` which means this would work for any type of the `location` field.

This is still not intuitive enough, and imagine every time having to write:

```haskell
location' = getLocation personRecord
location'' = getLocation tweetRecord
```

But imagine writing something along the lines of

``` haskell
location' = personRecord.location
location'' = tweetRecord.location
```

This is how you would do in JavaScript or Python and it feels natural, right?

Here is where `lenses` come in. At this point you don't need to know how they work underneath. So we will get into how to use them right away.

Basically, you create a lens for the record, the fields, with the getters and setters and then you can use the functions `lens` provides for getting a field and setting a field. So how to create a lens for the `Person` type and `Tweet` type?

``` haskell
_locationPerson = lens (\(Person person) -> person.location)
                  (\(Person person) newValue -> Person person {location = newValue})

_locationTweet = lens (\(Tweet tweet) -> tweet.location)
                 (\(Tweet tweet) newValue -> Tweet tweet {location = newValue})
```

The first argument to the `lens` function is the getter for the `location` field and second is another function which is setter for the `location` field.

There's another way to create lenses for a field rather than writing the complete getters and setters. What we do is, we create a lens for the type with the getter and setter and compose the same to get lenses for the fields.

``` haskell
personLens = lens (\(Person person) -> person) (\_ -> Person)
tweetLens = lens (\(Tweet tweet) -> tweet) (\_ -> Tweet)

locationProp = prop (SProxy :: SProxy "location")

locationPersonLens = person <<< locationProp
locationTweetLens = tweetLens <<< locationProp
```

And now you can use something along the lines of: `^.` which is an alias for `viewOn`

``` haskell
locationPerson = personRecord ^. _locationPerson
locationTweet = tweetRecord ^. _locationTweet

-- or
locationPerson' = viewOn _personRecord locationPerson
locationTweet' = viewOn _tweetRecord locationTweet

-- or
locationPerson'' = view _locationPerson personRecord
locationTweet'' = view _locationTweet tweetRecord
```

Or if we want to use the lens defined using `prop` it's the same.

``` haskell
locationPerson = personRecord ^. locationPersonLens
locationTweet = tweetRecord ^. locationTweetLens

-- or
locationPerson' = viewOn _personRecord locationPersonLens
locationTweet' = viewOn _tweetRecord locationTweetLens

-- or
locationPerson'' = view locationPersonLens personRecord
locationTweet'' = view locationTweetLens tweetRecord
```

However, if you notice, you will find that we are creating a lot of lenses which are redundant. Creating a lens for the same field in different types of records is useless and goes against why we want to use lenses. So let's resuse our solution up in `A` and make this generic so we can use it in our `lens` definition.

``` haskell
_location :: forall a b c. Newtype a {location :: c | b} => Lens' a c
_location = lens (unwrap >>> _.location)
            (\record newValue -> wrap $ unwrap record { location = newValue })
```

Now, does this not look generic enough? This would work for any record which has a `Newtype` instance and also has the field `location` and as our type definition is generic enough this can be used for any type of field `location`. And our accessor functions change to:

``` haskell
locationPerson = personRecord ^. _location
locationTweet = tweetRecord ^. _location
```

And to set a value in a record, we would usually do:

``` haskell
setLocPerson :: Person -> String -> Person
setLocPerson (Person person) newLocation = Person person {location = newLocation}

setLocTweet :: Tweet -> String -> Tweet
setLocTweet (Tweet tweet) newLocation = Tweet tweet {location = newLocation}
```

Instead, now we can use the functionality `lens` provides and use the setter function:

``` haskell
newPerson = set _location "Tatooine" personRecord
newTweet = set _location "Dagobah" tweetRecord

-- or
newPerson' = personRecord # _location .~ "Tatooine"
newTweet' = tweetRecord # _location .~ "Dagobah"
```

So, that's it for a bit of basics on how to get started with `lens` and hope you understood. And if not, let me know in the comments and I will try to clarify them out.

## References:
1. Lenses by Simon Peyton Jones: [Skills Matter](https://skillsmatter.com/skillscasts/4251-lenses-compositional-data-access-and-manipulation)
2. John Weigley: Putting lenses to work: [YouTube](https://www.youtube.com/watch?v=QZy4Yml3LTY)
3. PureScript explanation of John Weigley's video by Dominick Gendill: [Blog](https://www.dgendill.com/posts/programming/2017-06-21-putting-lenses-to-work-in-purescript.html)
