# Semigroup Examples (DRAFT)

![series banner](../resources/glitched-abstract.jpg)

> *Note: This is* **Tutorial 7** *in the series* **Make the leap from JavaScript to PureScript** *. Be sure*
> *to read the series introduction where I cover the goals & outline, and the installation,*
> *compilation, & running of PureScript. I will be publishing a new tutorial approximately*
> *once-per-week. So come back often, there is a lot more to come!*

> [<< Introduction](https://github.com/adkelley/javascript-to-purescript) [< Tutorial 6](https://github.com/adkelley/javascript-to-purescript/tree/master/tut06)

Welcome to Tutorial 7 in the series **Make the leap from Javascript to PureScript**.  I hope you've enjoyed the learnings thus far.  Be sure to read the series [Introduction](https://github.com/adkelley/javascript-to-purescript) to learn how to install and run PureScript. I borrowed (with permission) this series outline and javascript code samples from the egghead.io course [Professor Frisby Introduces Composable Functional JavaScript](https://egghead.io/courses/professor-frisby-introduces-composable-functional-javascript) by
[Brian Lonsdorf](https://github.com/DrBoolean) - thank you, Brian! A fundamental assumption is that you have watched his [video](https://egghead.io/lessons/javascript-semigroup-examples) before tackling the equivalent PureScript abstraction featured in this tutorial.  Brian covers the featured concepts extremely well, and it's better that you understand its implementation in the comfort of JavaScript.

If you read something that you feel could be explained better, or a code example that needs refactoring, then please let me know via a comment or send me a pull request on [Github](https://github.com/adkelley/javascript-to-purescript/tree/master/tut07).  Finally, If you are enjoying this series then please help me to tell others by recommending this article and/or favoring it on social media

## Robot Voice: Shall we play a game?
Imagine we've developed an online game and one of our players,  Nico has made three accounts accidentally; issuing a support ticket to merge them into one account.  Well, my first reaction is to ban Nico permanently for negligence. Regrettably, even in my own imaginary games company, that decision is well above my pay grade. So we'll just have to figure out how to accommodate Nico's request.

Anytime you see the words merge, combine, consolidate, etc. in a user story; you should be thinking Semigroups immediately.  So, let's help poor Nico out by combining his/her credentials with the aid of our Semigroup types from [Tutorial 6](https://github.com/adkelley/javascript-to-purescript/tree/master/tut06).  But instead of merely presenting the code and calling it a day, I'll make this tutorial a little more interesting by introducing a few new constructs in PureScript; starting with Records.

## PureScript records overview
If you're a JavaScript developer, then you're probably using Objects on a daily basis.  You know, those name:value pairs we call properties; enclosed in braces. I'm sure you've seen them, but just in case:

```javascript
var immy = { firstName: "Imogen", lastName: "Heap", age: 39 };
```

And by migrating to PureScript, perhaps you've already shed a tear or two; contemplating that sad and tearful goodbye to your dear old friend, Object. Well, dry those tears and put your big boy (or girl) pants back on, because PureScript just waved hello with its `Record` type constructor.  Porting this code snippet we get:

```haskell
type Person =
  { firstName :: String
  , lastName  :: String
  , age       :: Int
  }

immy :: Person
immy =
  { firstName: "Imogen"
  , lastName: "Heap"
  , age: 39
  }
```

Now that wasn't so bad. In fact, the syntax for JavaScript objects and PureScript records are spitting images of one another.  Note that `{ ... }` is syntactic sugar for the `Record` type constructor. Thus,  `{ firstName :: String }` is the same as `Record ( firstName :: String )`.  Also, records have a few magical powers worth mentioning.  For one, just like JavaScript objects, we have the ability to add extra `name:value` properties to records:

```haskell
type Person r =
  { firstName :: String
  , lastName  :: String
  , age       :: Int
  | r
  }
```
Shazam!  But let's go over a couple of 'minor' changes from the first example of `Person`.  By declaring `Person r`, I am *instantiating* that `Person` may contain extra record fields `r`.  Thus `Person` has become a *row-polymorphic* record (or extensible record type).  And, as an example, I'm doing that by creating the type `Musician` as an extension of  `Person r`, with the additional field `genre`.

```haskell
type Musician = Person ( genre :: String )
```

Be careful to use parenthesis when creating a record extension, since `r` has to be a row kind, not a record type.  Now that we have defined an extension `Musician`, let's create one of my favorites:

```haskell
immy :: Musician
immy =
  { firstName: "Imogen"
  , lastName: "Heap"
  , age: 39
  , genre: "Electronic"
  }
```  

What does it all mean?  Well, if this looks unfamiliar to you then recall that we covered the similar concept of extensible effects when we discussed native side-effects in [Tutorial 4](https://github.com/adkelley/javascript-to-purescript/tree/master/tut04P1).  To review:

```haskell
main :: forall e. Eff (console :: CONSOLE | e) Unit
```

We are parameterizing the `Eff` type constructor with a row of effects and its return type.  More specifically, we declare that `main` produces a row that consists of the `CONSOLE` effect, and perhaps additional effects `e`, returning `Unit` (values with no computational content).

Another magic power and a real keystroke saver is assignment using wild cards:


```haskell
makeMusician :: String -> String -> Int -> String -> Musician
makeMusician = { firstName: _, lastName: _, age: _ , genre: _ }
```

And for one last magic power, a shorthand for Record updates:

```haskell
setGenre :: String -> Musician -> Musician
setGenre g m = m { genre = g }
```

I have included these examples in my [github repository](https://github.com/adkelley/javascript-to-purescript/tree/master/tut07), so feel free to try them yourself.

Wow! We covered a lot of ground here, but there's lots more to learn about records in PureScript.  So I encourage you to have a look at the [documentation](https://github.com/purescript/documentation/blob/master/language/Records.md) and also [Chapter 8.14](https://leanpub.com/purescript/read#leanpub-auto-objects-and-rows) in PureScript by Example.

## Say hello to Additive, Conj, and First
As mentioned in [Tutorial 6](https://github.com/adkelley/javascript-to-purescript/tree/master/tut06), PureScript already has Semigroup constructors that copy the functionality of `Sum` & `All`. They're named `Additive` and `Conj` from the modules [Data.Monoid.Additive](https://pursuit.purescript.org/packages/purescript-monoid/3.0.0/docs/Data.Monoid.Additive#t:Additive) and [Data.Monoid.Conj](https://pursuit.purescript.org/packages/purescript-monoid/3.0.0/docs/Data.Monoid.Conj#t:Conj), respectively.  So I'm going to retire `Sum` & `All` from Tutorial 6 in favor of the `Additive` and `Conj` from here on.

I am also retiring the Semigroup `First` in favor of [Data.Maybe.First](https://pursuit.purescript.org/packages/purescript-maybe/3.0.0/docs/Data.Maybe.First). But this type signature is a little different from the `First` we saw in Tutorial 6.  Fortunately, it's relatively easy to modify our original implementation.  Plus, it allows me to introduce a major type constructor `Maybe` (sometimes called `Option` in other FP languages), which is the subject of our next in-depth look.

## Maybe I will, Maybe I won't
Imagine we decide to augment our `Person` record from above by giving the user the option to withhold their age.  After all, my mother taught me that it is impolite to ask someone their age - right?  Well, the `Maybe` type constructor is an excellent way to make optional cases like this one explicit; creating clarity and preventing confusion by readers of our code. As we can see below, the Maybe constructor has two potential values, `Nothing` or `Just a`.

```haskell
data Maybe a = Nothing | Just a
```
You can think of `Maybe` as something like a type-safe `null`, where `Nothing` is `null` and `Just a` is the non-null value of type `a`.  So, augmenting the `age` type in our `Person` record, we get:

```haskell
type Person =
  { firstName :: String
  , lastName  :: String
  , age       :: Maybe Int
  }
```

And, we follow this with an update to our `makePerson` function:

```haskell
makePerson :: String -> String -> Maybe Int -> Person
makePerson = { firstName: _, lastName: _, age: _ }
```

Finally, here's our function assignment:

```haskell
makePerson "Keith" "Emerson" Nothing
makePerson "Greg" "Lake" Nothing
makePerson "Carl" "Palmer" (Just 67)
```

Note that `Maybe` is also a functor (and other abstractions covered in future tutorials), so `map` (covered in [Tutorial 2](https://github.com/adkelley/javascript-to-purescript/tree/master/tut07) works like a charm:

```haskell
isOverForty :: Maybe Int -> Maybe Boolean
isOverForty = map (_ > 40)
```

If the argument to `isOverForty` is `Nothing` then `map` will skip the anonymous function and return `Nothing`; otherwise, execute the comparison expression and return `Just true` or `Just false`.  Note that pattern matching (more on this in the next section) would have worked just as well:

```haskell
isOverForty :: Maybe Int -> Maybe Boolean
isOverForty (Just age) = Just (age > 40)
isOverForty _ = Nothing
```

At last, we've introduced records, the `Maybe` type constructor, and retired `Sum`, `All` and `First` semigroups from Tutorial 6 for their PureScript library counterparts.  Now we're ready to solve the problem of merging Nico's multiple game accounts using Semigroups.

## Merging multiple records using Semigroups
To repeat what we want to accomplish in the main topic of this tutorial: we have a user, Nico, who has accidentally created three separate accounts on our site and has subsequently issued a support ticket to merge them.  How do we go about closing this ticket?

One nice property of semigroups is that if you have a record whose objects are semigroups, then that record is also a semigroup.  Thus, to append two or more record semigroups together, we append each of the objects that make up these data structures.  

Now, after covering records in detail, I hope it is no surprise that I'm using this construct to represent a user account:

```haskell
type Account = Record
  ( name    :: First String
  , isPaid  :: Conj Boolean
  , points  :: Additive Int
  , friends :: Array String
  )
```

We also want a function to log the contents of an `Account` to the console.  As shown below, I'm using a couple of new tricks, namely pattern matching and folds to 'pretty print' the record to the console.

```haskell
showAccount :: Account -> String
showAccount { name, isPaid, points, friends } =
  foldr (<>) ""
    [ "{ name: ", show name, ",\n  "
    , "isPaid: ", show isPaid, ",\n  "
    , "points: ", show points, ",\n  "
    , "friends: ", show friends, "  }"
    ]
```    

Let's cover these new constructs one at a time.

### Pattern Matching
In many FP languages, pattern matching is an integral part of development.  In `showAccount`, we used it to match values against the field names of `Account`.   But there are other variations on pattern matching that you should be made aware. For example, let's rewrite `isOverForty` from the previous section:

```haskell
isOverForty :: Maybe Int -> Maybe Boolean
isOverForty (Just age) = Just (age > 40)
isOverForty _ = Nothing
```

But, in this case, I still prefer the `map` implementation above for its succinctness.  

### Folds
In `showAccount`, I used the function fold right (`foldr`) to concatenate my labels and contents of `Account` into one big string.  Otherwise, my function would have looked like this:

```haskell
showAccount :: Account -> String
showAccount { name, isPaid, points, friends } =
  "{ name: "  <> show name    <> ",\n  " <>
  "isPaid: "  <> show isPaid  <> ",\n  " <>
  "points: "  <> show points  <> ",\n  " <>
  "friends: " <> show friends <> "  }"
```

Not only is this ugly, but it violates the DRY (Don't repeat yourself) principle by repeating virtually the same concatenation pattern four times! Fortunately, we can DRY this up with the help of a fold.  

Like pattern matching, folds are ubiquitous in FP.  We use them to reduce any structure that is foldable, as in concatenating a list or array of strings into a single string.  Below is the type signature for `foldr`:

```haskell
foldr :: forall a b s. Foldable s => (a -> b -> b) -> b -> s a -> b
```

For example, you can think of a fold on lists (e.g., 1 : 2 : 3 : Nil)  as replacing  the Nil at the end of the list `l` with the value `b`.  Then, replace each cons `(:)` with the binary function `(a -> b -> b)`.  So how does `foldr` evaluate?  Well, let's create a recursive implementation on a list, and then it will be clear:

```haskell
foldr :: forall a b. (a -> b -> b) -> b -> List a -> b
foldr f z xs =
  case xs of
    Nil -> z
    (x : xs) -> f x foldr f z xs
```    

You should see that `foldr` is right-associative, which means how we group the associativity of an operator in the absence of parenthesis.  Putting the parenthesis in, we get: `(x : xs) -> f x (foldr f z xs)`.

For a concrete example, let the List `(1 : 2 : 3 : Nil)` be our foldable structure `s`;  `(+)` be the function `(a -> b -> b)`; and `0` be the specific value `b`. Then, by recursively parenthesizing we get: `(+) 1 ((+) 2 ((+) 3 0))`.

Just as `foldr` is right-associative, there is a fold function that is left-associative, namely `foldl` (duh).  It has the same type signature, but the recursive implementation is different and will produce a different output depending on whether the binary function `(a -> b -> b)` is associative.

```haskell
foldl :: forall a b. (a -> b -> b) -> b -> List a -> b
foldl f z xs =
  case xs of
    Nil -> z
   (x:xs) = let z' = f z x
            in foldl f z' xs
```                   
In the case of `(+)` there will be no difference because addition is associative.  But, if the binary operator is not associative, (e.g., subtraction) then we will get a different answer depending on whether you use `foldl` or `foldr`; so be careful.

`foldl: ((-) ((-) ((-) 0 1) 2) 3) = -6 /= foldr: (-) 1 ((-) 2 ((-) 3 0)) = 2`

### appendAccount

```haskell
appendAccount :: Account -> Account -> Account
appendAccount
  { name: a1, isPaid: b1, points: c1, friends: d1 }
  { name: a2, isPaid: b2, points: c2, friends: d2 } =
  { name: a1 <> a2, isPaid: b1 <> b2, points: c1 <> c2, friends: d1 <> d2 }

infixr 5 appendAccount as ++
```


## Navigation
[< Tutorial 6](https://github.com/adkelley/javascript-to-purescript/tree/master/tut06) Tutorials [Tutorial 8 >](https://github.com/adkelley/javascript-to-purescript/tree/master/tut08)

You may find that the README for the next tutorial is under construction. But if you're an eager beaver and would like to look ahead, then all the of code samples from Brian's [videos](https://egghead.io/courses/professor-frisby-introduces-composable-functional-javascript) have been ported to PureScript already. But I may amend them as I write the accompanying tutorial markdown.  
