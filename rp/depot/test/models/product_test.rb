require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  fixtures :products

  test "Все поля должны быть заполнены" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
  	assert product.errors[:image_url].any?
  	assert product.errors[:price].any?
  end
  
  test "Цена товара должна быть больше или равна 0,01" do
  	product= Product.new(title: 'My book title',
  		                  description: 'xxx',
  		                  image_url: 'sd.jpg')
  	
  	product.price = -1
  	assert product.invalid?
  	assert_equal ["должно быть больше или равно 0,01"],
  	product.errors[:price]
  	
  	product.price = 0
  	assert product.invalid?
  	assert_equal ["должно быть больше или равно 0,01"],
  	product.errors[:price]
  	
  	product.price = 1
  	assert product.valid?
  end

  def new_product(image_url)
  	Product.new(title: 'My book title',
  		          description: 'xxx',
  		          image_url: image_url,
  		          price: 1)
  end

  test "URL изображения" do
  	ok = %w{ freq.gif freq.jpg freq.png FREQ.JPG FREQ.Jpg http://a.b.c/x/e/x/freq.gif }
  	bad = %w{ freq.doc freq.gif/more freq.gif.more }
  	ok.each do |name|
  		assert new_product(name).valid?, "#{name} не должно быть неприемлемым"
  	end
  	bad.each do |name|
  		assert new_product(name).valid?, "#{name} не должно быть неприемлемым"
  	end
  end

  test "Имя продукта не уникально" do
    product = Product.new(title: products(:ruby).title,
                          description: "hdsgh",
                          price: 1,
                          image_url: "freq.gif")
    assert product.invalid?
    assert_equal ["уже было использовано"], product.errors[:title]
  end

  test "Имя продукта не уникально - i18n" do
    product = Product.new(title: products(:ruby).title,
                          description: "hdsgh",
                          price: 1,
                          image_url: "freq.gif")
    assert product.invalid?
    assert_equal [I18n.translate('activerecord.errors.messages.taken')], product.errors[:title]
  end

end
