class Developer

  MAX_TASKS = 10
  MESSAGES = {
    add_task: '%s: add task "%s". Count of tasks in list: %i',
    work: '%s: task is done "%s". Left to do tasks: %i'
  }

  attr_reader :dev_name

  def initialize(dev_name)
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
    if @task_list.empty?
      raise 'Нечего делать!'
    end
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

  def add_task(task_name)
    super
    if task_name.length > MAX_LENGTH
      raise 'Слишком сложно!'
    end
  end

  def work!
    if @task_list.empty?
      raise 'Нечего делать!'
    end
    puts %Q{#{@dev_name}: пытаюсь делать задачу "#{@task_list.shift}". Осталось задач: #{@task_list.count}}
  end

end

class SeniorDeveloper < Developer

  MAX_TASKS = 15

  def work!
    if @task_list.empty?
      raise 'Нечего делать!'
    end
    random_boolean = [true,false].sample
    if random_boolean == true
      2.times{puts %Q{#{@dev_name}: выполнена задача "#{@task_list.shift}". Осталось задач: #{@task_list.count}}} 
    else
      puts 'Что-то лень'
    end
  end
end
