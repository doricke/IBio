
  my_time = Time::local(2014, 5, 8, 6, 32, 20, 10 )

  is_now = Time::now

  puts "my time: #{my_time}  now: #{is_now}"

  # gimley = Individual.find_by_code_name( "Gimley" )

  # meal = Meal.create(individual_id: gimley.id, consumed_at: my_time)
  meal = Meal.find(1)

  puts "id: #{meal.id} when #{meal.consumed_at}"

