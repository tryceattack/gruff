require 'RMagick'

class Gruff::CustomPie
  include Magick
  attr_accessor :pie_center_x
  attr_accessor :pie_center_y
  attr_accessor :pie_radius

  def initialize(image_path)
    @base_image = Image.read(image_path)[0]
    @d = Draw.new
    @data = Hash.new # Value is array with two items
    @aggregate = Array([0,0,0,0]) # Cluster brands into categories
    @columns = @base_image.columns
    @rows = @base_image.rows
    set_pie_colors(%w(#AD1F25 #BE6428 #C1B630 #1E753B))
  end

  def set_pie_geometry(x, y, radius)
    @pie_center_x = x
    @pie_center_y = y
    @pie_radius = radius
  end

  def set_pie_colors(list)
    @colors = list
  end

  def insert_pie_data(name, amount, quality)
    #convert all '&#39; instances to an apostrophe
    name = name.gsub(/&#39;/, "\'")
    @data[name] =  [amount, quality]
    @aggregate[quality] += amount
  end

  def insert_text(x_offset, y_offset, text, features = {})
    features.each { |feature, attribute|
      set_feature(feature, attribute)
    }
    #puts @d.get_type_metrics(@base_image, text.to_s).width,@d.get_type_metrics(@base_image, text.to_s).height,text
    @d.annotate(@base_image, 0 ,0, x_offset, y_offset, text)
  end

  def draw
    if @data.size > 0
      @d = Draw.new
      @d.stroke_width(@pie_radius)
      total_sum = 0.0
      prev_degrees = 60.0
      @d.fill_opacity(0) # VERY IMPORTANT, otherwise undesired artifact can result.
      total_sum = @aggregate.inject(:+) + 0.0 # Sum elements and make it a float
      @aggregate.each_with_index do |data_row, index|
        next if data_row == 0 
        @d = @d.stroke @colors[index]
        current_degrees = (data_row / total_sum) * 360.0
        # ellipse will draw the the stroke centered on the first two parameters offset by the second two.
        # therefore, in order to draw a circle of the proper diameter we must center the stroke at
        # half the radius for both x and y
        @d = @d.ellipse(@pie_center_x, @pie_center_y,
                  @pie_radius / 2.0, @pie_radius / 2.0,
                  prev_degrees, prev_degrees + current_degrees + 0.5) # <= +0.5 'fudge factor' gets rid of the ugly gaps
        half_angle = prev_degrees + current_degrees / 2
        label_string = '$' + data_row.to_s 
        draw_pie_label(@pie_center_x,@pie_center_y, half_angle, @pie_radius, label_string)
        prev_degrees += current_degrees
      end
      @d.draw(@base_image)
    end
  end

  def write(filename='graph.png')
    draw
    draw_labels
    @base_image.write(filename)
  end

  def draw_labels
    @d.pointsize = 56
    @d.align = LeftAlign
    sorted_data = @data.sort_by{|key,value| -value[1]} # Sort by descending quality
    x_offset = 180
    y_offset = 440
    for data in sorted_data
      if data[1][0] > 0 # Amount > 0
        font_weight = 900 # Very Bold
        text = data[0] + ' <--'
      else
        text = data[0]
        font_weight = 900 # Normal
      end
      case data[1][1]
        when 3
          insert_text(x_offset, y_offset, text, {'fill'=> '#1E753B', 'font_weight'=> font_weight })
        when 2
          insert_text(x_offset, y_offset, text, {'fill'=> '#C1B630', 'font_weight'=> font_weight })
        when 1
          insert_text(x_offset, y_offset, text, {'fill'=> '#BE6428', 'font_weight'=> font_weight })
        when 0
          insert_text(x_offset, y_offset, text, {'fill'=> '#AD1F25', 'font_weight'=> font_weight })
      end
      y_offset += 60
    end
  end

  def draw_pie_label(center_x, center_y, angle, radius, percent)
    @d.pointsize = 56
    width = @d.get_type_metrics(@base_image, percent.to_s).width
    ascent =  @d.get_type_metrics(@base_image, percent.to_s).ascent
    descent =  @d.get_type_metrics(@base_image, percent.to_s).descent
    radians = angle * Math::PI / 180.0
    x = center_x +  radius * Math.cos(radians)
    # By default, text is centered at bottom, so need to shift to center it
    y =  center_y + ascent / 2.0 + radius * Math.sin(radians) 
    # Imagine the text box around the text
    # Shift text box so a corner is tangent to circle
    if x > center_x
      x += width / 2.0
    end
    if x < center_x
      x -= width / 2.0
    end
    if y > center_y
      y += ascent / 2.0
    end
    if y < center_y
      y -= (ascent / 2.0 - descent) # descent to account for '$' descent, 
      # descent value retrieved is negative, so sub instead of add
    end
    
    @d.align = CenterAlign
    insert_text(x, y, percent, {'fill'=> 'black', 'font_weight'=> 700})
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
      when 'text_undercolor'
        @d.undercolor = attribute
    end
  end
end
