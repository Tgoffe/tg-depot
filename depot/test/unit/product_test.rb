require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new

    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "Some product", description: "somewhere", image_url: "bla.jpg")
    
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  test "length must be less than 20" do
    product = new_product("seed")

    product.title = "sjdkfljaoifuawoeirualdfjkldnalkjfaoieruaoief"
    assert product.invalid?
    assert product.errors[:title]
  end

  test "image url" do
    good_url = ["pic.jpg", "pic.JPG", "pic.gif", "pic.GIF", "pic.png", "pic.PNG"]
    bad_url = ["pic.pic", "pic.gpj", "pic.pxl"]

    good_url.each do |name| 
      assert new_product(name).valid?
    end

    bad_url.each do |name| 
      assert new_product(name).invalid?
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title:  products(:shoes).title,
    	                  description: "bla",
    	                  price: "12.00",
    	                  image_url:  "pic.jpg")

    assert product.invalid?
    assert product.errors[:title]
  end

  def new_product(image_url)
  	Product.new(title: "Some Beach",
  		        description: "some where",
  		        price: "25.96",
  		        image_url: image_url)
  end
end
