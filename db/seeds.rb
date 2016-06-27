# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Course.delete_all
Course.create name: "Assinatura (1 ano)", price: 89.90, recurring:true, period: "Month",cycles: 12
Course.create name: "Assinatura (6 meses)", price: 49.90, recurring:true, period: "Month",cycles: 6
