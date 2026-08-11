class Airport < ActiveHash::Base
  fields :name, :code

  self.data = (1..25).map do |i|
    {id: i, name: "Airport #{i.to_s.rjust(2, "0")}", code: "AP#{i}"}
  end
end
