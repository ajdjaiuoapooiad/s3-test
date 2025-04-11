class Api::V1::ItemsController < ApplicationController
  def index
    @items = Item.all.map do |item|
      item.as_json.merge(file_url: item.file.attached? ? url_for(item.file) : nil)
    end
    render json: @items
  end

  def show
    @item = Item.find(params[:id])
    render json: @item.as_json.merge(file_url: @item.file.attached? ? url_for(@item.file) : nil)
  end

  def create
    @item = Item.new(item_params)
    if params[:file]
      @item.file.attach(params[:file])
    end

    if @item.save
      render json: @item.as_json.merge(file_url: @item.file.attached? ? url_for(@item.file) : nil), status: :created
    else
      render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def file_url
    @item = Item.find(params[:id])
    if @item.file.attached?
      render json: { url: url_for(@item.file) }
    else
      render json: { error: 'File not attached' }, status: :not_found
    end
  end

  private

  def item_params
    params.permit(:name)
  end
end