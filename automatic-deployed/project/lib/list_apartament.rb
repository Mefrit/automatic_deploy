# frozen_string_literal: true

# documentation
class ListApartament
  attr_reader :list_apart, :list_district_apart
  def initialize
    @list_apart = []
    @list_district_apart = []
  end

  def add_apartament(obj)
    @list_apart << obj
    @list_district_apart << obj.district if !@list_district_apart.include?(obj.district)
  end

  def return_elem(index)
    @list_apart[index]
  end

  def each
    @list_apart.each { |apartment| yield apartment }
  end

  def delete_apartament(id_obj)
    @list_apart.each do |elem|
      elem.delete = true if elem.id.to_i == id_obj.to_i
    end
  end

  def return_apart_order_distr
    @res = @list_apart.sort_by { |elem| [elem.district, elem.footage.to_i] }
    @res
  end

  def del(value); end

  def return_apart_certain_value(min, max)
    @res = []
    @list_apart.each do |elem|
      @res << elem if elem.cost.to_i > min.to_i && elem.cost.to_i < max.to_i
    end
    @res
  end

  def return_statistic_apapt(district)
    @all_cost = 0
    @kol_distr = 0
    @all_footage = 0
    @list_apart.each do |elem|
      next unless elem.district == district

      @all_cost += elem.cost.to_i
      @kol_distr += 1
      @all_footage += elem.footage.to_i
    end
    if @kol_distr != 0
      @all_cost /= @kol_distr
      @all_footage /= @kol_distr
    end
    [@kol_distr, @all_cost, @all_footage]
  end

  def find_same_apart(kol_rooms)
    @res = []
    @list_apart.each do |elem|
      @eql = (elem.kolRoom.to_i - kol_rooms.to_i) * (elem.kolRoom.to_i - kol_rooms.to_i)
      puts @eql
      @res.push(elem) if @eql < 2
    end
    @res
  end
end
