require 'pp'
class Developer

  MAX_TASKS = 10

  def initialize dev_name
    @dev_name  = dev_name
    @task_list = []
  end

  def add_task task_name
    @task_list.push task_name
    if @task_list.count > self.class::MAX_TASKS
      raise 'Слишком много работы!'
    end
    puts %Q{#{@dev_name}: добавлена задача "#{task_name}".Всего в списке задач: #{@task_list.count}}
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
end

class Team

  attr_reader :seniors, :juniors, :developers

  def initialize(&block)
    @team = []
    instance_eval &block
  end

  def have_seniors(*dev_names)
    @seniors = dev_names
    @seniors.map{|i| make_developer(SeniorDeveloper, i)}
  end

  def have_developers(*dev_names)
    @developers = dev_names
    @developers.map{|i| make_developer(Developer, i)}
  end

  def have_juniors(*dev_names)
    @juniors = dev_names
    @juniors.map{|i| make_developer(JuniorDeveloper, i)}
  end

   def make_developer(type, dev_name)
     @team.push(type.new(dev_name))
   end

end

team = Team.new do

  have_seniors 'oleg', 'oksana' 
  have_developers "Олеся", "Василий", "Игорь-Богдан"
  have_juniors "Владислава", "Аркадий", "Рамеш"
  @team.each{|i| puts i}
end
 pp team
# pp team.seniors
# pp team.juniors
# pp team.developers
