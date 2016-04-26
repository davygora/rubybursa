require 'pp'
class Developer

  attr_reader :task_list, :name

  MAX_TASKS = 10
  MESSAGES = {
    add_task: '%s: add task "%s". Count of tasks in list: %i',
    work: '%s: task is done "%s". Left to do tasks: %i'
  }

  attr_reader :dev_name

  def initialize dev_name
    @dev_name  = dev_name
    @task_list = []
  end

  def add_task(task_name)
    can_add_task? or raise 'Too much tasks!'

    @task_list << task_name
    puts messages[:add_task] % [dev_name, task_name, task_list.count]
  end

  def tasks
    @task_list.map.with_index{ |a, i| "#{i+1}. #{a}"}
  end

  def work!
    raise 'Нечего делать!' if @task_list.empty?
    puts %Q{#{@dev_name}: выполнена задача "#{@task_list.shift}". Осталось задач: #{@task_list.count}}
  end

  def status
    if @task_list.empty?
      'свободен'
      elsif @task_list.count > 0 && @task_list.count < self.class::MAX_TASKS
        'работаю'
      else
        'занят'
    end
  end

  def can_add_task?
    @task_list.count < self.class::MAX_TASKS
  end

  def can_work?
    @task_list.count > 0
  end

  def dev_type
    :developer
  end
end

class JuniorDeveloper < Developer

  MAX_TASKS  = 5
  MAX_LENGTH = 20

  def add_task task_name
    raise 'Слишком сложно!' if task_name.length > MAX_LENGTH
    super
  end

  def work!
    raise 'Нечего делать!' if @task_list.empty?
    puts %Q{#{@dev_name}: пытаюсь делать задачу "#{@task_list.shift}". Осталось задач: #{@task_list.count}}
  end

  def dev_type
    :junior
  end
end

class SeniorDeveloper < Developer

  MAX_TASKS = 15

  def work!
    raise 'Нечего делать!' if @task_list.empty?
    random_boolean = [true,false].sample
    if random_boolean == true
      2.times{puts %Q{#{@dev_name}: выполнена задача "#{@task_list.shift}". Осталось задач: #{@task_list.count}}} 
    else
      puts 'Что-то лень'
    end
  end

  def dev_type
    :senior
  end
end

class Team

  attr_reader :seniors, :juniors, :developers

  def initialize(&block)
    @team_array = []
    @seniors    = []
    @developers = []
    @juniors    = []
    @filtres    = {}
    instance_eval &block
  end

  def have_seniors(*dev_names)
    dev_names.each{|i| @seniors.push(make_developer(SeniorDeveloper, i))}
    @team_array.push(@seniors)
  end

  def have_developers(*dev_names)
    dev_names.each{|i| @developers.push(make_developer(Developer, i))}
    @team_array.concat(@developers)
  end

  def have_juniors(*dev_names)
    dev_names.each{|i| @juniors.push(make_developer(JuniorDeveloper, i))}
    @team_array.concat(@juniors)
  end

  def make_developer(type, dev_name)
     type.new(dev_name)
  end

  def on_task(name, &block)
    @filtres[name] = block
  end

  def add_task(task)
    # :( не отрабатывает on_task
  end

  def all
    @team_array
  end

  def priority(*list)
    @priority = list
  end

end

team = Team.new do

  have_seniors 'Олег', 'Оксана' 
  have_developers "Олеся", "Василий", "Игорь-Богдан"
  have_juniors "Владислава", "Аркадий", "Рамеш"

  priority :juniors, :developers, :seniors

on_task (:junior) do |dev, task|
  puts "Отдали задачу #{task} разработчику #{dev.name}, следите за ним!"
end

on_task (:developer) do |dev, task|
  puts "Девелопер #{dev.name} крутит носом, но задачу #{task} сделает!"
end

on_task (:senior) do |dev, task|  
  puts "#{dev.name} сделает #{task}, но просит больше с такими глупостями не приставать!"
end
end

pp team.all
puts team.seniors
puts team.juniors
puts team.developers
team.report
