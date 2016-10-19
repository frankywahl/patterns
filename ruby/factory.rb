# frozen_string_literal: true
class Shape
  def circumference
    raise NotImplementedError, "You have to implement #{self.class}##{__method__}"
  end
end

class Circle < Shape
  attr_accessor :radius
  def circumference
    2 * Math::PI * radius
  end
end

class Square
  attr_accessor :side
  def circumference
    4 * side
  end
end

class ShapeFactory
  def self.create(type)
    self.class.const_get("#{type.capitalize}").new
  end
end

shape = ShapeFactory.create(:circle)
puts shape.class
