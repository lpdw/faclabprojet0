# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(login: 'admin', email: 'admin@test.fr', password: 'test123')

places = Place.create([ {name:'salle1' }, {name: 'salle2'}, {name: 'salle3'} ])

start_date = Date.new(2014,1,1)
end_date = DateTime.now.to_date
while ((start_date <=> end_date) != 0)
  if(start_date.cwday != 6 && start_date.cwday != 7)
    nb_visites = Random.rand(1..10)
    while (nb_visites > 0)
      places.length.times do |i|
        Visit.create(date_visit: DateTime.new(start_date.year, start_date.mon, start_date.day, Random.rand(9...20), Random.rand(1...60), Random.rand(1...60)) , place: places[i])
      end
      nb_visites-=1
    end
  end
  start_date = start_date.next_day(1)
end
