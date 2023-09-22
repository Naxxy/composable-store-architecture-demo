# composable-store-architecture-demo
A project to demonstrate the value of good abstractions, interface segregation, and the composable networking and persistence architecture that can occur as a result.


### TODO:
- Change the DataLayer groups to packages. 
    - We want to demonstrate how each group is independent.
    - We want to demonstrate how the domain models (including loader & caching protocols) can be a common package that the networking and persistence packages depend upon.
- Change the loader protocol to use Data instead of Teaser types
    - We want to show how the loader can be separated from the mapper
    - We want to show how the loader and mapper can be used separately in the combine flow
      
