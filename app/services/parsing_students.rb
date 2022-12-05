require "nokogiri"
require "open-uri"

class ParsingStudents

  def initialize
    html_file = File.open(Rails.root.join("classmates.html.erb"))
    @html_doc = Nokogiri::HTML(html_file)
  end

  def call
    @html_doc.search('[data-ajax-delete-target="record"]').each do |element|
      avatar_id = element.search("img").attr("src").value.split("/").last
      next if avatar_id.ends_with?(".jpg")

      first_name = element.search("strong").text.split[0]
      last_name = element.search("strong").text.split[1]

      new_user = User.create!(
          first_name: first_name,
          last_name: last_name,
          email: "#{first_name}.#{last_name}@mail.com",
          password: "123456"
        )

    file = URI.open("https://avatars.githubusercontent.com/u/#{avatar_id}")
    new_user.avatar.attach(io: file, filename: "first_name.png", content_type: "image/png")
    new_user.save


    end
  end

end
