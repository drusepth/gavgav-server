class TestController
  def some_public_method
    {
      some_named_variable: 'the value!',
      some_computation: 1 + 6 + 2,
      some_function_call: some_private_method
    }
  end

  private

  def some_private_method
    'hello'
  end
end