#Получаем данные с консоли.
x_point, y_point, x, y = ARGV

#Проверка координат
if x_point == x && y_point == y
	puts 'Точка найдена!'
elsif x_point == x && y_point != y
	puts 'х координата верна, y нет'
elsif x_point != x && y_point == y
	puts 'y координата верна, x нет'
else
	puts "Близко, но нет"
end
