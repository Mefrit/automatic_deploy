# frozen_string_literal: true

# documentation
class Apartament
  attr_reader :id, :kol_room, :district,
              :footage, :kol_floors, :street, :numb_house, :kind_house, :cost
  attr_accessor :delete
  def initialize(arr_data)
    @id = arr_data[0]
    @footage = arr_data[1]
    @kol_room = arr_data[2]
    @kol_floors = arr_data[3]
    @district = arr_data[4]
    @street = arr_data[5]
    @numb_house = arr_data[6]
    @kind_house = arr_data[7]
    @cost = arr_data[8]
    @delete = false
  end

  def del(value)
    @this.delete = value
  end

  def return_inf
    " <p>Adress:#{@district} :#{@street}:#{@numb_house}cost: #{@cost}room: #{@kol_room} #{@footage}</p>"
  end

  attr_reader :get_numb_rooms

  def return_district
    @district
  end

  #   def get_footage
  #     @footage
  #   end

  #   def get_cost
  #     @cost
  #   end
end
