class UsersController < ApplicationController
before_action :set_user, only: [:show, :edit, :update, :destroy]

	def index
		@users = User.all
	end

	def new
		@user = User.new
	end

	def show
		repo_json = (Github.repos.list user: @user.nickname).to_json
		parsed_repos = JSON.parse repo_json
		@repo_hash = {}
		parsed_repos.each {|n| @repo_hash[n['name']] = n['html_url']}
	end

	def edit
	end

	def update
		respond_to do |format|
			if @user.update(user_params)
				format.html { redirect_to @user, notice: 'User was successfully updated.' }
				format.json { render :show, status: :ok, location: @user }
			else
				format.html { render :edit }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@user.destroy
		respond_to do |format|
			format.html { redirect_to root_path, notice: 'User was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private

		def set_user
			@user = User.find(params[:id])
		end

		def profile_params
			params.require(:user).permit(:nickname, :email)
		end


end
