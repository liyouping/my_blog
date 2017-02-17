# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
categorys = Category.create([{name: 'ROR'},{name: '运维'},{name: 'css'},{name: 'javascript'},{name: '微信小程序'},{name:'DataBase'},{name: 'Python'},{name: 'PHP'}])

tags = Tag.create([{name: '运维'},{name: '部署'},{name:'ruby'},{name:'rails'},{name: 'javascript'},{name: 'css'}])