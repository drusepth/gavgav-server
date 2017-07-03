# gavgav-server

This is a simple proof-of-concept Ruby server that tries some new stuff.

# Design decisions

1. Minimize overhead, boilerplate, and unnecessary code, _especially_ in code the developer didn't write and/or never touches.

## Models

- TBD

## Views

- TBD

## Controllers

1. All public controller instance methods automatically expose a server endpoint following this convention:

  ```
  http://localhost:3000/path/to/controller_name/method_name
  ```

  For example, a controller `SomeController` in `controllers/nested/other/some_controller.rb` with method `this_method` would expose

  ```
  http://localhost:3000/nested/other/some/this_method
  ```

  and it would look for an ERB view in `views/nested/other/some/this_method.html.erb.

2.

## Services

- TBD

# Quick Start

- TBD

# Running tests

- TBD