require 'csv'

class UploadController < ApplicationController

  def index

  end


  def upload
    csv_array  = []

    CSV.foreach(params[:doc][:doc].tempfile, quote_char: '"', col_sep: ';', row_sep: :auto, headers: true) do |row|
      csv_array << row
    end

    csv_array.each do |row|
      hash = row.to_hash
      next if hash["name"].nil?
      category = Spree::ShippingCategory.find_or_create_by(name: hash["category"])
      product = Spree::Product.new({name: hash["name"], description: hash["description"], available_on: hash["availability_date"], slug: hash["slug"]})
      product.shipping_category = category
      product.price = hash["price"]

      category.save if category.valid?
      product.save if product.valid?

    end

  end
end
