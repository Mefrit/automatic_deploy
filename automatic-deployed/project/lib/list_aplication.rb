# frozen_string_literal: true

# documentation
class ListAplication
  # documentation
  attr_reader :list_aplication, :list_district_aplic
  def initialize
    @list_aplication = []
    @list_district_aplic = []
  end

  def add_aplication(obj)
    @list_aplication << obj
    @list_district_aplic << obj.district if !@list_district_aplic.include?(obj.district)
  end

  def each
    @list_aplication.each { |aplication| yield aplication }
  end

  def return_aplic_order_kol_rooms(district)
    @res = []
    @list_aplication.each do |value|
      @res.push(value) if value.district == district
    end
    @res = @res.sort do |a, b|
      a.kolRoom.to_i <=> b.kolRoom.to_i
    end
    @res
  end

  def return_kol_rooms_aplic(id_el)
    @res = 0
    @list_aplication.each do |value|
      @res = value.kolRoom if value.id == id_el
    end
    puts @res
    @res
  end

  def delete_aplication(id)
    @list_aplication.each do |elem|
      elem.delete = true if elem.id.to_i == id.to_i
    end
  end

  def return_statistic(apart, district_list)
    @arr_res_apart = Hash.new('')
    @col_aplication = 0
    district_list.each do |elem|
      @col_aplication = 0
      puts '_______________________________________'

      @list_aplication.each do |elem_apl|
        @col_aplication += 1 if elem_apl.district == elem
      end
      @arr_res_apart[elem] = apart.return_statistic_apapt(elem).push(@col_aplication)
      puts @arr_res_apart
    end
    @arr_res_apart
    end
end
