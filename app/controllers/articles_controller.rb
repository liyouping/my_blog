class ArticlesController < BaseController

  before_action :set_article,only: [:show]

  def index

    @articles = Article.includes(:tags).where(Article.get_conditions params).order('created_at desc').page(params[:page]).per(10)

  end

  def show
    if @article.nil?
      render :file => "/public/404.html", :status => 404,layout: false
    else
      access = Access.find_or_create_by(article_id: @article.id)
      access.update count: (@article.access.count + 1)
    end

  end

  def about

  end

  def contact
    @contact = Contact.new
  end

  #留言
  def send_message
    @contact = Contact.new contact_params
    if @contact.save
      UserMailer.send_msg_to_me(@contact).deliver_now
    end
    redirect_to contact_articles_path,notice: '谢谢您的留言，我会尽快回复您！'
  end

  private
  def set_article
    begin
      @article = Article.find params[:id]
    rescue => e
      flash[:error] = '找不到数据'
    end
  end

  def contact_params
    params.require(:contact).permit(:name, :tel, :email, :message)
  end

end
