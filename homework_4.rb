require_relative 'homework_3'
require 'pp'
class Developer
  
  GROUP = :developers

  def group
    self.class::GROUP
  end

  def kind
    group.to_s.sub(/s$/, '').to_sym
  end

  attr_reader :task_list
end

class JuniorDeveloper
  GROUP = :juniors
end

class SeniorDeveloper
  GROUP = :seniors
end

class Team

  def initialize(&block)
    @members = []
    @on_tasks = {}
    instance_eval &block
  end

  def all
    @members
  end

  def juniors
    @members.grep(JuniorDeveloper)
  end

  def seniors
    @members.grep(SeniorDeveloper)
  end

  def developers
    @members.select{|member| member.class == Developer}
  end

  def add_task(task_name, complexity: nil, to: nil)
    q = queue.dup
    q.select!{|dev| dev.kind == complexity} if complexity
    q.select!{|dev| dev.name == to} if to

    q.first.tap do |dev|
      dev.add_task(task_name)
      @on_tasks[dev.kind].tap{|on| on && on.call(dev, task_name)}
    end
  end

  def report
    queue.each do |dev|
      puts '%s (%s): %s' % [dev.name, dev.kind, dev.task_list.join(', ')]
    end
  end

  private

  def have_juniors(*names)
    have_members JuniorDeveloper,*names
  end

  def have_seniors(*names)
    have_members SeniorDeveloper, *names
  end

  def have_developers(*names)
    have_members Developer, *names
  end

  def have_members(klass, *names)
    names.each{|n| @members << klass.new(n)}
  end

  def priority(*groups)
    @priority = groups
  end

  def on_task(kind, &block)
    @on_tasks[kind] = block
  end

  def queue
    @members.sort_by{|dev| [dev.task_list.count, @priority.index(dev.group) || 100]}
  end
end

#Create team of developers
team = Team.new do

  have_seniors "Олег", "Оксана"
  have_developers "Олеся", "Василий", "Игорь-Богдан"
  have_juniors "Владислава", "Аркадий", "Рамеш"

  priority :juniors, :developers, :seniors

  on_task :junior do |dev, task|
    puts "Отдали задачу #{task} разработчику #{dev.name}, следите за ним!"
  end

  on_task :senior do |dev, task|
    puts "#{dev.name} сделает #{task}, но просит больше с такими глупостями не приставать"
  end
end
