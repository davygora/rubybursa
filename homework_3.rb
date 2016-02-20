#main class
class Developer

  def initialize(dev_name)
    @dev_name = dev_name
    @task_list = []
  end

  def add_task(task_name)
  	@task_list.push(task_name)
  	puts %Q{#{@dev_name}: добавлена задача "#{task_name}".Всего в списке задач: #{@task_list.count}}
  end

  def tasks
  	@task_list.map.with_index{ |a, i| "#{i+1}. #{a}"}
  end


end

#dev = Developer.new('Vasya')
#dev.add_task('Programming')
puts dev.tasks
