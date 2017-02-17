class Admin::ArticlesController < Admin::BaseController
  include ApplicationHelper
  before_action :set_article,only: [:show,:edit,:update,:destroy]

  def index
    @articles = Article.includes(:category,:tags).order("created_at desc")
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def show
  end

  def create
    @article = Article.new
    respond_to do |format|
      if @article.update article_params
        format.html {redirect_to admin_articles_path,notice: "创建成功！"}
        format.json {render :show, status: :created, location: @article}
      else
        format.html { render :new}
        format.json { render json: @article.errors, status: :unprocessable_entity}
      end
    end
  end

  def update
  respond_to do |fmt|
    if @article.update article_params
      format.html {redirect_to admin_articles_path, notice: '修改成功！'}
      format.json {render :show, status: :ok, location: @article}
    else
      format.html { render :edit}
      format.json { render json: @article.errors, status: :unprocessable_entity}
    end
  end
  end

  def view
    content = markdown params[:content]
    puts(content)
    render json: {content: content}
  end

  def destroy
    if @article.destroy
      flash[:notice] = '删除成功！'
    else
      flash[:error] = '删除失败！'
    end
    redirect_to admin_articles_path
  end

  private
  def set_article
    begin
    @article = Article.find params[:id]
    rescue => e
      flash[:error] = "找不到数据"
    end
  end

  def article_params
    params.require(:articles).permit(:title, :category_id , :content, tag_ids: [])
  end
end
