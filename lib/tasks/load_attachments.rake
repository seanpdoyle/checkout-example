desc "Attach ActiveStorage files from fixtures"
task "db:fixtures:load_attachments" => :environment do
  fixtures_path = Pathname(ActiveRecord::Tasks::DatabaseTasks.fixtures_path)

  Book.all.each do |book|
    filename = "#{book.title.parameterize(separator: "_").underscore}.png"
    image = fixtures_path.join("files", filename)

    if image.exist?
      book.cover.attach(
        io: image.open,
        filename: filename,
        content_type: "image/png"
      )
      book.save!
    end
  end
end
