class RestCategoriesController < ApplicationController
  require 'fileutils'
  before_filter :admin_required

  # GET /rest_categories
  # GET /rest_categories.xml
  def index
    @rest_categories = RestCategory.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rest_categories }
    end
  end

  # GET /rest_categories/1
  # GET /rest_categories/1.xml
  def show
    @rest_category = RestCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rest_category }
    end
  end

  # GET /rest_categories/new
  # GET /rest_categories/new.xml
  def new
    @rest_category = RestCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rest_category }
    end
  end

  # GET /rest_categories/1/edit
  def edit
    @rest_category = RestCategory.find(params[:id])
  end

  # POST /rest_categories
  # POST /rest_categories.xml
  def create
    @rest_category = RestCategory.new(params[:rest_category])

    respond_to do |format|
      if @rest_category.save
        @rest_category.delcategoryphoto(RestCategory::PREFIX_ROUTE)      
        flash[:notice] = t(:category_created)
        format.html { redirect_to(@rest_category) }
        format.xml  { render :xml => @rest_category, :status => :created, :location => @rest_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rest_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rest_categories/1
  # PUT /rest_categories/1.xml
  def update
    @rest_category = RestCategory.find(params[:id])

    respond_to do |format|
      if @rest_category.update_attributes(params[:rest_category])
        @rest_category.delcategoryphoto(RestCategory::PREFIX_ROUTE)
        flash[:notice] = t(:category_updated)
        format.html { redirect_to(@rest_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rest_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rest_categories/1
  # DELETE /rest_categories/1.xml
  def destroy
    @rest_category = RestCategory.find(params[:id])
    @rest_category.destroy

    respond_to do |format|
      format.html { redirect_to(rest_categories_url) }
      format.xml  { head :ok }
    end
  end
end
