module ApplicationHelper
  def gender_symbol(gender) 
    if gender == 'female'
      raw "&#9792;"
    elsif gender == 'male'
      raw "&#9794;"
    else
      raw ""
    end
  end
end
