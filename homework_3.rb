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
    puts messages[:add_task] % [dev_name, task_name, @task_list.count]
  end

  def tasks
    @task_list.map.with_index{ |a, i| "#{i+1}. #{a}"}
  end

  def work!
    task_name = @task_list.shift or raise 'Нечего делать!'
    do_task(task_name)
  end

  def status
    case
      when !can_work? then 'свободен'
      when !can_add_task? then 'занят'
      else 'работаю'
    end
  end

  def can_add_task?
    @task_list.count < self.class::MAX_TASKS
  end

  def can_work?
    !@task_list.empty?
  end

private

  def messages
    self.class::MESSAGES
  end

  def do_task(task_name)
    puts messages[:work] % [dev_name, task_name, @task_list.count]
  end
end

class JuniorDeveloper < Developer

  MAX_TASKS  = 5
  MAX_TASK_LENGTH = 20

  MESSAGES = Developer::MESSAGES.merge(
    work: '%s: пытаюсь делать задачу "%s". Осталось задач: %i'
  )

  def add_task(task_name)
    raise 'Слишком сложно!' if task_name.length > MAX_TASK_LENGTH
    super
  end
end

class SeniorDeveloper < Developer

  MAX_TASKS = 15

  def work!
    can_work? or raise 'Нечего делать!'

    if rand > 0.5
      puts 'laziness :('
    else
      [2, @task_list.count].min.times{|t| do_task(@task_list.shift)}
    end
  end
end
