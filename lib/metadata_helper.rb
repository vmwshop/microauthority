module MetadataHelper
  def list_item(title,val, opts = {})

    item_class   = opts.fetch(:class, "")
    pluralize    = opts.fetch(:pluralize, true)
    width        = opts.fetch(:width, 8)
    join_char    = opts.fetch(:join_char, "<br/>")
    title_link   = opts.fetch(:title_link, nil)


    val = display_value(val, opts.merge({return_array: true}))
    return "" if val.nil?

    title = val.count <= 1 ? title.singularize : title.pluralize if pluralize
    if title_link
      if title_link.is_a? String
        title = "<a href='#{title_link}' target='_blank'>#{title}</a>" 
      elsif title_link.is_a?(Array) && title_link.count == 1
        title = "<a href='#{title_link.first}' target='_blank'>#{title}</a>" 
      elsif title_link.is_a?(Array) && title_link.count > 1
        title_links = title_link.collect.with_index {|tl,i| "<a href='#{tl}' target='_blank'>#{i+1}</a>"}.join(", ")
        title = "#{title} (#{title_links})"
      else
        title
      end
    end
    str = "<dt class='col-md-#{12-width}'>#{title}</dt>\n"
    str << "<dd class='col-md-#{width} #{item_class}'>#{val.join(join_char)}</dd>"

  end 

  def first_or_only(obj)
    [obj].flatten(1).first
  end

  def display_value(val,opts = {})
    default_text = opts.fetch(:default_text, "n/a")
    is_link      = opts.fetch(:is_link, false)
    field        = opts.fetch(:field, nil)
    join_char    = opts.fetch(:join_char, "<br/>")
    show_blank   = opts.fetch(:show_blank, false)
    return_array = opts.fetch(:return_array, false)

    return nil if !show_blank && (val.nil? || val.empty?) 

    val = [val].flatten(1)
    val = val.map{|v| v[field]} if field
    

    if val.empty?
      val = ["<span class='not-available'>#{default_text}</span>"]
    elsif is_link
      val = val.map{|v| "<a href='#{v}' target='_blank'>#{v}</a>"}
    end

    if return_array
      val
    else
      val.join(join_char)
    end
  end

  # This allows the retrieval of E55_Types that have been assigned using
  # E17_Type_Assignment with a P21_had_general_purpose.  By default, it
  # will pull the label from the type, but you can pass it another field
  # (such as `note`) if you'd prefer.
  #
  # @param obj     [Array, Hash]  the object P41i_was_classified_by
  # @param purpose [String]       the uri for the purpose 
  # @param field   [<type>]       the predicate to retrieve from the E55_Typ.
  #
  # @return [String, Array] The values for the field
  # 
  def by_general_purpose(obj, purpose, field="label")
    arr = by_generic(obj, purpose, "general_purpose", "assigned_type")

    return nil if arr.nil? 

    if arr.is_a? Hash
      arr.dig(field)
    elsif arr.is_a? Array
      arr.map{|o| o.dig(field)}
    end
  end

  def deprefix(uri, context) 
    arr = uri.split(":")
    replacement_value = ""
    context.each do |c|
      if c.is_a?(Hash) && c.keys.include?(arr.first)
        arr[0] = c[arr.first]
        return arr.join("")
      end
    end
    return nil
  end

  def by_classification(obj, classification, field="value") 
    by_generic(obj, classification, "classified_as", field)
  end

  def except_classification(obj, classification, field="value") 
    by_generic(obj, classification, "classified_as", field, {negate: true})
  end

  def by_type(obj, type, field="value") 
    by_generic(obj, type, "type", field)
  end

  protected

  def by_generic(obj, generic, generic_class, field, opts= {}) 
    return nil if obj.nil? || generic.nil?

    negate = opts.fetch(:negate, false)

    arr = [obj].flatten(1).find_all do |o| 
      val = o[generic_class].include?(generic) ||
      o[generic_class].is_a?(Hash) && o[generic_class]["id"].include?(generic) ||
      o[generic_class].is_a?(Array) && o[generic_class].find_index{|sub_o| sub_o["id"].include?(generic)}
      
      negate ? !val : val
    end

    case arr.count
    when 0
      nil
    when 1
      [field].flatten(1).each{|f| return arr[0][f] if arr[0][f] }
      nil
    else
      values = []
      arr.each do |item|
        [field].flatten(1).each do |f|
           if item[f]
            values.push item[f] 
            break
          end
        end
      end
      values
    end 
  end
end

