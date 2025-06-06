require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "render a list of products" do
    get products_path

    assert_response :success
    assert_select ".product", 3
    assert_select ".category", 3
  end

    test "render a list of products filtered by category" do
    get products_path(category_id: categories(:videogames).id)

    assert_response :success
    assert_select ".product", 2
  end

    test "render a list of products filtered by min_price and max_price" do
    get products_path(min_price: 190, max_price: 200)

    assert_response :success
    assert_select ".product", 1
    assert_select "h2", "Nintendo Switch"
  end

  test "render a detailed product page" do
    get product_path(products(:ps4))
    assert_response :success
    assert_select ".title", "PS4 Fat"
    assert_select ".description", "Ps4 en buen estado"
    assert_select ".price", "150 $"
  end

  test "render a new product_form" do
    get new_product_path
    assert_response :success
    assert_select "form"
  end

 test "allow to create a new product" do
   post products_path, params: {
    product: {
      title: "nuevo producto",
      description: "nuevo producto en buen estado",
      price: 150,
      category_id: categories(:videogames).id
    }
   }
   assert_redirected_to products_path
   assert_equal flash[:notice], "Tu producto se ha creado correctamente"
 end

 test "does not allow to create a new product with empty fields" do
   post products_path, params: {
    product: {
      title: "",
      description: "nuevo producto en buen estado",
      price: 150
    }
   }
   assert_response :unprocessable_entity
 end

   test "render a edit product_form" do
    get edit_product_path(products(:ps4))
    assert_response :success
    assert_select "form"
  end

   test "allow to update a product" do
   patch product_path(products(:ps4)), params: {
    product: {
      price: 120
    }
   }
   assert_redirected_to products_path
   assert_equal flash[:notice], "Tu producto se ha actualizado correctamente"
 end

   test "does not allow to update a product" do
   patch product_path(products(:ps4)), params: {
    product: {
      price: nil
    }
   }
   assert_response :unprocessable_entity
 end

 test "can delete products" do
  assert_difference "Product.count", -1 do
    delete product_path(products(:ps4))
  end

  assert_redirected_to products_path
  assert_equal flash[:notice], "Tu producto se ha eliminado correctamente"
 end
end
