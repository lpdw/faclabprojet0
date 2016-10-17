# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(login: 'usertest', email: 'test@test.fr', password: 'test123')

places = Place.create([ {name:'salle1' }, {name: 'salle2'}, {name: 'salle3'} ])

year = 2016
month = 1
day = 1
week_day = 5

while (month <= 12)
  while (day <= 31)
    unless ((month == 2 && day > 29) || (month == 4 && day > 30) || (month == 6 && day >30) || (month == 9 && day > 30) || (month == 11 && day >30))
      if(week_day != 6 &&  week_day !=7)
        nb_visites = Random.rand(1...15)
        while (nb_visites > 0)
          Visit.create(date_visit: DateTime.new(year,month,day, Random.rand(9...20), Random.rand(1...60), Random.rand(1...60), '+2') , place: places[Random.rand(0...3)])
          nb_visites-=1
        end
      end
    end
    week_day +=1
    if(week_day == 8)
      week_day = 1
    end
    day+=1
  end
  month+=1
  day=1
end
