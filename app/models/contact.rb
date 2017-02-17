class Contact < ApplicationRecord
  validates_presence_of :name,:email,:tel,:message

end
