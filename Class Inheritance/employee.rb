require 'byebug'
class Employee
    attr_reader :salary, :name
    attr_accessor :boss
    def initialize(name, salary, title, boss = nil)
        @name, @salary, @title, @boss = name, salary, title, boss
    end

    def inspect
        "Employee: #{self.name}"
    end

    def bonus(multiplier)
        self.salary * multiplier
    end
end

class Manager < Employee
    attr_accessor :employees
    def initialize(name, salary, title, boss = nil)
        super
        @employees = []
    end

    # def inspect
    #     "#{self.name} Manages: #{@employees}"
    # end

    def bonus(multiplier)
        return self.salary * multiplier if self.employees.empty?
        queue =  [self]
        total_employee_salary = 0
        until queue.empty?
            boss = queue.shift
            total_employee_salary += boss.salary unless boss == self
            queue += boss.employees if boss.is_a?(Manager)
        end
        total_employee_salary * multiplier
    end
        
        #  total_employee_salary = 0
        #  self.employees.each do |employee|
        #     total_employee_salary += employee.salary
        #  end
        #  subordinates = self.employees.employees
        #  until subordinates.empty?
        #     subordinates.each do |employee|
        #         total_employee_salary += employee.salary
        #         subordinates = employee.employees
        #     end
        #  end
        # total_employee_salary * multiplier
end

ned = Manager.new('Ned', 100000, "Founder",)
darren = Manager.new('Darren', 78000, "TA Manager", ned)
shawna = Employee.new('Shawna', 12000, "TA", darren)
david = Manager.new('David', 10000, "TA",darren)

ned.employees += [darren]
darren.employees += [shawna,david]


p ned.bonus(5) # => 500_000
p darren.bonus(4) # => 88_000
p david.bonus(3) # => 30_000