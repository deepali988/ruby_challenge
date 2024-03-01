class Item
  attr_reader :name, :unit_price, :sale_price, :sale_quantity

  def initialize(name, unit_price, sale_price = nil, sale_quantity = nil)
    @name = name
    @unit_price = unit_price
    @sale_price = sale_price
    @sale_quantity = sale_quantity
  end

  def price(quantity)
    return (quantity / @sale_quantity) * @sale_price + (quantity % @sale_quantity) * @unit_price if @sale_price && @sale_quantity

    quantity * @unit_price
  end
end

class DiscountCalculator
  ITEMS = {
    'Milk' => Item.new('Milk', 3.97, 5.00, 2),
    'Bread' => Item.new('Bread', 2.17, 6.00, 3),
    'Banana' => Item.new('Banana', 0.99),
    'Apple' => Item.new('Apple', 0.89)
  }.freeze

  def initialize
    @cart = Hash.new(0)
  end

  def add_item(item_name)
    @cart[item_name.capitalize] += 1
  end

  def total_price
    total = 0
    @cart.each do |item_name, quantity|
      item = ITEMS[item_name]
      total += item.price(quantity)
    end
    total
  end

  def print_receipt
    puts "Item     Quantity      Price"
    puts "--------------------------------------"
    @cart.each do |item_name, quantity|
      item = ITEMS[item_name]
      puts "#{item.name.ljust(9)} #{quantity.to_s.ljust(12)} $#{'%.2f' % item.price(quantity)}"
    end
    puts "\nTotal price: $#{'%.2f' % total_price}"
    puts "You saved $#{'%.2f' % total_saved} today."
  end

  private

  def total_saved
    total = 0
    @cart.each do |item_name, quantity|
      item = ITEMS[item_name]
      total += (quantity * item.unit_price) - item.price(quantity)
    end
    total
  end
end

def main
  calculator = DiscountCalculator.new
  puts "Please enter all the items purchased separated by a comma:"
  input = gets.chomp.strip.downcase.split(',')
  input.each { |item| calculator.add_item(item.strip.capitalize) }
  calculator.print_receipt
end

main