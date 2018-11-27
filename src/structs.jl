# This module defines the structures required for the cell method.

## First, we define several types

## Then, we will use these types in the cell struct.

mutable struct Cell{T} <: Real

    temp :: T   # temperature

    D    :: T   # positive nonzero - heat capacity of that material

end
