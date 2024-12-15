class Api::V1::Booksuite::TestsController < SecuredController
  def test
    render json: { message: "Hello from BookSuite API", current_user: current_user.email }
  end

  def test_scoped
    validate_permissions ['read:messages'] do
      render json: { message: 'Hello from a private endpoint! You need to be authenticated and have a scope of read:messages to see this.' }
    end
  end
end
