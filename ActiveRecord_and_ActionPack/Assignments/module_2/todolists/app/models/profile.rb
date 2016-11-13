class Profile < ActiveRecord::Base
  belongs_to :user

  validate :validate_name
  validates :gender, inclusion: { in: %w(male female) }
  validate :validate_sue

  def validate_name
  	unless first_name || last_name
  		errors.add(:first_name, "first_name and last_name can't be null both!")
  	end
  end
  def validate_sue
  	if gender == "male" and first_name == "Sue"
  		errors.add(:first_name, "first_name can't be 'Sue' while you're male!")
  	end
  end

  def self.get_all_profiles min_year, max_year
		self.where('birth_year between ? and ?', min_year, max_year).order(birth_year: :asc)
	end
end