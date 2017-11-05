module ApplicationHelper

  def get_country_code_options
    options = []
    PhonyRails::country_codes_hash.each do |code|
      country = ISO3166::Country.new(code[0])
      options << ["#{country.name} +#{country.country_code}".html_safe, "+#{country.country_code}"] if country
    end
    options
  end
end
