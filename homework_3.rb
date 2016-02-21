class Developer

  MAX_TASKS = 10

  def initialize(dev_name)
    @dev_name = dev_name
    @task_list = []
  end

  def add_task(task_name)
    @task_list.push(task_name)
    begin
      if @task_list.count > MAX_TASKS
        raise ArgumentError
      end
      puts %Q{#{@dev_name}: добавлена задача "#{task_name}".Всего в списке задач: #{@task_list.count}}
    rescue ArgumentError
      @task_list.pop
      puts "Слишком много работы!"
    end
  end

  def tasks
    @task_list.map.with_index{ |a, i| "#{i+1}. #{a}"}
  end

  def work!
    begin
      if @task_list.empty?
        raise ArgumentError, 'Нет задач'
      end
    puts %Q{#{@dev_name}: выполнена задача "#{@task_list.shift}". Осталось задач: #{@task_list.count}}
    rescue ArgumentError
      puts "Нечего делать!"
    end
  end

  def status
    if @task_list.empty?
      'свободен'
      elsif @task_list.count > 0 && @task_list.count < 10
      'работаю'
      else
        'занят'
    end
  end

  def can_add_task?
    @task_list.count < MAX_TASKS
  end

  def can_work?
    @task_list.count > 0
  end

end
