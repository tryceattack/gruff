require 'RMagick'

class Gruff::CustomPie
  include Magick
  attr_accessor :pie_center_x
  attr_accessor :pie_center_y
  attr_accessor :pie_radius

  def initialize(image_path)
    @base_image = Image.read(image_path)[0]
    @d = Draw.new
    @data = Hash.new
    
    @columns = @base_image.columns
    @rows = @base_image.rows
    set_pie_colors(%w(#abaf00 purple green white red))
  end

  def set_pie_geometry(x, y, radius)
    @pie_center_x = x
    @pie_center_y = y
    @pie_radius = radius
  end

  def set_pie_colors(list)
    @colors = list
  end
  def insert_pie_data(name, data_point)
    if data_point > 0
      @data[name] =  data_point
    end
  end

  def insert_text(x_offset, y_offset, text, features = {})
    @d = Draw.new # Reset to default features
    features.each { |feature, attribute|
      set_feature(feature, attribute)
    }
    @d.annotate(@base_image, 0 ,0, x_offset, y_offset, text)
  end

  def draw
    @d = Draw.new
    @d.stroke_width(@pie_radius)
    total_sum = 0.0
    prev_degrees = 0.0
    @data.each {|data_row| total_sum += data_row[1] }
    @sorted_data = @data.sort_by{|key,value| -value}
    @sorted_data.each_with_index do |data_row, index|
      @d = @d.stroke @colors[index % @colors.size]
      current_degrees = (data_row[1] / total_sum) * 360.0
      # ellipse will draw the the stroke centered on the first two parameters offset by the second two.
      # therefore, in order to draw a circle of the proper diameter we must center the stroke at
      # half the radius for both x and y
      @d = @d.ellipse(@pie_center_x, @pie_center_y,
                @pie_radius / 2.0, @pie_radius / 2.0,
                prev_degrees, prev_degrees + current_degrees + 0.5) # <= +0.5 'fudge factor' gets rid of the ugly gaps
      half_angle = prev_degrees + current_degrees / 2 # Used for labels
      prev_degrees += current_degrees
    end
    @d.draw(@base_image)
  end

  def write(filename='graph.png')
    @base_image.write(filename)
  end

  def set_feature(feature, attribute)
    case feature
      when 'fill'
        @d.fill = attribute
      when 'font'
        @d.font = attribute
      when 'font_family'
        @d.font_family = attribute
      when 'font_stretch'
        @d.font_stretch = attribute
      when 'font_style'
        @d.font_style = attribute
      when 'font_weight'
        @d.font_weight = attribute
      when 'stroke'
        @d.stroke = attribute
      when 'pointsize'
        @d.pointsize = attribute
    end
  end
end
