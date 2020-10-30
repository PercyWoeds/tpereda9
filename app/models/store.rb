

class Store < ActiveRecord::Base


 belongs_to :stock


def self.search(search)
  if search
    find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
  else
    find(:all)
  end
end

end 