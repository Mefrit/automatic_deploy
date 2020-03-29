# frozen_string_literal: true

require 'sinatra'
require_relative 'lib/list_apartament'
require_relative 'lib/apartment'
require_relative 'lib/list_aplication'
require_relative 'lib/aplication'

configure do
  @all_district = []
  f = File.new('data/dataApartment.txt')
  @list_apart = []
  set :result, @list_apart
  set :same_apart, false
  set :id_aplication, -1
  @list_apart = ListApartament.new
  while line = f.gets
    @arr_data = line.split(/,\s*/)
    @elem = Apartament.new(
      [@arr_data[0],
       @arr_data[1],
       @arr_data[2],
       @arr_data[3],
       @arr_data[4],
       @arr_data[5],
       @arr_data[6],
       @arr_data[7],
       @arr_data[8]]
    )
    @list_apart.add_apartament(@elem)
    @all_district << @arr_data[4] if !@all_district.include?(@arr_data[4])
  end

  set :kind_resultObj, true
  set :apart_list, @list_apart
  f.close
  @list_aplic = ListAplication.new
  f = File.new('data/dataAplication.txt')
  while line = f.gets
    @arr_data1 = line.split(/,\s*/)
    @elem = Aplication.new(
      @arr_data1[0],
      @arr_data1[1],
      @arr_data1[2],
      @arr_data1[3]
    )
    @list_aplic.add_aplication(@elem)
    @all_district << @arr_data1[1] if !@all_district.include?(@arr_data1[1])
  end
  set :aplication_list, @list_aplic
  set :all_district_list, @all_district
  f.close
end
get '/' do
  @aplication_list = settings.aplication_list
  @apart_list = settings.apart_list
  erb :index
end
get '/del/:item_id' do |item_id|
  @apart_list = settings.apart_list
  File.open('data/data.txt', 'w') do |file|
    @apart_list.each do |elem|
      if !item_id.to_i.equal?(elem.id.to_i) && !elem.delete
        @str_dop = elem.district + ',' + elem.street + ',' + elem.numb_house + ',' + elem.kind_house + ',' + elem.cost
        @str = elem.id + ',' + elem.kol_room + ',' + elem.footage + ',' + elem.kol_floors + ',' + @str_dop
        file.puts @str
      end
      elem.delete = true if item_id.to_i.equal?(elem.id.to_i)
    end
  end
  redirect to('/')
end
get '/delAplic/:item_id' do |item_id|
  @aplic_list = settings.aplication_list
  File.open('data/dataAplication.txt', 'w') do |_file|
    @aplic_list.each do |elem|
      @str_dop = elem.kol_room + ',' + elem.kind_house
      @str = elem.id + ',' + elem.district + ',' + @str_dop if !item_id.to_i.equal?(elem.id.to_i) && !elem.delete
      elem.delete = true if !(!item_id.to_i.equal?(elem.id.to_i) && !elem.delete)
    end
  end
  redirect to('/')
end
get '/findSame/:item_id' do |item_id|
  settings.result = settings.apart_list.find_same_apart(settings.aplication_list.get_kol_rooms_aplic(item_id))
  settings.kind_resultObj = true
  settings.same_apart = true
  settings.id_aplication = item_id
  redirect to('/result')
end
get '/same_apartDelApl/:item_id' do |item_id|
  @arr = item_id.split('&')
  # puts '---------++++++++++++++++++++++++++++=='
  settings.apart_list.delete_apartament(@arr[0])
  settings.aplication_list.delete_aplication(@arr[1])

  redirect to('/')
end
get '/add_aplication' do
  erb :add_aplication
end
get '/add_apartament' do
  erb :add_apartament
end
get '/allFloots' do
  @apart_list = settings.apart_list
  erb :allFloots
end
post '/aplication/new' do
  @id = rand(100_000)
  File.open('data/dataAplication.txt', 'a+') do |file|
    file.puts @id.to_s + ',' +
              params['district'] + ',' +
              params['kol_rooms'] + ',' +
              params['kind_house']
  end
  settings.all_district_list << params['district'] if !settings.all_district_list.include?(params['district'])
  @apart = Aplication.new(
    @id,
    params['district'],
    params['kol_rooms'],
    params['kind_house']
  )
  settings.aplication_list.add_aplication(@apart)
  redirect to('/')
end
post '/findAplicDistr' do
  settings.same_apart = false
  settings.kind_resultObj = true
  settings.result = settings.aplication_list.return_aplic_order_kol_rooms(params['districtAplication'])
  redirect to('/result')
end
post '/statistics' do
  settings.same_apart = false
  settings.kind_resultObj = false
  settings.result = settings.aplication_list.return_statistic(settings.apart_list, settings.all_district_list)
  redirect to('/result')
end
post '/apartamentsDistr' do
  settings.kind_resultObj = true
  settings.result = settings.apart_list.return_apart_order_distr
  redirect to('/result')
end
post '/get_apart_certain_value' do
  settings.result = settings.apart_list.return_apart_certain_value(params['min'], params['max'])
  settings.kind_resultObj = true
  redirect to('/result')
end
get '/result' do
  @res = settings.result
  @kind_res = settings.kind_resultObj
  @same_apart = settings.same_apart
  puts @res
  erb :result
end
post '/apartament/new' do
  @id = rand(100_000)
  File.open('data/dataApartment.txt', 'a+') do |file|
    file.puts @id.to_s + ',' +
              params['kol_rooms'] + ',' +
              params['footage'] + ',' +
              params['kol_floors'] + ',' +
              params['district'] + ',' +
              params['street'] + ',' +
              params['numb_house'] + ',' +
              params['kind_house'] + ',' +
              params['cost']
  end
  settings.all_district_list << params['district'] if !settings.all_district_list.include?(params['district'])
  @apart = Apartament.new(
    [@id,
     params['kol_rooms'],
     params['footage'],
     params['kol_floors'],
     params['district'],
     params['street'],
     params['numb_house'],
     params['kind_house'],
     params['cost']]
  )
  settings.apart_list.add_apartament(@apart)
  redirect to('/')
end
