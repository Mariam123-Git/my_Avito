class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]
  before_action :set_user
  before_action :set_review, only: [ :edit, :update, :destroy ]
  before_action :authorize_reviewer, only: [ :edit, :update, :destroy ]
  before_action :check_if_already_reviewed, only: [ :new, :create ]
  before_action :check_if_self_review, only: [ :new, :create ]

  def index
    @reviews = @user.received_reviews.includes(:reviewer).order(created_at: :desc)
  end

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.user = @user
    @review.reviewer = current_user

    if @review.save
      redirect_to user_path(@user), notice: "Votre avis a été publié avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to user_path(@user), notice: "Votre avis a été mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to user_path(@user), notice: "Votre avis a été supprimé avec succès."
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def authorize_reviewer
    unless @review.reviewer == current_user
      redirect_to user_path(@user), alert: "Vous n'êtes pas autorisé à modifier cet avis."
    end
  end

  def check_if_already_reviewed
    if current_user.has_reviewed?(@user)
      redirect_to user_path(@user), alert: "Vous avez déjà laissé un avis pour cet utilisateur. Vous pouvez le modifier si vous le souhaitez."
    end
  end

  def check_if_self_review
    if @user == current_user
      redirect_to user_path(@user), alert: "Vous ne pouvez pas laisser un avis sur vous-même."
    end
  end
end
