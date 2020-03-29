# frozen_string_literal: true

# documentation
class Aplication
  attr_reader :id, :kol_room, :district,
              :kind_house
  attr_accessor :delete
  def initialize(id, distr, kol_rooms, kind_house)
    @district = distr
    @id = id
    @kol_room = kol_rooms
    @kind_house = kind_house
    @delete = false
  end

  def return_inf
    "District: #{@district} kolRooms #{@kol_room}  kind:   #{@kind_house}"
  end
end
