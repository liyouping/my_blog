class Admin::TagsController < Admin::BaseController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all.order('created_at desc')
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to admin_tags_path, notice: '标签创建成功！' }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to admin_tags_path, notice: '标签修改成功！' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    if @tag.article_tags.present?
      flash[:error] = '删除失败，有博客下有此标签！'
    else
      respond_to do |format|
        if  @tag.destroy
        format.html { redirect_to admin_tags_url, notice: '标签删除成功！' }
        format.json { head :no_content }
        else
          format.html { redirect_to admin_tags_url, notice: '标签删除失败！' }
          format.json { head :no_content }
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      begin
        @tag= Tag.find params[:id]
      rescue => e
        flash[:error] = '找不到数据'
        redirect_to admins_tags_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:name)
    end
end
