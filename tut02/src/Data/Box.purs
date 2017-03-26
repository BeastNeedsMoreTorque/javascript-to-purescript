module Data.Box
  ( Box(..)
  , fold
  ) where

import Prelude

-- const Box = x =>
newtype Box a = Box a
-- map: f => Box(f(x))
instance functorBox :: Functor Box where
 map f (Box x) = Box (f x)
-- -- inspect: () => 'Box($(x))'
instance showBox :: Show a => Show (Box a) where
  show (Box a) = "Box(" <> show a <> ")"
-- fold: f => f(x)
-- Box(Number) is not a monoid, and therefore unfoldable
-- so we run a function (fold) that pattern matches on x to
-- compute f x
fold :: forall a b. (a -> b) -> Box a -> b
fold f (Box x) = f x