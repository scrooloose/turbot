require Rails.root.join('spec', 'support', 'test_files_helper.rb')

FactoryGirl.define do
  factory :profile do
    sequence :pof_key do |n|
      n
    end

    sequence :username do |n|
      "pof_user_#{n}"
    end

    transient do
      interests []
    end

    page_content do |evaluator|
      unless evaluator.attributes["page_content"]
        ProfileFactoryHelper.pof_page_content_for(
          evaluator.attributes.merge(interests: evaluator.interests).symbolize_keys
        )
      end
    end

    trait :emma do
      pof_key "82945044"
      page_content File.read(Rails.root.join('spec', 'test_files', 'emma.html'))
    end
  end
end

module ProfileFactoryHelper
  extend TestFilesHelper

  def self.pof_page_content_for(params)
    page = Nokogiri.HTML(test_file_content('base.html'))

    params[:interests]&.each do |interest|
      new_interest = %Q(<li class="text-lg"><a href="/interests/#{interest}">#{interest}</a></li>)
      page.at_css('#profile-interests-wrapper .nav') << new_interest
    end

    page.at_css('.profile-description').content = params[:bio]

    page_content = page.to_html
    page_content.gsub!(/POF_KEY_HERE/, params[:pof_key])
    page_content.gsub!(/POF_USERNAME_HERE/, params[:username])
  end

end
