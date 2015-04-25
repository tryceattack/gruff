require 'RMagick'

class Gruff::CustomPie
  include Magick
  attr_accessor :pie_center_x
  attr_accessor :d
  attr_accessor :pie_center_y
  attr_accessor :pie_radius

  def initialize(image_path)
    @base_image = Image.read(image_path)[0]
    @d = Draw.new
    @data = Array.new
    
    @columns = @base_image.columns
    @rows = @base_image.rows
  end

  def set_pie_geometry(x, y, radius)
    @pie_center_x = x
    @pie_center_y = y
    @pie_radius = radius
  end

  def insert_pie_data(name, data_points=[])
    data_points = Array(data_points) # make sure it's an array
    @data << [name, data_points]
  end

  def insert_text(x_offset, y_offset, text, features = {})
    @d = Draw.new # Reset to default features
    features.each { |feature, attribute|
      set_feature(feature, attribute)
    }
    @d.annotate(@base_image, 0 ,0, x_offset, y_offset, text)
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
