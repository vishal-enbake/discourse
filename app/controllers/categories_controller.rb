require_dependency 'category_serializer'

class CategoriesController < ApplicationController

#  skip_before_filter :all, only:[:connect_facebook, :get_fb_token]
  before_filter :ensure_logged_in, except: [:index, :show, :connect_facebook, :get_fb_token]
  before_filter :fetch_category, only: [:show, :update, :destroy]
  skip_before_filter :check_xhr, only: [:index,:connect_facebook, :get_fb_token]
  skip_before_filter :verify_authenticity_token if Rails.env.test?

  def index
    @list = CategoryList.new(guardian)

    @list.draft_key = Draft::NEW_TOPIC
    @list.draft_sequence = DraftSequence.current(current_user, Draft::NEW_TOPIC)
    @list.draft = Draft.get(current_user, @list.draft_key, @list.draft_sequence) if current_user

    discourse_expires_in 15.minute

    store_preloaded("categories_list", MultiJson.dump(CategoryListSerializer.new(@list, scope: guardian)))
    respond_to do |format|
      format.html { render }
      format.json { render_serialized(@list, CategoryListSerializer) }
    end
  end

  def show
    render_serialized(@category, CategorySerializer)
  end

  def create
    guardian.ensure_can_create!(Category)

    @category = Category.create(category_params.merge(user: current_user))
    return render_json_error(@category) unless @category.save

    render_serialized(@category, CategorySerializer)
  end

  def update
    guardian.ensure_can_edit!(@category)
    json_result(@category, serializer: CategorySerializer) { |cat| cat.update_attributes(category_params) }
  end

  def destroy
    guardian.ensure_can_delete!(@category)
    @category.destroy
    render nothing: true
  end
  
  def connect_facebook
    session[:oauth] = Koala::Facebook::OAuth.new('670651996278456','b1a66ee356054c8a77f2e5f5dd0f57ef', "#{request.protocol}#{request.host}/categories/get_fb_token/")
    @auth_url = session[:oauth].url_for_oauth_code() 
    redirect_to @auth_url 
  end
  
  def get_fb_token
    
    if params[:code]
      session[:facebook_access_token] = session[:oauth].get_access_token(params[:code])
      @api = Koala::Facebook::API.new(session[:facebook_access_token])
#      @user_id = @api.get_obect('me')['id'] #to get facebook user id

      @user_name = @api.get_object('me')['name'] #facebook user name
      @user_first_name = @api.get_object('me')['first_name'] #facebook user first name
      @user_last_name = @api.get_object('me')['last_name'] #facebook user last name
      @user_pic = "https://graph.facebook.com/#{@user_id}/picture?type=small" # user pic
    end
  end

  private

    def required_param_keys
      [:name, :color, :text_color]
    end

    def category_param_keys
      [required_param_keys, :hotness, :secure, :group_names, :auto_close_days].flatten!
    end

    def category_params
      required_param_keys.each do |key|
        params.require(key)
      end

      params.permit(*category_param_keys)
    end
    
    

   def categories
     Label.update_all(["completed_at=?", Time.now], :id => params[:task_ids])
   end



    def fetch_category
      @category = Category.where(slug: params[:id]).first || Category.where(id: params[:id].to_i).first
    end
  
  
end
