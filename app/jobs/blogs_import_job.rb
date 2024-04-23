class BlogsImportJob < ApplicationJob
  queue_as :default

  def perform(file)
    data = CSV.parse(file.to_io, headers: true, encoding: 'utf-8')

    ActiveRecord::Base.transaction do
      data.each_slice(1000) do |batch|
        Blog.upsert_all(batch.map(&:to_h), unique_by: :id)
      end
    end
  rescue StandardError => e
    Rails.logger.error("Uploading got an issue: #{e.message}")
  end
end
